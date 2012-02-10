Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:59040 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2BJVSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 16:18:36 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RvxrV-00048g-5n
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 22:18:33 +0100
Received: from localhost ([::1]:59476 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RvxrV-0000K3-59
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 22:18:33 +0100
Received: from [195.4.92.25] (port=56952 helo=15.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rvxp0-00081S-Td
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 22:15:58 +0100
Received: from [2002:4fde:60c:2:5054:ff:feb8:40bd] (port=59529 helo=mail.maya.org)
	by 15.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rvxp0-0003Hm-G3
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 22:15:58 +0100
Message-ID: <4F358902.3040009@01019freenet.de> (sfid-20120210_221841_122212_7081539D)
Date: Fri, 10 Feb 2012 22:15:46 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Alfonso Fiore <alfonso.fiore@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com> <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com> <20120207171538.3336af0c@mj> <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com> <4F34BF3C.9030809@01019freenet.de> <CAO=xpBFKOAdTEi1DMfJxWCCv9oEtJpuLjuN4uNPNRgN1iWG85Q@mail.gmail.com>
In-Reply-To: <CAO=xpBFKOAdTEi1DMfJxWCCv9oEtJpuLjuN4uNPNRgN1iWG85Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alfonso Fiore schrieb:
> On Fri, Feb 10, 2012 at 7:54 AM, Andreas Hartmann
[...]
> # find / | grep ath5k.ko
> /lib/modules/3.0.0-voyage/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
> /lib/modules/3.0.0/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
> /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/ath5k.ko
> /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/.ath5k.ko.cmd
> 
> I tried depmod -a and also a simple reboot (which I always do after
> make install) but the "updates" module is never loaded.
> 
> Any idea?

Sorry for being late. I worked on my machine and wasn't able to read any
mails.


I do have a config file for depmod in /etc/depmod.d called
00-system.conf, which has the following entries:

--------------------------------------------------------------------
#
# /etc/depmod.conf - configuration file for the depmod(8) command,
# for its format see depmod.conf(5).
#
# Please don't edit this file, place your settings into the /etc/depmod.d
# directory.


# search order:
# 1 updates/ (KMPs)
# 2 extra/ (KMPs or manually compiled modules)
# 3 weak-updates/ (KMPs built for older kernels)
# 4 everything else
search updates extra weak-updates built-in

# do not generate modules.*map files
make_map_files no
----------------------------------------------------------------------

Version of my inittools is: module-init-tools-3.12-6.1.x86_64. I don't
have a depmod.conf file.

After creating / changing this file, issue depmod -a again!



Hope that helps!

Regards,
Andreas
