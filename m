Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34044 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755717Ab0KJMoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:44:10 -0500
Message-ID: <4CDA9396.9030505@openwrt.org>
Date: Wed, 10 Nov 2010 13:44:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/5] mac80211: Add support for transmit beam forming.
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 1:23 PM, Vivek Natarajan wrote:
> Enable beamforming if the driver and the AP are capable of sending 
> and receiving beam-formed frames.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  include/linux/ieee80211.h  |   41 ++++++++++++++++++++++++++++++++++++++++-
>  include/net/cfg80211.h     |    6 ++++++
>  include/net/mac80211.h     |    9 +++++++--
>  net/mac80211/cfg.c         |    7 +++++++
>  net/mac80211/ht.c          |   18 ++++++++++++++++++
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |   19 +++++++++++++++++++
>  net/mac80211/rx.c          |   10 ++++++++++
>  net/mac80211/sta_info.c    |    2 ++
>  net/mac80211/sta_info.h    |    6 ++++++
>  net/mac80211/status.c      |   19 +++++++++++++++++++
>  net/mac80211/tx.c          |   27 ++++++++++++++++++++++++---
>  net/mac80211/work.c        |    1 +
>  13 files changed, 160 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index ed5a03c..ba92b73 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
[...]
>  /**
>   * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
>   * @fc: frame control bytes in little-endian byteorder
> @@ -827,6 +843,29 @@ struct ieee80211_mcs_info {
>  	u8 reserved[3];
>  } __attribute__((packed));
>  
> +struct ieee80211_txbf_caps {
> +	u32 implicit_rx_capable:1,
> +	    rx_staggered_sounding:1,
> +	    tx_staggered_sounding:1,
> +	    rx_ndp_capable:1,
> +	    tx_ndp_capable:1,
> +	    implicit_txbf_capable:1,
> +	    calibration:2,
> +	    explicit_csi_txbf_capable:1,
> +	    explicit_noncomp_steering:1,
> +	    explicit_comp_steering:1,
> +	    explicit_csi_feedback:2,
> +	    explicit_noncomp_bf:2,
> +	    explicit_comp_bf:2,
> +	    minimal_grouping:2,
> +	    csi_bfer_antennas:2,
> +	    noncomp_bfer_antennas:2,
> +	    comp_bfer_antennas:2,
> +	    csi_max_rows_bfer:2,
> +	    channel_estimation_cap:2,
> +	    reserved:3;
> +};
> +
>  /* 802.11n HT capability MSC set */
>  #define IEEE80211_HT_MCS_RX_HIGHEST_MASK	0x3ff
>  #define IEEE80211_HT_MCS_TX_DEFINED		0x01
> @@ -862,7 +901,7 @@ struct ieee80211_ht_cap {
>  	struct ieee80211_mcs_info mcs;
>  
>  	__le16 extended_ht_cap_info;
> -	__le32 tx_BF_cap_info;
> +	struct ieee80211_txbf_caps tx_BF_cap_info;
>  	u8 antenna_selection_info;
>  } __attribute__ ((packed));
What about big endian? I think it's better to just use defines with the
proper masks - bitfields make handling endian differences harder.

- Felix
