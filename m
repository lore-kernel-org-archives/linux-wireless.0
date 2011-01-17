Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56844 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1AQPVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 10:21:31 -0500
Received: by fxm20 with SMTP id 20so6149232fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 07:21:29 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/13] DFS/radar state/userspace handling
Date: Mon, 17 Jan 2011 16:21:29 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101171621.29863.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Based on the IRC discussions I started implementing the required bits 
for handling DFS states and channel flags in cfg/mac80211 and userspace. 
This is WIP, so not really complete, just wanted to get that out so we 
have something to discuss about on tomorrows meeting.

Implemented so far is the complete state machine, handling CAC and NOL 
as well as starting appropriate action in hostapd. Note, this is based 
on top of the 'dfs region support' work posted by Luis.

TODO:
- Documentation
- CSA
- unset beacon on CAC
- unset beacon if interference is detected
- prevent beacon from being set if channel is !CLEAR
- prevent frames from being sent if channel is !CLEAR
  A few bits are already there, but by far not complete, e.g. we
  discard auth responses but allow probe responses and deauth frames.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
