Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47270 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1IOJXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:23:14 -0400
Received: by wwf22 with SMTP id 22so3423475wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 02:23:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Sep 2011 12:23:13 +0300
Message-ID: <CAApCBGxz8bP-=m=gmrBcR0UaAGWZCN5-AOyO12t3gt6jocU9qA@mail.gmail.com> (sfid-20110915_112317_887879_A008079C)
Subject: compat-wireless cross compilation
From: wireless newbie <wnewbie72@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to cross compile compat-wireless but I haven't had any
luck. My target architecture is ppc and my target kernel version is
2.6.39. I have cloned compat.git, linux-next.git and
compat-wireless-2.6.git to my host machine and set GIT_TREE and
GIT_COMPAT_TREE variables to point to linux-next and compat
directories. When in compat-wireless directory I say

make KLIB=/path/to/my/target/kernel KLIB_BUILD=/path/to/my/target/kernel/

I get this:

cat: /media/data/work/wireless-compat/compat-wireless-2.6/compat_version:
No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /media/data/work/wireless-compat/compat-wireless-2.6/compat_version:
No such file or directory
make -C /path/to/my/target/kernel/
M=/media/data/work/wireless-compat/compat-wireless-2.6 modules
make[1]: Entering directory `/path/to/my/target/kernel'
scripts/Makefile.build:44:
/media/data/work/wireless-compat/compat-wireless-2.6/compat/Makefile:
No such file or directory
make[3]: *** No rule to make target
`/media/data/work/wireless-compat/compat-wireless-2.6/compat/Makefile'.
 Stop.
make[2]: *** [/media/data/work/wireless-compat/compat-wireless-2.6/compat]
Error 2
make[1]: *** [_module_/media/data/work/wireless-compat/compat-wireless-2.6]
Error 2
make[1]: Leaving directory `/path/to/my/target/kernel'
make: *** [modules] Error 2

It seems that compat-wireless is missing some files. Why is it so?
Should I do some preparations before I run make or..?

Also, is it somehow possible to patch my current kernel sources with
compat-wireless sources? That would be my preference if that would be
possible.

thanks
