Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:45978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1EMPWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:22:55 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p4DFMrY8024238
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:22:53 -0700
Received: from gxk2 (gxk2.prod.google.com [10.202.11.2])
	by hpaq6.eem.corp.google.com with ESMTP id p4DFLqOc028537
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:22:52 -0700
Received: by gxk2 with SMTP id 2so1210265gxk.8
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:22:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305280792-9475-18-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
	<1305280792-9475-18-git-send-email-arend@broadcom.com>
Date: Fri, 13 May 2011 08:22:51 -0700
Message-ID: <BANLkTikiPcWwPS91_jOLCD7bX=D3j0pkGg@mail.gmail.com> (sfid-20110513_172258_906222_BB967740)
Subject: Re: [PATCH 18/32] staging: brcm80211: Fix for WPA GTK install issue
 in brcmfmac driver
From: Grant Grundler <grundler@chromium.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, Sukesh Srikakula <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 2:59 AM, Arend van Spriel <arend@broadcom.com> wrote:
> From: Sukesh Srikakula <sukeshs@broadcom.com>
>
> Last 16 bytes of the key sent by cfg80211 needs to be swapped before
> installing it to FW for TKIP encryption. This is not done for group
> key in current code, which is corrected with this fix.
>
> Cc: devel@linuxdriverproject.org
> Cc: linux-wireless@vger.kernel.org
> Cc: Grant Grundler <grundler@chromium.org>

Thanks Arend+Sukesh for posting this! :)

Tested-by: Grant Grundler <grundler@chromium.org>

Please add the same line for Aaron Plattner <aplattner@nvidia.com>
    http://gerrit.chromium.org/gerrit/502

cheers,
grant

> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
> index b44daf9..c60fc7c 100644
> --- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -1616,6 +1616,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>        s32 val;
>        s32 wsec;
>        s32 err = 0;
> +       u8 keybuf[8];
>
>        WL_DBG("key index (%d)\n", key_idx);
>        CHECK_SYS_UP();
> @@ -1644,6 +1645,9 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>                WL_DBG("WLAN_CIPHER_SUITE_WEP104\n");
>                break;
>        case WLAN_CIPHER_SUITE_TKIP:
> +               memcpy(keybuf, &key.data[24], sizeof(keybuf));
> +               memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
> +               memcpy(&key.data[16], keybuf, sizeof(keybuf));
>                key.algo = CRYPTO_ALGO_TKIP;
>                WL_DBG("WLAN_CIPHER_SUITE_TKIP\n");
>                break;
> --
> 1.7.4.1
>
>
>
