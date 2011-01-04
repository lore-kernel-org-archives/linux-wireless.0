Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:36618 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab1AGLsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 06:48:07 -0500
Received: from [172.22.211.32] (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id p07Bm4jZ012235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 7 Jan 2011 13:48:05 +0200
Subject: Hidden SSID and WLAN powersave
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 12:26:41 +0200
Message-ID: <1294136801.4166.30.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I stumbled upon a PSM issue when a hidden SSID is used. It seems that
mac80211 is not going to power-save mode with hidden SSID AP's at all.

As far as I can see the following happens:

- When generally scanning, the AP is getting a bss entry with a zero
SSID.
- When associating, a probe-req is sent to the AP with the SSID, and as
result a probe-response is received with the hidden SSID in place -> a
second bss entry is created for the AP, now with the real SSID.
- After association, mac80211 executes ieee80211_recalc_ps(), but does
not go to powersave because the beacon-ies are missing.
- A new beacon is received for the BSSID, but it updates the bss entry
with the zero SSID, ieee80211_recalc_ps() gets called, but for the
associated bss entry the beacon-ies are still missing.

As result, the STA does not ever enter WLAN PSM.

Anyone stumbled on this issue?

-Juuso

