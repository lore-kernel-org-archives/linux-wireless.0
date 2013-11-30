Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58928 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab3K3RlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 12:41:08 -0500
Message-Id: <1385833267.28449.53854837.2B49B1BD@webmail.messagingengine.com> (sfid-20131130_184127_543327_FE46271B)
From: "Nikita N." <nikitan@operamail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>, backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: 3.13 various backports bugs
Date: Sat, 30 Nov 2013 09:41:07 -0800
In-Reply-To: <529A165B.9000707@hauke-m.de>
References: <1385815530.23776.53787977.56B183FC@webmail.messagingengine.com>
 <5299E184.1020302@hauke-m.de>
 <1385818933.2275.53803445.141AB4C1@webmail.messagingengine.com>
 <529A165B.9000707@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 30, 2013, at 08:46 AM, Hauke Mehrtens wrote:
> On 11/30/2013 02:42 PM, Nikita N. wrote:
> > follow answers
> > 
> > On Sat, Nov 30, 2013, at 05:00 AM, Hauke Mehrtens wrote:
> >> On 11/30/2013 01:45 PM, Nikita N. wrote:
> >>> Hi dear maintainers of backports :) I have few bugs to report, Ill try
> >>> to be as fast as I can.
> >>>
> >>> - Bug #1:
> >>> Im running on standard Slitaz4, kernel 2.6.37-slitaz, updating modules,
> >>> the following script:
> >>> ./backports-3.13-rc1-1/scripts/compress_modules.sh
> >>> the "if" is not able to detect the present compression, as result the
> >>> new modules are not compressed, and get mixed with the old ones
> >>> compressed, resulting in lots of errors.
> >>> My actual workaround is just to delete the "if" line.
> >>> The issue is present systematically in all backports releases, since the
> >>> switch from compat-drivers.
> >>> The compress_modules script into 3.9 is instead working good.
> >>
> >> What distribution are you using? I want to reproduce the issue.
> >>
> 
> The output of modinfo -F filename mac80211 in Slitaz4 differs from the
> output of the same command when the real and not the busybox modinfo was
> used. This is not a bug in backports, but in your distribution.

Clear, if you dont wish to adapt also to busybox syntax, I have no
problem with that, will keep on with my workaround, cutting the "if" all
the times.

> 
> > sure thing! you can get Slitaz4 here:
> > http://mirror.slitaz.org/iso/4.0/slitaz-4.0.iso
> >  
> >>> - Bug #2:
> >>> eeprom modules are missing into 3.13.
> >>> This issue is present systematically in all backports releases, since
> >>> the switch from compat-drivers.
> >>> It could be a wireless bug only, or a backports bug only, or both.
> >>> Anyway, eeprom module is vital for correct interface detection.
> >>> Into 3.9 the eeprom modules are located in
> >>> ./compat-drivers-3.9-rc4-2-su/drivers/misc/eeprom/
> >>
> >> This should be included in your kernel you are compiling against
> >> otherwise you wouldn't be able to build rtl8187.
> >>
> >> There was a bug in backports regarding EEPROM_93CX6, could you please
> >> try backports-20131122-2 and report back if the problem is still there.
> > 
> > We are already discussing that with Larry on wireless mailist, Ill
> > forward the mails here FYI. 
> 
> Yes eeprom_93cx6.ko was removed from backports, because the version
> shipped by the kernels backports supports works with the wireless
> drivers using eeprom_93cx6.ko. This module is activated in all
> mainstream linux distribution kernel versions and we do not want to ship
> it. When you are compiling your own kernel you should activate that
> module in your kernel.

Clear, if you wish to support only MAINstreams, im ok with that, I will
keep on with my workaround, adding eeprom_93cx6.c all the times.
FYI, Slitaz is the only MINI-distro working in ram at only 50 mbytes,
with a complete repository of applications and development tools.
Second is only Puppy linux, which structure is completely different,
more complex, twice bigger and twice slower.. 

> 
> >>> - Bug #3:
> >>> New dependance has been added, CRYPTO_CCM, which denies all modules
> >>> compilation based on MAC80211.
> >>> The dependance is set in ./backports-3.13-rc1-1/net/mac80211/Kconfig
> >>> On Slitaz4, such kernel config is not set, hence its needed to edit
> >>> manually the kernel .config in order to enable it.
> >>> After enabling, modules compilation goes all right.
> >>> Hence, or CRYPTO_CCM is useless, or its needed to show a warning to the
> >>> user at Kconfig runtime, in order to take the necessary measures.
> >>> It took forever (even for me!) to find that bug, which btw was denying
> >>> the compilation of my Realtek modules.
> >>
> >> Yes that dependency was added to mac80211 in the mainline kernel some
> >> weeks ago. After you activated CRYPTO_CCM in your kernel config you have
> >> to recompile your kernel otherwise you will get problems at least when
> >> you use WPA2.
> > 
> > ..damn.. I dont know how many Slitaz4 users will be happy about that..
> > :(
> 
> Most of the mainstream distributions are activating this as well on all
> kernel versions supported by backports, if you are using a custom kernel
> you should activate it.

Clear, if CRYPTO_CCM cant be removed, I'll keep using standard Slitaz4
(the same you tested today) and submit CRYPTO_CCM as improvement request
for next Slitaz5.
I wont rebuild the kernel just for CRYPTO_CCM, that config is useless
for my needs.

Thanks anyway for your attention :)

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

