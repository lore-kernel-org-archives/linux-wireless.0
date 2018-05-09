Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53396 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935325AbeEIVW2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:22:28 -0400
Message-ID: <1525900945.6910.28.camel@sipsolutions.net> (sfid-20180509_232233_209628_E57060A2)
Subject: Re: [wl-testing/master] build regression in brcmfmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 09 May 2018 23:22:25 +0200
In-Reply-To: <5AF36449.9050906@broadcom.com> (sfid-20180509_231246_109184_F25A324A)
References: <5AF36449.9050906@broadcom.com>
         (sfid-20180509_231246_109184_F25A324A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 23:12 +0200, Arend van Spriel wrote:
> Since yesterday I get the following build error on wl-testing/master:
> 
>    CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.o
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function 
> ‘brcmf_notify_connect_status_ap’:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1: 
> error: the frame size of 1592 bytes is larger than 1024 bytes 
> [-Werror=frame-larger-than=]
>   }
>   ^
> 
> In the function brcmf_notify_connect_status_ap() I do have following on 
> the stack:
> 
> static s32
> brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
>                                 struct net_device *ndev,
>                                 const struct brcmf_event_msg *e, void *data)
> {
>          static int generation;
>          u32 event = e->event_code;
>          u32 reason = e->reason;
>          struct station_info sinfo;
> 
> I guess the struct station_info grew bigger by these commits:
> 
> 52539ca cfg80211: Expose TXQ stats and parameters to userspace	+816
> 81d5439 cfg80211: average ack rssi support for data frames	+1
> 
> There are a number of other (cfg80211-based) drivers doing the same 
> thing, ie. mwifiex, ath6kl, qtnfmac.

Yeah. Toke said this morning he was working on fixes.

johannes
