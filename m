Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58344 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab1AHWqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 17:46:46 -0500
Message-ID: <4D28E94B.1010806@hauke-m.de>
Date: Sat, 08 Jan 2011 23:46:35 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2.6.37-3-sn contains wrong files
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

plusquezero on IRC complained about compat-wireless-2.6.37-3-sn not
compiling on his system with kernel 2.6.32 (
http://pastebin.com/bKyZpKSr ). I tried to create such a release and had
no problems, but the released tar balls at
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ are
containing some extra files. These files are available in
compat-wireless based on linux-next but not in the version based on
2.6.27. Something in the script creating this release went wrong.

Attached is the diffstat beetween compat-wireless-2.6.37-3-sn.tar.bz2
and the version I generated myself with "./scripts/admin-refresh.sh -s
-n" from the git branch remotes/origin/linux-2.6.37.y of
compat-wireless.git and compat.git.

Hauke

hauke@hauke:~/compat-wireless/compat-wireless-2.6.37-3-sn$ diff -Naurx
.git -x pending-stable -x tmp.patch -x build.sh -x compiletest.sh -x
scripts . ../compat-wireless-git |diffstat
 code-metrics.txt             |   12
 compat/compat-2.6.38.c       |   50 --
 compat/kfifo.c               |  608 ------------------------------
 compat_base_tree             |    2
 include/linux/average.h      |    5
 include/linux/kfifo.h        |  857
-------------------------------------------
 include/linux/rfkill.h       |   32 -
 include/net/bluetooth/mgmt.h |   87 ----
 net/bluetooth/mgmt.c         |  308 ---------------
 net/wireless/mesh.c          |  142 -------
 10 files changed, 7 insertions(+), 2096 deletions(-)
