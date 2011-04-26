Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45298 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1DZKMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:12:10 -0400
Received: by qyk7 with SMTP id 7so1112006qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:12:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikk23kkpt2Gnjx-EEK+zvo+w4ZXwQ@mail.gmail.com>
References: <BANLkTikk23kkpt2Gnjx-EEK+zvo+w4ZXwQ@mail.gmail.com>
Date: Tue, 26 Apr 2011 12:12:08 +0200
Message-ID: <BANLkTi=tLL4+StzVkkNTs4L6D2TfBXw8Tw@mail.gmail.com> (sfid-20110426_121214_339335_21CAE525)
Subject: Re: Does mac80211 flush beacon_parameters->interval?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 kwietnia 2011 13:11 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> I was pinged about bug report on OpenWRT [0] about b43 not setting
> beacon interval for AP mode when restarting hostapd. You can see my
> comment in this bug report for some details.
>
> It seems that starting hostapd calls:
> ieee80211_ops->start
>
> In normal situation this is followed by:
> ieee80211_ops->bss_info_changed
> with BSS_CHANGED_BEACON_INT
>
> However I suspect that if device was already used earlier (so this is
> restart, not cold start), driver does not receive
> BSS_CHANGED_BEACON_INT or bss_info_changed is not called at all.
>
> Is this possible mac80211 caches beacon interval and does not flush it
> on hardware restart?
>
> I suspect this part of code to do the caching:
> http://lxr.free-electrons.com/source/net/mac80211/cfg.c#L452
>
> How does it work? BSS_CHANGED_BEACON_INT is passed only:
> if (params->interval &&
> (sdata->vif.bss_conf.beacon_int != params->interval))
>
> Performing:
> grep "\.interval" ./net/mac80211/*
> grep "\->interval" ./net/mac80211/*
> does not give anything interesting. It seems nl80211.c is involved here.
>
> Cold someone take a look at this?

Ping, please?

-- 
Rafał
