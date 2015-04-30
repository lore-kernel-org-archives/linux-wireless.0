Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3]:43179 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbD3P77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 11:59:59 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp03.msg.oleane.net (MTA) with ESMTP id t3UFxuG2007812
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2015 17:59:57 +0200
Subject: ath9k: multi-ssid AP does not work on DFS channel
Date: Thu, 30 Apr 2015 17:59:56 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A31901A717EF@sbs2003.acksys.local> (sfid-20150430_180015_770104_67CEFE5D)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello List,

When I set up an AP with two BSSID, it works normally when I use an
ordinary channel (say, chan 48) but not with a DFS channel (e.g. 60,
64...)
It looks like the atk9k driver has a limit of 1 AP interface when using
DFS channels.

Is there any reason for this limit? Why not allowing multi-ssid provided
that all the ssids are shutdown when a radar is detected?

Iw reports:

        valid interface combinations:
                 * #{ managed } <= 2048, #{ AP, mesh point } <= 8, #{
P2P-client, P2P-GO } <= 1, #{ IBSS } <= 1,
                   total <= 2048, #channels <= 1, STA/AP BI must match
                 * #{ WDS } <= 2048,
                   total <= 2048, #channels <= 1, STA/AP BI must match
                 * #{ IBSS, AP, mesh point } <= 1,
                   total <= 1, #channels <= 1, STA/AP BI must match,
radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz }

I am using hostapd v2.3 and compat-wireless 2014-11-04.

Jean-Pierre Tosoni
