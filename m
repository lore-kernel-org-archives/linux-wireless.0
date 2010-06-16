Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:56324 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0FPP5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 11:57:48 -0400
Subject: [PATCH v2] ipw2200: Enable LED by default
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: reinette.chatre@intel.com, ilw@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	TJ <ubuntu@tjworld.net>, BrianK.Lee@atheros.com
In-Reply-To: <AANLkTikUFtsqjGV9oAFkPhceeHzFlfs98psdAPBE5z2N@mail.gmail.com>
References: <1276649713.6127.276.camel@emiko>
	 <AANLkTikp4M3Pnh0FEYEayo75FMY8M8j4OaByiiV6EAXJ@mail.gmail.com>
	 <1276656060.26299.23.camel@emiko>
	 <AANLkTikUFtsqjGV9oAFkPhceeHzFlfs98psdAPBE5z2N@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 08:57:39 -0700
Message-ID: <1276703859.30732.7.camel@emiko>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 21:36 -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 15, 2010 at 7:41 PM, Leann Ogasawara
> <leann.ogasawara@canonical.com> wrote:
> > On Tue, 2010-06-15 at 18:20 -0700, Luis R. Rodriguez wrote:
> >> On Tue, Jun 15, 2010 at 5:55 PM, Leann Ogasawara
> >> <leann.ogasawara@canonical.com> wrote:
> >> > Hi All,
> >> >
> >> > As documented in 2005 in Documentation/networking/README.ipw2200, "The
> >> > LED code has been reported to hang some systems when running ifconfig
> >> > and is therefore disabled by default."  We've however been carrying the
> >> > following patch in our Ubuntu kernel for quite some time which enables
> >> > the ipw2200 LED by default.  This was a result of numerous user
> >> > requests.  We've seen no subsequent bug reports of systems hanging due
> >> > to the the LED code being enabled by default.  I'd therefore like to
> >> > propose the following patch to enable the LED by default.  This patch
> >> > was originally authored by TJ.  I apologize in advance that I do not
> >> > have TJ's full first and last name for provenance.
> >> >
> >> > Thanks,
> >> > Leann
> >> >
> >> > >From 315246037a0edab4d626de6ccb68c73d3fe61ce3 Mon Sep 17 00:00:00 2001
> >> > From: ubuntu@tjworld.net <ubuntu@tjworld.net>
> >> > Date: Mon, 23 Mar 2009 20:29:28 +0000
> >> > Subject: [PATCH] ipw2200: Enable LED by default
> >> >
> >> > BugLink: http://bugs.launchpad.net/bugs/21367
> >> >
> >> > Enable LED by default and update the MODULE_PARM_DESC.  The original
> >> > reason for defaulting to disabled was documented in 2005 and noted, "The
> >> > LED code has been reported to hang some systems when running ifconfig
> >> > and is therefore disabled by default."  This no longer appears
> >> > applicable and users have been requesting this be enabled for several
> >> > years.
> >> >
> >> > Originally-by: TJ <ubuntu@tjworld.net>
> >>
> >> Does Originally-by also imply he has read the Certificate of Origin
> >> and that he agrees for his code to be used in that way? That is the
> >> purpose of the SOB anyway, but if you took his code, does that imply
> >> that he agrees to it too?
> >
> > I'd CC'd TJ on the initial email, so I'm hoping he will respond here to
> > your inquiry.  I can say that he had submitted the original form of the
> > patch to the Ubuntu kernel-team mailing list back in March, 2009:
> >
> > https://lists.ubuntu.com/archives/kernel-team/2009-March/005013.html
> >
> > In that original submission he did provide his official SOB.
> >
> > The patch was then applied with slight modification by Tim Gardner to
> > the Ubuntu kernel.  In forwarding this upstream, I wanted to give TJ the
> > proper credit for originating the patch even though it's undergone some
> > slight modification (ie the MODULE_PARM_DESC change).  TJ had not
> > officially signed off on this final form of the patch which is the
> > reason I used "Originally-by:".  If there is a better approach please
> > let me know.
> 
> In that case I would just recommend to keep his original SOB, then it
> would go through you/tim whoever it goes through until it reaches
> Linus. But just my $0.02.

Re-sending and just replacing the Originally-by: with TJ's actual SOB.

Thanks,
Leann

>From 315246037a0edab4d626de6ccb68c73d3fe61ce3 Mon Sep 17 00:00:00 2001
From: ubuntu@tjworld.net <ubuntu@tjworld.net>
Date: Mon, 23 Mar 2009 20:29:28 +0000
Subject: [PATCH] ipw2200: Enable LED by default

BugLink: http://bugs.launchpad.net/bugs/21367

Enable LED by default and update the MODULE_PARM_DESC.  The original
reason for defaulting to disabled was documented in 2005 and noted, "The
LED code has been reported to hang some systems when running ifconfig
and is therefore disabled by default."  This no longer appears
applicable and users have been requesting this be enabled for several
years.

Signed-off-by: TJ <ubuntu@tjworld.net>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
---
 Documentation/networking/README.ipw2200 |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
index 80c7285..e4d3267 100644
--- a/Documentation/networking/README.ipw2200
+++ b/Documentation/networking/README.ipw2200
@@ -171,7 +171,7 @@ Where the supported parameter are:
   
   led
 	Can be used to turn on experimental LED code.
-	0 = Off, 1 = On.  Default is 0.
+	0 = Off, 1 = On.  Default is 1.
 
   mode
 	Can be used to set the default mode of the adapter.  
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 3aa3bb1..0805569 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -96,7 +96,7 @@ static int network_mode = 0;
 static u32 ipw_debug_level;
 static int associate;
 static int auto_create = 1;
-static int led_support = 0;
+static int led_support = 1;
 static int disable = 0;
 static int bt_coexist = 0;
 static int hwcrypto = 0;
@@ -12083,7 +12083,7 @@ module_param(auto_create, int, 0444);
 MODULE_PARM_DESC(auto_create, "auto create adhoc network (default on)");
 
 module_param_named(led, led_support, int, 0444);
-MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)");
+MODULE_PARM_DESC(led, "enable led control on some systems (default 1 on)");
 
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
-- 
1.7.0.4



