Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:54005 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbZEDPVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:21:53 -0400
Received: from [192.168.1.161] (77-59-246-34.static.cablecom.ch [77.59.246.34])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n44FFf09021488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 May 2009 17:15:41 +0200
Message-ID: <49FF06BB.2090106@shockfish.com>
Date: Mon, 04 May 2009 17:16:11 +0200
From: Alexandre Becholey <alexandre@shockfish.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: IEEE80211 Acknowledgement
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to catch Acknowlegement frames in the mac80211, but I don't 
managed to. Thus I'm wondering if they follow another path than the 
frames that aren't control ones?
First I grab the header from the skb:
struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;

then I run tests on the frame control. I can see frames like probe 
request or association request (ieee80211_is_probe_req, 
ieee80211_is_assoc_req,...) but there are never any ack ones. I did this 
in functions __ieee80211_rx and ieee80211_rx_irqsafe in rx.c

I'm doing this with a ralink chip (rt73usb) on the wireless-testing kernel.

Alexandre Becholey
