Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:59479 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3DVI25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 04:28:57 -0400
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out05.msg.oleane.net with ESMTP id r3M8SbWe027788
	for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 10:28:55 +0200
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Thomas Pedersen'" <thomas@cozybit.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local> <CAG6hwVN5LRVgchuX7QQWKEioBxTz3WXO5JUVv7fE3_X5LKXayg@mail.gmail.com>
In-Reply-To: <CAG6hwVN5LRVgchuX7QQWKEioBxTz3WXO5JUVv7fE3_X5LKXayg@mail.gmail.com>
Subject: RE: Mutli vif in mesh mode
Date: Mon, 22 Apr 2013 10:07:50 +0200
Message-ID: <00ad01ce3f30$7ba5da10$72f18e30$@acksys.fr> (sfid-20130422_102901_118333_F05C1900)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Thanks Thomas for your answer, 

	In ath9k_hw_beaconinit() the mesh mode use the hadhoc beacon mode. I
try to change it, and  ath9k_set_beacon in
driver/net/Wireless/ath/ath9k/beacon.c, but after these modifications, no
beacon are sent (I think my change are wrong).

	Could you give me the old patch, I can try to update it with the
latest compat, and I will send to you an updated patch. 

	Thanks for your help.

Cedric Voncken 

-----Message d'origine-----
De : Thomas Pedersen [mailto:thomas@cozybit.com] 
Envoyé : vendredi 19 avril 2013 18:14
À : Cedric VONCKEN
Cc : linux-wireless
Objet : Re: Mutli vif in mesh mode

On Fri, Apr 19, 2013 at 5:04 PM, Cedric VONCKEN <cedric.voncken@acksys.fr>
wrote:
> I try to setup 2 mesh node on the same wireless card.
> I am using the ath9k driver from Compat 2013-02-22 (openwrt package).
>
> The command line sequence is
> Create mesh node 1
>         iw phy0 interface add wlan0 type mp
>         iw wlan0 set channel 44 HT20
>         ifconfig wlan0 up
>         iw wlan0 mesh join test
>
> Create mesh node 2
> iw phy0 interface add wlan1 type mp
> iw wlan1 set channel 44 HT20
> ifconfig wlan1 hw ether 00:09:90:aa:11:22 up iw wlan1 mesh join test2
>
> With wireshark and air pcap adapter, I cannot see the beacon for the 
> second mesh node.
> If I  execute each mesh node separately, it works correctly (I see the 
> beacon on wireshark)
>
> Is it possible to execute 2 mesh node on one ath9k wireless card?

This is because ath9k currently uses the hardware's adhoc beaconing mode for
mesh. See ath9k_hw_beaconinit() in drivers/net/wireless/ath/ath9k/hw.c. This
is probably wrong, and we have a patch to beacon with AP mode, but I'll have
to dig it up.

--
Thomas

