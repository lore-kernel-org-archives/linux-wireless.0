Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40543 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbbHNIQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 04:16:49 -0400
Date: Fri, 14 Aug 2015 11:15:26 +0300
From: Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>
To: Jakub Kicinski <kubakici@wp.pl>, Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi
Subject: About adding support for MT76x2U to Linux kernel
Message-ID: <20150814081526.GC20192@hackpad.Elisa> (sfid-20150814_101654_927871_79CCC803)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'm very interested in adding support (especially AP mode) for MT76x2U
USB-dongles to Linux kernel. I'm aware of the work you both have done, Felix's
work on MT76x2 PCI-devices and Jakub's work to add support for MT7601U. So I
guess no one knows this exact problem domain better than you (perhaps excluding
MediaTek's subcontractors who wrote the original vendor driver), that is why I'm
writing specifically to you.

I have ASUS USB-N53_B1 adapter (0b05:180b) as a test device:
https://wikidevi.com/wiki/ASUS_USB-N53_B1

As far as I know, no one has been / is working on MT76x2U USB-dongles, please
correct me if I'm wrong.

I have a strong system programming background, some knowledge on 802.11 in
general, but no actual experience in Linux kernel programming. So I'm pretty
confident that I'll have many questions to throw at you before I have managed to
make anything functional.

So, to get started, I was wondering what would be the best way forward. I can
think of two reasonable approaches:

  #1 Base the new driver on Felix's mt76 and modify it to work on USB-bus
     instead of PCI.

  #2 Base the new driver on Jakub's mt7601u and modify it to handle mt76x2u
     devices by using Felix's mt76 and the vendor driver as a reference.

Of course there's the third option to write it from scratch based solely on the
vendor driver, but because you have already done such a great job in
interpreting the outdated and quite ugly (subjective view?) vendor driver code,
that would be foolish.

At first I had a hunch that #1 would be the easiest way forward, but now that I
skimmed through the code, I'm beginning to think that approach #2 has the least
resistance. However, I'm not necessarily looking for the easiest way but *the
best/right* way. So any ideas, opinions and thoughts are more than welcome.

-- 
Tuomas
