Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:43092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLAKas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:30:48 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1766616fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:30:46 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 0/5] Makefile improvement and fixes
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:30:44 +0100
Message-ID: <20081201103016.18024.80454.stgit@localhost> (sfid-20081201_113103_827418_8AF66729)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



I've been asked by a colleague Gentoo developer (Tony Vroon) to look
at a build failure with parallel make[1] in crda, and I decided to
take a closer look to the Makefile.

With these patches applied, --as-needed build works, as well as
parallel make, the dependencies are properly handle so that changing a
file will only rebuild the correct one, and it's as parallel as
feasible with no recursive make.

HTH,
Diego

[1] http://bugs.gentoo.org/show_bug.cgi?id=3D249181

---

Diego E. 'Flameeyes' Petten=C3=B2 (5):
      Ignore built files.
      Don't use recursive make for verify target.
      Make it possible to switch gcrypt/openssl via knob.
      Fix dependencies for parallel make and others.
      Fix building with --as-needed LD flag.


 .gitignore |    2 ++
 Makefile   |   33 +++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
