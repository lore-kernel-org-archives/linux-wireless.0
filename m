Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:38937 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYIDUHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2008 16:07:32 -0400
Received: by yx-out-2324.google.com with SMTP id 8so72163yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2008 13:07:31 -0700 (PDT)
Message-ID: <fec9d0970809041307w5eb74ff2r62062a6016bed1c3@mail.gmail.com> (sfid-20080904_220736_823221_1E74B15B)
Date: Thu, 4 Sep 2008 15:07:30 -0500
From: "=?ISO-8859-1?Q?Lars_R=E6der_Clausen?=" <lrc@amplex.dk>
To: linux-wireless@vger.kernel.org
Subject: Documentation errors
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a couple documentation problems while following the
instructions on http://wireless.kernel.org/en/users/Download for a
2.6.24 kernel on a IBM ThinkPad T60p (3945ABG controller):

The -old tarball referenced has a file include/linux/compat_autoconf.h
which contains "You need git to generate compat-release file", causing
make (on Ubuntu Hardy Heron) to fail with:

/home/lars/Software/compat-wireless-2.6-old-2008-09-04/include/linux/compat_autoconf.h:1:
error: expected '=', ',', ';', 'asm' or '__attribute__' before 'need'
make[3]: *** [/home/lars/Software/compat-wireless-2.6-old-2008-09-04/drivers/misc/eeprom_93cx6.o]
Error 1
make[2]: *** [/home/lars/Software/compat-wireless-2.6-old-2008-09-04/drivers/misc]
Error 2
make[1]: *** [_module_/home/lars/Software/compat-wireless-2.6-old-2008-09-04]
Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
make: *** [modules] Error 2

Either that file should be fixed in the tarball, or it should be
mentioned that download using git is required.

When I went to download with git, I found that the link for the -old
branch actually points to the same place as the normal branch. I
cloned with -old added and got a working copy, so I assume the docs
should point to that?

With the git copy, it compiled, installed and loaded, but now I can't
get onto the network I could get onto with the regular drivers:(

Also, is there no archive of the -old tarballs like the is of the
regular ones? I turned out not to need it after all, but others might
like it.

Finally, newbies may want to have a hint as to how to re-load the old
modules after unloading and uninstalling these.

Thanks,
-Lars
