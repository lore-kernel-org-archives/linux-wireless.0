Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64723 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2AKNMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 08:12:14 -0500
Message-ID: <4F0D8AA6.4070205@qca.qualcomm.com> (sfid-20120111_141217_822449_4D95C116)
Date: Wed, 11 Jan 2012 15:12:06 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai <tpachamu@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 4/4] ath6kl: Add UAPSD support in tx path.
References: <1326095152-1663-1-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326095152-1663-1-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 09:45 AM, Thirumalai wrote:
> If tx is not because of uAPSD trigger and if power save is
> enabled then queue the packet uAPSD queue.
> 
> Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>

[...]

> +static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
> +				struct ath6kl_vif *vif,
> +				struct sk_buff *skb,
> +				u32 *flags)
> +{
> +	struct ath6kl *ar = vif->ar;
> +	bool ps_queued = false, is_apsdq_empty = false;
> +	struct ethhdr *datap = (struct ethhdr *) skb->data;
> +	u8 up = 0;
> +	u8 traffic_class;
> +	u16 ether_type;
> +	u8 *ip_hdr;
> +	struct ath6kl_llc_snap_hdr *llc_hdr;

There's a lot unnecessarily indented code here which is makes it harder
to read than it really is. A good rule to follow is that always try to
indent code only for error paths, the main code flow should not be indented.

For example, you could do it like this and you can get rid of ps_queued
variable as well:

if (conn->sta_flags & STA_PS_APSD_TRIGGER) {
	...
	return false;
} else if (!conn->apsd_info) {
	return false;
}

....

if ((conn->apsd_info & (1 << traffic_class) == 0)
	return false;

...

return true;

> +		if (test_bit(WMM_ENABLED, &vif->flags)) {
> +			ether_type = datap->h_proto;
> +			if (is_ethertype(be16_to_cpu(ether_type))) {
> +				/* packet is in DIX format  */
> +				ip_hdr = (u8 *)(datap + 1);
> +			} else {
> +				/* packet is in 802.3 format */
> +				llc_hdr = (struct ath6kl_llc_snap_hdr *)
> +							(datap + 1);
> +				ether_type = llc_hdr->eth_type;
> +				ip_hdr = (u8 *)(llc_hdr + 1);
> +			}
> +
> +			if (ether_type == cpu_to_be16(IP_ETHERTYPE))
> +				up = ath6kl_wmi_determine_user_priority(
> +						ip_hdr, 0);
> +		}

And from earlier:

+	u8 up = 0;

So up will be zero if wmm is not enabled? Maybe you could make it more
obvious by not initialising the variable in the beginning of function
but instead adding an else branch and initialising it to zero there.

> +static bool ath6kl_process_psq(struct ath6kl_sta *conn,
> +				struct ath6kl_vif *vif,
> +				struct sk_buff *skb,
> +				u32 *flags)
> +{
> +	bool ps_queued = false, is_psq_empty = false;
> +	struct ath6kl *ar = vif->ar;
> +
> +	if (conn->sta_flags & STA_PS_POLLED) {
> +		spin_lock_bh(&conn->psq_lock);
> +		if (!skb_queue_empty(&conn->psq))
> +			*flags |= WMI_DATA_HDR_FLAGS_MORE;
> +		spin_unlock_bh(&conn->psq_lock);
> +	} else {
> +		/* Queue the frames if the STA is sleeping */
> +		spin_lock_bh(&conn->psq_lock);
> +		is_psq_empty = skb_queue_empty(&conn->psq);
> +		skb_queue_tail(&conn->psq, skb);
> +		spin_unlock_bh(&conn->psq_lock);
> +
> +		/*
> +		 * If this is the first pkt getting queued
> +		 * for this STA, update the PVB for this
> +		 * STA.
> +		 */
> +		if (is_psq_empty)
> +			ath6kl_wmi_set_pvb_cmd(ar->wmi,
> +					vif->fw_vif_idx,
> +					conn->aid, 1);
> +		ps_queued = true;
> +	}
> +	return ps_queued;
> +}

Similar comment about code flow. If you do it like this:

if (conn->sta_flags & STA_PS_POLLED) {
	...
	return false;
}

....

return true;

it will be easier to read and ps_queued is not needed.

Kalle
