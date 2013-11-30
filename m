Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53983 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3K3NBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:01:05 -0500
Message-ID: <5299E184.1020302@hauke-m.de> (sfid-20131130_140113_107609_62FA4B23)
Date: Sat, 30 Nov 2013 14:00:52 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>, backports@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: Re: 3.13 various backports bugs
References: <1385815530.23776.53787977.56B183FC@webmail.messagingengine.com>
In-Reply-To: <1385815530.23776.53787977.56B183FC@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2013 01:45 PM, Nikita N. wrote:
> Hi dear maintainers of backports :) I have few bugs to report, Ill try
> to be as fast as I can.
> 
> - Bug #1:
> Im running on standard Slitaz4, kernel 2.6.37-slitaz, updating modules,
> the following script:
> ./backports-3.13-rc1-1/scripts/compress_modules.sh
> the "if" is not able to detect the present compression, as result the
> new modules are not compressed, and get mixed with the old ones
> compressed, resulting in lots of errors.
> My actual workaround is just to delete the "if" line.
> The issue is present systematically in all backports releases, since the
> switch from compat-drivers.
> The compress_modules script into 3.9 is instead working good.

What distribution are you using? I want to reproduce the issue.

> - Bug #2:
> eeprom modules are missing into 3.13.
> This issue is present systematically in all backports releases, since
> the switch from compat-drivers.
> It could be a wireless bug only, or a backports bug only, or both.
> Anyway, eeprom module is vital for correct interface detection.
> Into 3.9 the eeprom modules are located in
> ./compat-drivers-3.9-rc4-2-su/drivers/misc/eeprom/

This should be included in your kernel you are compiling against
otherwise you wouldn't be able to build rtl8187.

There was a bug in backports regarding EEPROM_93CX6, could you please
try backports-20131122-2 and report back if the problem is still there.

> - Bug #3:
> New dependance has been added, CRYPTO_CCM, which denies all modules
> compilation based on MAC80211.
> The dependance is set in ./backports-3.13-rc1-1/net/mac80211/Kconfig
> On Slitaz4, such kernel config is not set, hence its needed to edit
> manually the kernel .config in order to enable it.
> After enabling, modules compilation goes all right.
> Hence, or CRYPTO_CCM is useless, or its needed to show a warning to the
> user at Kconfig runtime, in order to take the necessary measures.
> It took forever (even for me!) to find that bug, which btw was denying
> the compilation of my Realtek modules.

Yes that dependency was added to mac80211 in the mainline kernel some
weeks ago. After you activated CRYPTO_CCM in your kernel config you have
to recompile your kernel otherwise you will get problems at least when
you use WPA2.

> - Bug #4:
> Repeated back-slashes "//" are present into script-makefile files, you
> can see them appear for example running "make alldefconfig & make
> install":
> [...]
> COMPRESS /lib/modules/2.6.37-slitaz//updates/compat/compat.ko
> gzip: can't open
> '/lib/modules/2.6.37-slitaz//updates/compat/compat.ko.gz': File exists
> [...]

Probably a different error is causing this problem, Linux is fine with
repeated back-slahes, it just does not look nice.

> - Bug #5:
> Cosmetic bug, in file ./backports-3.13-rc1-1/Makefile, the following
> line is duplicated:
> @echo "  allyesconfig    - New config where all options are accepted
> with yes"

I will have a look into this.

> Hope all is clear, now I have to leave you because my baby sh*t the
> diapers so much all is getting out and my wife is shouting at me!
> aaargh! :D
> Thanks for your attention :)
> 

