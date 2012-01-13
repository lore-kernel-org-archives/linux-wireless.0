Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45662 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AMLv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 06:51:56 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Message-ID: <4F101AA9.90004@qca.qualcomm.com> (sfid-20120113_125200_465283_EDD3AA6E)
Date: Fri, 13 Jan 2012 13:51:05 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add support for uAPSD
References: <1326372699-6344-1-git-send-email-tpachamu@qca.qualcomm.com> <1326372699-6344-2-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326372699-6344-2-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thirumalai,

On 01/12/2012 02:51 PM, Thirumalai Pachamuthu wrote:
> * A new APSD power save queue is added in the station structure.
> * When a station has APSD capability and goes to power save, the frame
>   designated to the station will be buffered in APSD queue.
> * When the host receives a frame which the firmware marked as trigger,
>   host delivers the buffered frame from the APSD power save queue.
>   Number of frames to deliver is decided by MAX SP length.
> * When a station moves from sleep to awake state, all frames buffered
>   in APSD power save queue are sent to the firmware.
> * When a station is disconnected, all frames bufferes in APSD power save
>   queue are dropped.
> * When the host queues the first frame to the APSD queue or removes the
>   last frame from the APSD queue, it is indicated to the firmware using
>   WMI_AP_APSD_BUFFERED_TRAFFIC_CMD.
> 
> Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>

Thanks, I applied your patch with these changes below. Please check that
I didn't break anything.

> +static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
> +				struct ath6kl_vif *vif,
> +				struct sk_buff *skb,
> +				u32 *flags)
> +{
> +	struct ath6kl *ar = vif->ar;
> +	bool is_apsdq_empty = false;
> +	struct ethhdr *datap = (struct ethhdr *) skb->data;
> +	u8 up = 0;

This is initilised in an else branch I added below.

> +	u8 traffic_class;
> +	u16 ether_type;
> +	u8 *ip_hdr;
> +	struct ath6kl_llc_snap_hdr *llc_hdr;

I combined the same type variable declarations here.

> +
> +	if (conn->sta_flags & STA_PS_APSD_TRIGGER) {
> +		/*
> +		 * This tx is because of a uAPSD trigger, determine
> +		 * more and EOSP bit. Set EOSP if queue is empty
> +		 * or sufficient frames are delivered for this trigger.
> +		 */
> +		spin_lock_bh(&conn->psq_lock);
> +		if (!skb_queue_empty(&conn->apsdq))
> +			*flags |= WMI_DATA_HDR_FLAGS_MORE;
> +		else if (conn->sta_flags & STA_PS_APSD_EOSP)
> +			*flags |= WMI_DATA_HDR_FLAGS_EOSP;
> +		*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
> +		spin_unlock_bh(&conn->psq_lock);
> +		return false;
> +	} else if (!conn->apsd_info)
> +		return false;
> +
> +	if (test_bit(WMM_ENABLED, &vif->flags)) {
> +		ether_type = be16_to_cpu(datap->h_proto);
> +		if (is_ethertype(ether_type)) {
> +			/* packet is in DIX format  */
> +			ip_hdr = (u8 *)(datap + 1);
> +		} else {
> +			/* packet is in 802.3 format */
> +			llc_hdr = (struct ath6kl_llc_snap_hdr *)
> +							(datap + 1);
> +			ether_type = be16_to_cpu(llc_hdr->eth_type);
> +			ip_hdr = (u8 *)(llc_hdr + 1);
> +		}
> +
> +		if (ether_type == IP_ETHERTYPE)
> +			up = ath6kl_wmi_determine_user_priority(
> +							ip_hdr, 0);
> +	}

I added the else branch here.

> +static bool ath6kl_process_psq(struct ath6kl_sta *conn,
> +				struct ath6kl_vif *vif,
> +				struct sk_buff *skb,
> +				u32 *flags)
> +{
> +	bool is_psq_empty = false;
> +	struct ath6kl *ar = vif->ar;
> +
> +	if (conn->sta_flags & STA_PS_POLLED) {
> +		spin_lock_bh(&conn->psq_lock);
> +		if (!skb_queue_empty(&conn->psq))
> +			*flags |= WMI_DATA_HDR_FLAGS_MORE;
> +		spin_unlock_bh(&conn->psq_lock);
> +		return false;
> +	} else {
> +		/* Queue the frames if the STA is sleeping */

The else block is not needed as there's a return in the if block above.
So the code below can be taken out of the else block.

> +static void ath6kl_uapsd_trigger_frame_rx(struct ath6kl_vif *vif,
> +						 struct ath6kl_sta *conn)
> +{
> +	struct ath6kl *ar = vif->ar;
> +	bool is_apsdq_empty;
> +	bool is_apsdq_empty_at_start;
> +	u32 num_frames_to_deliver;
> +	struct sk_buff *skb = NULL;
> +	u32 flags;

Combined variable declarations.

>  				spin_lock_bh(&conn->psq_lock);
> -				while ((skbuff = skb_dequeue(&conn->psq))
> -				       != NULL) {
> +				while ((skbuff = skb_dequeue(&conn->psq))) {
> +					spin_unlock_bh(&conn->psq_lock);
> +					ath6kl_data_tx(skbuff, vif->ndev);
> +					spin_lock_bh(&conn->psq_lock);
> +					skbuff = skb_dequeue(&conn->psq);
> +				}

This was buggy now. After the first skb you will take two skbs in one round.

> +
> +				is_apsdq_empty = skb_queue_empty(&conn->apsdq);
> +				while ((skbuff = skb_dequeue(&conn->apsdq))) {
>  					spin_unlock_bh(&conn->psq_lock);
>  					ath6kl_data_tx(skbuff, vif->ndev);
>  					spin_lock_bh(&conn->psq_lock);
> +					skbuff = skb_dequeue(&conn->apsdq);
>  				}

And this had the same bug.

Kalle
