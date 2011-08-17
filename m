Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46403 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1HQCzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 22:55:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QtWHZ-0004F4-6c
	for linux-wireless@vger.kernel.org; Wed, 17 Aug 2011 04:55:05 +0200
Received: from bl8-68-47.dsl.telepac.pt ([85.241.68.47])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 04:55:05 +0200
Received: from vitor.dominor by bl8-68-47.dsl.telepac.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 04:55:05 +0200
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?VsOtdG9y?= Ferreira <vitor.dominor@gmail.com>
Subject: Re: [PATCH V3 3.2 2/2] b43: fix DMA on some bugged hardware
Date: Wed, 17 Aug 2011 02:49:36 +0000 (UTC)
Message-ID: <loom.20110817T044544-76@post.gmane.org> (sfid-20110817_045510_781411_1B5C315A)
References: <1313345797-5441-2-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings! I'm a grateful Linux end-user, following up on the success of this
patch.
I can confirm that after applying the following patches:
- RESEND-3.2-1-2-ssb-fix-DMA-translation-for-some-specific-boards.patch
- RFC-RFT-V2-2-2-b43-fix-DMA-on-some-bugged-hardware.patch
- v2-08-46-net-wireless-b43-fix-DMA-direction-for-RX-buffers.patch
to a 3.0.1 fedora patched kernel, the problem reporting to these patches has
been solved (as far as I am concerned).

More than a year ago, when I started using Linux on my personal laptop, I
noticed that if I enabled the feature of Intel VT in the laptop BIOS (it comes
disabled by default), that it would trigger the b43 fatal DMA error, which is
described in many posts in different forums like this:
http://forums.fedoraforum.org/showthread.php?t=235182. The b43 driver would
encounter this error and stop working from then on, until I restarted the
computer and disabled Intel VT. This error would only occur if I enabled that
feature.

Recently, while searching again for a possible solution for this issue, I
stumbled on your submitted patches in May to address the DMA issue. Then, in the
b43 supported devices table, I found that my Broadcom wireless card (14e4:4315 -
LP-r1) is now fully supported since kernel version 3.0. However, incidently I
had received the kernel 3.0 as a Fedora kernel update and upon enabling again
Intel VT, the DMA error presented itself still, not better not worse. Again, I
found your recent patches to address the DMA error and followed its developpment
on the mailing list throughout the last few days.
Seeing the initial successful tests on 64-bit affected systems, I decided to
give them a shot on my own system.
To do so, I updated my 3.0 kernel to the latest in its series (3.0.3rc1?,
2.6.40.3 in fedora versioning) and downloaded the latest bleeding edge
compat-wireless (yesterday) and I applied the above patches to it without
problems. By the way, for anyone using Fedora and reading this, know that in
order to compile compat-wireless with Fedora patched 3.0.x kernel I had to
change the line #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) to #if
(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) in the file
include/linux/compat-3.0.h.

Right now, I am writing this with Intel VT enabled and a stable wireless
connection to my home AP, using the b43 driver. So, I am showing here my
appreciation and thanking for your great work in crushing a pesky bug that was
perhaps the only one stopping my computer from being fully Linux compatible (HP
Pavilion dv5t). Continue your great work!

Just a side note... Curiously with Intel VT, the b43 driver would start and work
for some short time before it crashed, while the wl proprietary driver (from
Broadcom) would not even fully load.

Right now, I am writing this with Intel VT enabled and a stable wireless
connection to my home AP, using the b43 driver. So, I am showing here my
appreciation and thanking for your great work in crushing a pesky bug that was
perhaps the only one stopping my computer from being fully Linux compatible (HP
Pavilion dv5t). Continue your great work!

Just a side note... Curiously with Intel VT, the b43 driver would start and work
for some short time before it crashed, while the wl proprietary driver (from
Broadcom) would not even fully load.

