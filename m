Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:40306 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab3ERXfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 19:35:22 -0400
Received: from mail-ve0-f173.google.com (mail-ve0-f173.google.com [209.85.128.173])
	by mail.nanl.de (Postfix) with ESMTPSA id 847D045F9A
	for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 23:34:54 +0000 (UTC)
Received: by mail-ve0-f173.google.com with SMTP id cy12so4950113veb.32
        for <linux-wireless@vger.kernel.org>; Sat, 18 May 2013 16:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5197DC4F.7030503@broadcom.com>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
 <1364085963-25940-5-git-send-email-hauke@hauke-m.de> <5197DC4F.7030503@broadcom.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 19 May 2013 01:34:54 +0200
Message-ID: <CAOiHx=nJ=2zeN1wb=GTzk+hr=vYXAUvxpVAK7rt7M40PrvvBDg@mail.gmail.com> (sfid-20130519_013535_827190_0E67C062)
Subject: Re: REGRESSION: v3.10-rc1: [PATCH 04/15] brcmsmac: remove brcms_bss_cfg->associated
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 18, 2013 at 9:53 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 03/24/2013 01:45 AM, Hauke Mehrtens wrote:
>>
>> Replaced the usage with pub->associated.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>   drivers/net/wireless/brcm80211/brcmsmac/main.c |   12 +++---------
>>   drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
>>   2 files changed, 3 insertions(+), 11 deletions(-)
>
>
> Hi Hauke,
>
> I had a problem with bcm43224 in STA mode and bisecting it shows this change
> as culprit. On laptop I installed kernel with brcmsmac compiled as module.
> It comes up and associates during boot, but after logging in there is no
> connectivity. Triggering reassoc gives connectivity for some time, but after
> a while (1-2 min) it stops.
>
> I am looking into it. Given the function name below (brcms_c_ps_allowed) it
> may be power-save related. I will keep you informed.

Looking at the (old) code;
static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
{
        return false;
}

should restore the old behavior.

As for this actual old code:
static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
{
       struct brcms_bss_cfg *cfg = wlc->bsscfg;

        /* disallow PS when one of the following global conditions meets */
        if (!wlc->pub->associated)
                return false;

        /* disallow PS when one of these meets when not scanning */
        if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
                return false;

        if (cfg->associated)
                return false;

        return true;
}

The only way to return true here is if wlc->pub->associated == true
and cfg->associated == false, but the only place setting these is/was
brcms_c_associate_upd() which sets both to the same value. Therefore
the code will always return false.

Hauke's change made it possible for the code to return true, which
looks at a first glance what might have been originally intended here,
and the bug is somewhere else. But what do I know, I'm no Broadcom
engineer ;-)


Jonas
