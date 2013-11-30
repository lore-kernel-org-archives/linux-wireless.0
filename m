Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58177 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab3K3Mpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 07:45:31 -0500
Message-Id: <1385815530.23776.53787977.56B183FC@webmail.messagingengine.com> (sfid-20131130_134604_827360_2CF3C086)
From: "Nikita N." <nikitan@operamail.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: 3.13 various backports bugs
Date: Sat, 30 Nov 2013 04:45:30 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi dear maintainers of backports :) I have few bugs to report, Ill try
to be as fast as I can.

- Bug #1:
Im running on standard Slitaz4, kernel 2.6.37-slitaz, updating modules,
the following script:
./backports-3.13-rc1-1/scripts/compress_modules.sh
the "if" is not able to detect the present compression, as result the
new modules are not compressed, and get mixed with the old ones
compressed, resulting in lots of errors.
My actual workaround is just to delete the "if" line.
The issue is present systematically in all backports releases, since the
switch from compat-drivers.
The compress_modules script into 3.9 is instead working good.

- Bug #2:
eeprom modules are missing into 3.13.
This issue is present systematically in all backports releases, since
the switch from compat-drivers.
It could be a wireless bug only, or a backports bug only, or both.
Anyway, eeprom module is vital for correct interface detection.
Into 3.9 the eeprom modules are located in
./compat-drivers-3.9-rc4-2-su/drivers/misc/eeprom/

- Bug #3:
New dependance has been added, CRYPTO_CCM, which denies all modules
compilation based on MAC80211.
The dependance is set in ./backports-3.13-rc1-1/net/mac80211/Kconfig
On Slitaz4, such kernel config is not set, hence its needed to edit
manually the kernel .config in order to enable it.
After enabling, modules compilation goes all right.
Hence, or CRYPTO_CCM is useless, or its needed to show a warning to the
user at Kconfig runtime, in order to take the necessary measures.
It took forever (even for me!) to find that bug, which btw was denying
the compilation of my Realtek modules.

- Bug #4:
Repeated back-slashes "//" are present into script-makefile files, you
can see them appear for example running "make alldefconfig & make
install":
[...]
COMPRESS /lib/modules/2.6.37-slitaz//updates/compat/compat.ko
gzip: can't open
'/lib/modules/2.6.37-slitaz//updates/compat/compat.ko.gz': File exists
[...]

- Bug #5:
Cosmetic bug, in file ./backports-3.13-rc1-1/Makefile, the following
line is duplicated:
@echo "  allyesconfig    - New config where all options are accepted
with yes"

Hope all is clear, now I have to leave you because my baby sh*t the
diapers so much all is getting out and my wife is shouting at me!
aaargh! :D
Thanks for your attention :)

-- 
http://www.fastmail.fm - The professional email service

