Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.95.110]:39766 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2DIPKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 11:10:43 -0400
Received: from s87.loopia.se (localhost [127.0.0.1])
	by s87.loopia.se (Postfix) with ESMTP id 3A7DF1E1E102
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2012 17:10:39 +0200 (CEST)
Received: from s87.loopia.se ([127.0.0.1])
	by s87.loopia.se (s87.loopia.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 20qhwztWsHNy for <linux-wireless@vger.kernel.org>;
	Mon,  9 Apr 2012 17:10:38 +0200 (CEST)
Received: from s327.loopia.se (s34.loopia.se [194.9.94.70])
	by s87.loopia.se (Postfix) with ESMTP id E27A61E1E0CF
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2012 17:10:38 +0200 (CEST)
Received: from 78-69-68-166-no170.tbcn.telia.com (HELO ymer.localnet) (jan@simonson.se@[78.69.68.166])
          (envelope-sender <jan@simonson.se>)
          by s327.loopia.se (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 9 Apr 2012 15:10:38 -0000
From: Jan Simonson <jan@simonson.se>
To: linux-wireless@vger.kernel.org
Reply-To: Jan Simonson <jan@simonson.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RTL8192e-pci NIC
Date: Mon, 09 Apr 2012 17:10:26 +0200
Message-ID: <2210309.p6dWLepooK@ymer> (sfid-20120409_171048_425344_28A2F7BF)
In-Reply-To: <4F81B9C4.1010901@lwfinger.net>
References: <1502184.lhzNHmlX61@ymer> <4F81B9C4.1010901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

söndagen den 8 april 2012 11.16.04 skrev  Larry Finger:
> On 04/08/2012 06:16 AM, Jan Simonson wrote:

> > I'm using a Samsung R720 laptop with a RTL8192e-pci NIC and Fedora 16. The
> > driver has been in kmod-staging from fusion until recently. Now it is
> > removed from staging and instead a driver is included in the kernel pack
> > from Fedora. After booting with this new kernel the relevant modules are
> > loaded (see below) but the wireless connection is not available. Using
> > the module earlier from Fusion worked most of the time and better and
> > better over time.

> To fix your problem, you need to run a kernel that contains r8192e_pci in
> its configuration. Driver rtl8192se cannot work with this device under any
> circumstances.
> 
> I just downloaded a copy of the Fedora 16 Live CD and booted it in a virtual
> machine. The kernel there is 3.1.0-7.fc16.i686. It the configuration file,
> CONFIG_RTL8192E is not set, thus your device would not work with this
> kernel.
> 
> @John: Was there a policy change at Fedora regarding staging drivers? Is
> there some kernel that has them enabled?

In fact the module I used earier was included in rpm kmod-staging from the 
fusion repositary and thus strictly speaking not a part of Fedora. For some 
reason the r8192e-pci module was dropped from kmod-staging and I believed that 
the modules in Fedora would function. Now I know better!

I managed to compile and install r8192e-pci into 
/lib/modules/3.3.1-3.fc16.x86_64/kernel/drivers/staging/rtl8192e/rtl8192e/ 
(I'm running 3.3.1-3.fc16.x86_64 now) and also rtllib.ko, 
rtllib_crypt_ccmp.ko, rtllib_crypt_tkip.ko and rtllib_crypt_wep.ko into 
/lib/modules/3.3.1-3.fc16.x86_64/kernel/drivers/staging/rtl8192e/
However trying to insmod any of them only results in 
insmod: error inserting 'xxx': -1 Unknown symbol in module

They probably depend on each other so I have tested with everyone first, but to 
no avail. They must depend on some other module. I also tested with modprobe, 
but that didn't function either as they are not listed in modules.dep.

Any pointer to how to make a correct entry in modules.dep or what they are 
depending on would be much appreciated.

Best regards
Jan
