Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:30496 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750737AbYKKF3B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 00:29:01 -0500
Date: Tue, 11 Nov 2008 05:28:59 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: a couple of small bugs in compat-wireless
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: compat-masters@lists.madwifi.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <252423.50522.qm@web23105.mail.ird.yahoo.com> (sfid-20081111_062915_511692_3D45F5E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"make unload" doesn't unload iwlagn, and iwlagn keeps mac80211 in the kernel, which results in make unload failing. Needs to include iwlagn
in the unload list in script/unload.sh. Should be trivial to fix, and
probably quicker "just do it" then having a patch from me :-). 

There is another annoyance - probably not strictly speaking a bug, but nonetheless, for some unexplainable reasons, I expect "make clean" to do the usual thing, and it doesn't - this is probably easy to fix by having an almost empty libertas_tf/Makefile ? (this shows an older compat-wireless , but current compat-wireless also seem to have this problem 
if I remember correctly):
---------------
scripts/Makefile.clean:17: /tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile: No such file or directory
make[4]: *** No rule to make target `/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile'.  Stop.
make[3]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf] Error 2
make[2]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless] Error 2
make[1]: *** [_clean_/tmp/compat-wireless-2008-10-23] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27.5-92.fc10.x86_64'
make: *** [clean] Error 2
---------------



      
