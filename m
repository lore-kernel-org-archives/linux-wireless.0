Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:1827 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZIUPc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 11:32:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BUG?  I can reproduce "Association request to the driver failed" at will
Date: Mon, 21 Sep 2009 17:31:38 +0200
Cc: hostap@lists.shmoo.com
References: <200909211309.40476.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909211309.40476.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909211731.38990.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, this seems to be racy. This morning I succeeded 3 times to 
get that message, now I didn't on the first try. But now I 
enabled verbose-mac80211-debugging ...

But on the second try, I succeeded again.

> Let wpa_supplicant associate.

phy10: Selected rate control algorithm 'minstrel'
ath5k phy10: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy10: RF2112B 2GHz radio found (0x46)
eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:13:19:80:da:30 (try 1)
eth1: authenticated
eth1: associate with AP 00:13:19:80:da:30 (try 1)
eth1: RX AssocResp from 00:13:19:80:da:30 (capab=0x11 status=0 
aid=114)
eth1: associated

> Turn one AP off. wpa_supplicant automatically associates to the
> second. 

eth1: deauthenticated from 00:13:19:80:da:30 (Reason: 1)
eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1: direct probe to AP 00:13:19:80:da:30 (try 2)
eth1: direct probe to AP 00:13:19:80:da:30 (try 3)
eth1: direct probe to AP 00:13:19:80:da:30 timed out
eth1: direct probe to AP 00:1b:d4:44:35:90 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:1b:d4:44:35:90 (try 1)
eth1: authenticated
eth1: associate with AP 00:1b:d4:44:35:90 (try 1)
eth1: RX AssocResp from 00:1b:d4:44:35:90 (capab=0x11 status=0 
aid=127)
eth1: associated

Side node: here mac80211 had stale scan data in the cache, thus 
wpa_supplicant first asked it to authenticate to the 
just-turned-off AP. You can see the three probes ...


> Now turn the first AP on again. Issue a manual scan command

eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:13:19:80:da:30 (try 1)
eth1: authenticate with AP 00:13:19:80:da:30 (try 2)
eth1: authenticated

-- 
http://www.holgerschurig.de
