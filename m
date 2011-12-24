Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1LXBWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 20:22:55 -0500
Message-ID: <4EF528DE.5090407@qca.qualcomm.com> (sfid-20111224_022259_277294_0FEB4B7D)
Date: Sat, 24 Dec 2011 03:20:30 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Support for TCP checksum offload to firmware
References: <1324427136-8183-1-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1324427136-8183-1-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rishi,

On 12/21/2011 02:25 AM, Rishi Panjwani wrote:
> The change enables offloading TCP checksum calculation to firmware.
> The support has been added for QA team's testing purposes and currently
> there is no plan to offload the feature to firmware by default at
> load time.

Why? Please document the reason in the commit log.

Also does this comment still apply? It wasn't clear for me from looking
at the code.

> +	ndev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);

No need for parenthesis here.

> @@ -265,6 +267,14 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	if (test_bit(WMI_ENABLED, &ar->flag)) {
> +		if ((dev->hw_features & NETIF_F_IP_CSUM) &&
> +				(csum == CHECKSUM_PARTIAL)) {
> +			csum_start = skb->csum_start -
> +					(skb_network_header(skb) - skb->head) +
> +					sizeof(struct ath6kl_llc_snap_hdr);
> +			csum_dest = skb->csum_offset + csum_start;
> +		}

Shouldn't you test dev->features here, not hw_features?

> +
>  		if (skb_headroom(skb) < dev->needed_headroom) {
>  			struct sk_buff *tmp_skb = skb;
>  
> @@ -281,11 +291,31 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>  			goto fail_tx;
>  		}
>  
> -		if (ath6kl_wmi_data_hdr_add(ar->wmi, skb, DATA_MSGTYPE,
> -					    more_data, 0, 0, NULL,
> -					    vif->fw_vif_idx)) {
> -			ath6kl_err("wmi_data_hdr_add failed\n");
> -			goto fail_tx;
> +		if ((dev->hw_features & NETIF_F_IP_CSUM) &&
> +				(csum == CHECKSUM_PARTIAL)) {

Ditto.

> +			meta_v2.csum_start = csum_start;
> +			meta_v2.csum_dest = csum_dest;
> +
> +/*instruct target to calculate checksum*/

Indent similarly as the rest of the code and add spaces like this:

			/* instruct target to calculate checksum */


> +			meta_v2.csum_flags = CSUM_OFFLOAD_FLAG;
> +			ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
> +					DATA_MSGTYPE, more_data, 0,
> +					WMI_META_VERSION_2,
> +					&meta_v2, vif->fw_vif_idx);
> +			if (ret) {
> +				ath6kl_warn("failed to add tcp checksum:%d\n"
> +						, ret);
> +				goto fail_tx;
> +			}
> +		} else {
> +			ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
> +						DATA_MSGTYPE, more_data, 0, 0,
> +						NULL, vif->fw_vif_idx);
> +			if (ret) {
> +				ath6kl_warn("failed to add wmi data header:%d\n"
> +						, ret);
> +				goto fail_tx;
> +			}
>  		}

Instead of calling the wmi function twice you could add new variables to
make it look simpler:

if (foo) {
	meta = &meta_v2;
	meta_ver = WMI_META_VERSION_2;
} else {
	meta = NULL;
	meta_ver = 0;
}

ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
				DATA_MSGTYPE, more_data, 0,
				meta_ver,
				&meta, vif->fw_vif_idx);


> @@ -1259,6 +1289,27 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
>  		break;
>  	}
>  
> +/*Support for configuring rx checksum offload*/

Indent and add spaces.

> +	if ((vif->ndev->features & NETIF_F_RXCSUM) &&
> +		(ar->rx_meta_ver != WMI_META_VERSION_2)) {
> +		ar->rx_meta_ver = WMI_META_VERSION_2;
> +		if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
> +			if_idx, ar->rx_meta_ver, 0, 0)) {
> +			ath6kl_err("unable to set the rx frame format\n");
> +			status = -EIO;
> +		}
> +	} else if (!(vif->ndev->features & NETIF_F_RXCSUM) &&
> +		(ar->rx_meta_ver == WMI_META_VERSION_2)) {
> +		ar->rx_meta_ver = 0;
> +		if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
> +			if_idx, ar->rx_meta_ver, 0, 0)) {
> +			ath6kl_err("unable to set the rx frame format\n");
> +			status = -EIO;
> +		}
> +
> +	}

I don't like that this in the rx path, which is supposed to be a
hotpath. I think adding ndo_set_features() callback and doing this in
that callback is much better.

> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -257,6 +257,9 @@ static inline u8 wmi_data_hdr_get_if_idx(struct wmi_data_hdr *dhdr)
>  #define WMI_META_VERSION_1	0x01
>  #define WMI_META_VERSION_2	0x02
>  
> +/* Flag to signal to FW to calculate TCP checksum */
> +#define CSUM_OFFLOAD_FLAG 0x01

This could be named a bit differently, WMI_META_V2_FLAG_CSUM_OFFLOAD or
something like that.

Kalle
