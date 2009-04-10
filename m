Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55057 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZDJDH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 23:07:58 -0400
Received: by ewy9 with SMTP id 9so977728ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 20:07:56 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 05:07:56 +0200
Message-ID: <2d0a357f0904092007p4d84b35bma856d6c8d3546511@mail.gmail.com> (sfid-20090410_050804_100950_0AE6C86C)
Subject: Patch "module: try_then_request_module must wait" in Linus tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

this is just to inform you:
With 2.6.30-rc1-git3 there is now a patch in upstream solving the
problem with wireless kernel modules not to work properly.
It seems there was an overlapping with Andreas Schwab's "module: fix
try_then_request_module" patch [2] in Rusty's
"linux-2.6-module-and-param" GIT branch, both patches fix the same
issue affecting different Linux kernel modules (beyond wireless
hardware) not to work.
That means your revert-patch in [3] is obsolete and as you expected a
fix will be in "-rc2" :-).


Kind Regards,
Sedat

P.S.:
* [1] and [2] are identical.
* [1], [2] and [3] fix the same issue.
* Here on my laptop iwl3945-driver works fine with all three patches (tested).

[1] Upstream: "module: try_then_request_module must wait" (Linus tree,
Author: Herbert Xu)
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97c18e2c7a8e36d2d83d50ee070314aadac73a11
[2] Andreas Schwab's "module: fix try_then_request_module" patch
(rusty linux-2.6-module-and-param tree)
http://git.kernel.org/?p=linux/kernel/git/rusty/linux-2.6-module-and-param.git;a=commit;h=8188c26f4bdd6ea8ae9f018e24ee8609394020f4
[3] Wireless-Testing: "Revert "module: create a request_module_nowait()"
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=99535e1f80edd3c06461b94d65be38930b9dc553
