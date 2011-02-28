Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab1B1QoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:44:23 -0500
Received: by fxm17 with SMTP id 17so3911495fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:44:21 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/9 v2] DFS/radar state/userspace handling
Date: Mon, 28 Feb 2011 17:40:36 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281740.37036.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is second version of state/userspace handling, the main diff to v1
is that state are no global and no per wiphy.

Implemented so far is the complete state machine, handling CAC and NOL
as well as starting appropriate action in hostapd. Note, this is based
on top of the 'dfs region support' work posted by Luis.

I don't include the hostapd patches this time, because there are no
real changes compared to the last series.

If you want to test this code on hardware which has no radar detection
support (well, currently there is none with support), skip patch 3/9
and use the ieee80211/radar/bang debugfs file. Writing a frequency
there will simulate interference on the channel.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
