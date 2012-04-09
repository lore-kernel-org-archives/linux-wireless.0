Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57194 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2DIP5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 11:57:07 -0400
Received: by iagz16 with SMTP id z16so6029314iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 08:57:06 -0700 (PDT)
Message-ID: <4F8306CF.4040503@lwfinger.net> (sfid-20120409_175711_695350_3FCC4DAB)
Date: Mon, 09 Apr 2012 10:57:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Simonson <jan@simonson.se>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer> <4F81B9C4.1010901@lwfinger.net> <2210309.p6dWLepooK@ymer>
In-Reply-To: <2210309.p6dWLepooK@ymer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2012 10:10 AM, Jan Simonson wrote:

> In fact the module I used earier was included in rpm kmod-staging from the
> fusion repositary and thus strictly speaking not a part of Fedora. For some
> reason the r8192e-pci module was dropped from kmod-staging and I believed that
> the modules in Fedora would function. Now I know better!
>
> I managed to compile and install r8192e-pci into
> /lib/modules/3.3.1-3.fc16.x86_64/kernel/drivers/staging/rtl8192e/rtl8192e/
> (I'm running 3.3.1-3.fc16.x86_64 now) and also rtllib.ko,
> rtllib_crypt_ccmp.ko, rtllib_crypt_tkip.ko and rtllib_crypt_wep.ko into
> /lib/modules/3.3.1-3.fc16.x86_64/kernel/drivers/staging/rtl8192e/
> However trying to insmod any of them only results in
> insmod: error inserting 'xxx': -1 Unknown symbol in module
>
> They probably depend on each other so I have tested with everyone first, but to
> no avail. They must depend on some other module. I also tested with modprobe,
> but that didn't function either as they are not listed in modules.dep.
>
> Any pointer to how to make a correct entry in modules.dep or what they are
> depending on would be much appreciated.

The first step would be to look at the output of dmesg to see what actual 
problem is reported. The kernel is not tolerant of just any module, and 
building modules outside the tree is quite complicated. It will probably take 
less time if you get the Fedora source, adjust the configuration, and rebuild 
the kernel. Otherwise, you will need to prepare the special makefile needed for 
building outside the kernel.

For modules.dep to be updated, you need to copy the appropriate modules into the 
/lib/modules/`uname -r`/ directory tree, and then run the command 'depmod -a'.

As I do not use Fedora, I was not aware of Fusion. Perhaps you could get them to 
reinstate this driver in their package. In addition, you might post a bug at 
Redhat in hopes that they will change their standard configuration. As a last 
resort, you could switch to a distro that includes this driver in their standard 
kernels.

Larry
