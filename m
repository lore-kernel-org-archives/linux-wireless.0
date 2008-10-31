Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYJaKGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 06:06:06 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <490A47A0.8060103@lwfinger.net> (sfid-20081031_004807_244853_9DD2736D)
References: <4909EA78.3060700@lwfinger.net>
	 <20081030172919.GA4330@tuxdriver.com>  <490A47A0.8060103@lwfinger.net>
	 (sfid-20081031_004807_244853_9DD2736D)
Content-Type: text/plain
Date: Fri, 31 Oct 2008 11:06:00 +0100
Message-Id: <1225447560.3535.8.camel@johannes.berg> (sfid-20081031_110612_187608_06A3C245)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-30 at 16:47 -0700, Larry Finger wrote:
> John W. Linville wrote:
> > 
> > Yes.  It should have been done long ago -- I had them all in
> > drivers/net/wireless due to my own misinterpretation of the policy
> > in the past.
> 
> I will do it, but not until some timing patches have been reviewed and
> submitted. At least there is some time before the 2.6.29 merge window.

Btw, for the actual execution you may want to send a git patch rather
than a normal patch, that would contain the renames rather than huge
adds/removes. To do that, use "git format-patch -M", "git am" can take
such a special patch, and it looks like this (example done on iw):

diff --git a/Makefile b/Makefile
index 3fa0a83..74b2e16 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,7 @@ CFLAGS += -O2 -g
 LDFLAGS += `pkg-config --libs libnl-1`
 NLVERSION = 1.0
 
-OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o mesh.o genl
.o
+OBJS = iw.o info-test.o phy.o interface.o station.o util.o mpath.o reg.o mesh.o
 genl.o
 ALL = iw
 
 ifeq ($(V),1)
diff --git a/info.c b/info-test.c
similarity index 100%
rename from info.c
rename to info-test.c


johannes

