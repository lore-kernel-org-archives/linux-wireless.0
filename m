Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:27403 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYC2RCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 13:02:10 -0400
Received: by fg-out-1718.google.com with SMTP id l27so870247fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 10:02:09 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
Date: Sat, 29 Mar 2008 18:01:16 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1206801246.24689.19.camel@Bas> <200803291553.03955.IvDoorn@gmail.com> <1206808941.22448.22.camel@Bas>
In-Reply-To: <1206808941.22448.22.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803291801.17068.IvDoorn@gmail.com> (sfid-20080329_170214_828322_3C636084)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> --------------------------------------------------------------------
> this repeats for a while, all the time giving EAPOL-Key timeout
> messages. tetherial -i mon.wlan1 on the hostapd machine shows that no
> EAPOL key's are received, while tetherial on the laptop shows that they
> are being sent.

Could you enable debugfs and use the tools here:
http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html

To create a dump of the frames as they are actually send out from the driver
to the hardware including the status report. This will tell if rt2x00 is actually
bringing the frame to the hardware correctly.

> this is the flag status when running hostapd; as printed with
> printk(KERN_INFO "rt2500pci filter_flags: %d\n",
> rt2x00dev->packet_filter);
> 
> rt2500pci filter_flags: 2
> rt2500pci MAC changed: 00:0c:f6:14:05:19

Packet filter flags of 2 sounds a bit restrictive.

Johannes, for Master mode shouldn't the following flags be set as well:
FIF_PROMISC_IN_BSS
FIF_CONTROL

Or should the driver enable those automatically when master mode is enabled?

> IEEE 802.1X: 125 bytes from 00:1b:77:a4:db:26
>    IEEE 802.1X: version=1 type=3 length=121
> wlan1: STA 00:1b:77:a4:db:26 WPA: received EAPOL-Key frame (2/4
> Pairwise)
> WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING
> WPA: PTK derivation - A1=00:0c:f6:14:05:19 A2=00:1b:77:a4:db:26
> WPA: PMK - hexdump(len=32): [REMOVED]
> WPA: PTK - hexdump(len=64): [REMOVED]
> WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING2
> WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKINITNEGOTIATING
> --------------------------------------------------------------------

I'm not sure what is happening here...

Ivo
