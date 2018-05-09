Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:39417 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964896AbeEIVMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:12:45 -0400
Received: by mail-qt0-f178.google.com with SMTP id f1-v6so47610564qtj.6
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 14:12:45 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [wl-testing/master] build regression in brcmfmac
Message-ID: <5AF36449.9050906@broadcom.com> (sfid-20180509_231249_251823_47897641)
Date: Wed, 9 May 2018 23:12:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since yesterday I get the following build error on wl-testing/master:

   CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.o
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function 
‘brcmf_notify_connect_status_ap’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1: 
error: the frame size of 1592 bytes is larger than 1024 bytes 
[-Werror=frame-larger-than=]
  }
  ^

In the function brcmf_notify_connect_status_ap() I do have following on 
the stack:

static s32
brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
                                struct net_device *ndev,
                                const struct brcmf_event_msg *e, void *data)
{
         static int generation;
         u32 event = e->event_code;
         u32 reason = e->reason;
         struct station_info sinfo;

I guess the struct station_info grew bigger by these commits:

52539ca cfg80211: Expose TXQ stats and parameters to userspace	+816
81d5439 cfg80211: average ack rssi support for data frames	+1

There are a number of other (cfg80211-based) drivers doing the same 
thing, ie. mwifiex, ath6kl, qtnfmac.

Regards,
Arend
