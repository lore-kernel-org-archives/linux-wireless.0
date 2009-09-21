Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2075 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbZIUPXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 11:23:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at will
Date: Mon, 21 Sep 2009 17:22:33 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909211259.45431.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909211259.45431.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909211722.33577.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes asked me off-list for dmesg output:


> First, it associates to the MNHS-AP:

eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:13:19:80:da:30 (try 1)
eth1: authenticated
eth1: associate with AP 00:13:19:80:da:30 (try 1)
eth1: RX AssocResp from 00:13:19:80:da:30 (capab=0x11 status=0 
aid=112)
eth1: associate



> Next I turn of the AP where I'm associated to. wpa_supplicant
> successfully associates to the WEP-based AP:

eth1: deauthenticated from 00:13:19:80:da:30 (Reason: 1)
eth1: direct probe to AP 00:1b:53:11:dc:40 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:1b:53:11:dc:40 (try 1)
eth1: authenticated
eth1: associate with AP 00:1b:53:11:dc:40 (try 1)
eth1: RX AssocResp from 00:1b:53:11:dc:40 (capab=0x11 status=0 
aid=91)
eth1: associated


> Now I turn on again the MNHS AP. And then I issue a scan
> from the cmdline: "iw eth1 scan trigger freq 2412"

eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:13:19:80:da:30 (try 1)
eth1: authenticated


Also the output of "iw eth1 info":

iw eth1 link
Connected to 00:1b:53:11:dc:40 (on eth1)
        SSID: MNFUNK
        freq: 2412
Authenticated with 00:13:19:80:da:30 (on eth1)
        RX: 78173 bytes (722 packets)
        TX: 144 bytes (4 packets)
        signal: -67 dBm
        tx bitrate: 11.0 MBit/s



If I understand this right, then mac80211 thinks it's connected, 
even before the 4-way key exchange?



-- 
http://www.holgerschurig.de
