Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48469 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZDVJM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:12:28 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240391029.20308.1.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 10:12:21 +0100
Message-Id: <1240391541.10072.2.camel@localhost.localdomain> (sfid-20090422_120345_352634_41DB2317)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > one other weird thing happens now (except wireless-testing tree and
> > suspend/resume is broken). The first connection attempt fails horribly:
> > 
> > CTRL-EVENT-SCAN-RESULTS 
> > Trying to authenticate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > Trying to associate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > Associated with 00:23:ab:xx:xx:xx
> > CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (auth) [id=2 id_str=]
> > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> > l2_packet_receive - recvfrom: Network is down
> > Failed to initiate AP scan.
> > Failed to initiate AP scan.
> > ^CCTRL-EVENT-TERMINATING - signal 2 received
> > 
> > So starting wpa_supplicant does its job fine, then running dhclient I
> > end up in the disconnect and network down and after that scanning fails.
> 
> ???
> 
> And the below kernel message is all yo uget?

Yes, I am as puzzled as you are and can't make any sense out of it. It
seems that something is going horribly wrong here somewhere. I just
don't have any clue where.

> > Killing wpa_supplicant and dhclient and then trying again works fine. So
> > far I have seen that only after a fresh boot.
> > 
> > Found this one in dmesg:
> > 
> > ------------[ cut here ]------------
> > WARNING: at net/wireless/nl80211.c:205 nl80211_send_wiphy+0x4b/0x988
> > [cfg80211]()
> > Hardware name: 7454CTO
> > Modules linked in: fuse rfcomm sco bnep l2cap binfmt_misc
> > snd_hda_codec_conexant iwlagn iwlcore snd_hda_intel i2400m_usb
> > snd_hda_codec i2400m mac80211 uvcvideo snd_pcm btusb snd_timer snd wimax
> > cfg80211 soundcore bluetooth snd_page_alloc uhci_hcd ehci_hcd [last
> > unloaded: microcode]
> > Pid: 3274, comm: wpa_supplicant Tainted: G        W  2.6.30-rc2-wl #1
> > Call Trace:
> >  [<ffffffff80236604>] warn_slowpath+0xb1/0xe5
> >  [<ffffffff8039a44a>] ? extract_buf+0x84/0xe4
> >  [<ffffffffa0055e04>] nl80211_send_wiphy+0x4b/0x988 [cfg80211]
> 
> What tree are you using? This warning totally confuses me -- there's no
> code to produce it! It was a spurious warning Luis added some time ago,
> we removed right away again and now it's haunting us.

This is the iwlwifi tree based on wireless-testing. It should be
re-based, but maybe an old patch is still stuck in it. Remember that I
am using the nl80211 driver of wpa_supplicant.

Regards

Marcel


