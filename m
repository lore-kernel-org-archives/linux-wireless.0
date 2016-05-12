Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36956 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcELVhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 17:37:38 -0400
Received: by mail-wm0-f52.google.com with SMTP id a17so85581wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2016 14:37:37 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: add fallback for devices that do not report
 per-chain values
To: Jaap Jan Meijer <jjmeijer88@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAA+NYvRvVXF0-x9s8qDBaL0_Weuin5+CAsZXZu5Wt+_M1FGMWw@mail.gmail.com>
 <1463070308-30789-1-git-send-email-jjmeijer88@gmail.com>
Cc: kvalo@codeaurora.org, brcm80211-dev-list@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5734F79F.1020703@broadcom.com> (sfid-20160512_233742_277652_D677ABB4)
Date: Thu, 12 May 2016 23:37:35 +0200
MIME-Version: 1.0
In-Reply-To: <1463070308-30789-1-git-send-email-jjmeijer88@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-05-16 18:25, Jaap Jan Meijer wrote:
> If brcmf_cfg80211_get_station fails to determine the RSSI from the
> per-chain values get the value individually as a fallback.
> 
> Fixes: 1f0dc59a6de9 ("brcmfmac: rework .get_station() callback")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Jaap Jan Meijer <jjmeijer88@gmail.com>
> ---
> change log:
> v2:
>  - remove beacon period and dtim, these values are obtained differently
>  - add reverence to fixed commit
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index d5c2a27..e19847c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -2480,12 +2480,14 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
>  			   const u8 *mac, struct station_info *sinfo)
>  {
>  	struct brcmf_if *ifp = netdev_priv(ndev);
> +	struct brcmf_scb_val_le scb_val;
>  	s32 err = 0;
>  	struct brcmf_sta_info_le sta_info_le;
>  	u32 sta_flags;
>  	u32 is_tdls_peer;
>  	s32 total_rssi;
>  	s32 count_rssi;
> +	int rssi;
>  	u32 i;
>  
>  	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
> @@ -2569,6 +2571,20 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
>  			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
>  			total_rssi /= count_rssi;
>  			sinfo->signal = total_rssi;
> +		} else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
> +			&ifp->vif->sme_state)) {
> +			memset(&scb_val, 0, sizeof(scb_val));
> +			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
> +						     &scb_val, sizeof(scb_val));
> +			if (err) {
> +				brcmf_err("Could not get rssi (%d)\n", err);
> +				goto done;
> +			} else {
> +				rssi = le32_to_cpu(scb_val.val);
> +				sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
> +				sinfo->signal = rssi;
> +				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
> +			}
>  		}
>  	}
>  done:
> 
