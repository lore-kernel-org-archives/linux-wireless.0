Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58926 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1DRLLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:11:46 -0400
Received: by qyg14 with SMTP id 14so2936244qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:11:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 13:11:45 +0200
Message-ID: <BANLkTikk23kkpt2Gnjx-EEK+zvo+w4ZXwQ@mail.gmail.com>
Subject: Does mac80211 flush beacon_parameters->interval?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was pinged about bug report on OpenWRT [0] about b43 not setting
beacon interval for AP mode when restarting hostapd. You can see my
comment in this bug report for some details.

It seems that starting hostapd calls:
ieee80211_ops->start

In normal situation this is followed by:
ieee80211_ops->bss_info_changed
with BSS_CHANGED_BEACON_INT

However I suspect that if device was already used earlier (so this is
restart, not cold start), driver does not receive
BSS_CHANGED_BEACON_INT or bss_info_changed is not called at all.

Is this possible mac80211 caches beacon interval and does not flush it
on hardware restart?

I suspect this part of code to do the caching:
http://lxr.free-electrons.com/source/net/mac80211/cfg.c#L452

How does it work? BSS_CHANGED_BEACON_INT is passed only:
if (params->interval &&
(sdata->vif.bss_conf.beacon_int != params->interval))

Performing:
grep "\.interval" ./net/mac80211/*
grep "\->interval" ./net/mac80211/*
does not give anything interesting. It seems nl80211.c is involved here.

Cold someone take a look at this?

[0] https://dev.openwrt.org/ticket/8033

-- 
Rafał
