Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.msg.oleane.net ([62.161.4.8]:52419 "EHLO
	smtp08.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbL2NBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 08:01:45 -0500
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp08.msg.oleane.net (MTA) with ESMTP id tBTD1gHC007575
	for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2015 14:01:43 +0100
Subject: Mac80211 : Wpa rekeying issue
Date: Tue, 29 Dec 2015 14:01:41 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local> (sfid-20151229_140149_286125_6434F590)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

My test plateform is:
2 equipements
Both equipment used compat version 2015-07-21 from openwrt.
Both equipment used security WPA2

The equipment #1 is an AP.
	The Group rekey interval is set to 3601s 
	The Pair rekey interval set to 50s (I reduced this value to show
the issue often)
	The Master rekey interval is set to 86400 s.

The equipment #2 is a sta+wds

I used a 5GHz channel to have a free channel (without other AP)
I connected a computer on each equipment.

To reproduce the issue:
	I ran iperf udp@50Mbps from computer connected to the AP to the
computer connected to the sta. After several WPA2 rekeying, iperf server
side didn't received any frame.

I investigated in the driver. All packets are dropped in sta side,
because the function ieee80211_crypto_ccmp_decrypt return
Rx_DROP_UNUSABLE. This function return this code because the test
if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=0) return
true.

Have you any idea to fix this issue?

Thanks for your help.

Cedric.
