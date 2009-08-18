Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34682 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZHRAfv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 20:35:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 17:35:53 -0700
Date: Mon, 17 Aug 2009 17:35:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
Message-ID: <20090818003550.GG15363@mosca>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
 <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
 <1250283993.4411.1.camel@johannes.local>
 <43e72e890908171000r52f59cb6tbfef751324bf9968@mail.gmail.com>
 <1250545069.25876.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1250545069.25876.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 02:37:49PM -0700, Johannes Berg wrote:
> On Mon, 2009-08-17 at 10:00 -0700, Luis R. Rodriguez wrote:
> > On Fri, Aug 14, 2009 at 2:06 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> > > On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> > >> We can now remove that comment about mac80211 requiring
> > >> cfg80211 and do that for the user.
> > >
> > > "now"? What changed to make this possible?
> > >
> > > NAK this change, because with it, it's possible to select
> > > mac80211 = Y
> > > -> cfg80211 = Y
> > > while rfkill = M
> > >
> > > which will break the kernel build.
> > 
> > I'm able to do this with current kconfig, does this need to be fixed?
> 
> I don't think you can select this with the current config since cfg80211
> depends on RFKILL == CFG80211 || RFKILL == n.
> 
> So you can do
> CFG80211 = m
> RFKILL = m
> 
> CFG80211 = *
> RFKILL = n
> 
> CFG80211 = *
> RFKILL = y
> 
> but NOT
> 
> CFG80211 = y
> RFKILL = m


Ah I see, thanks. OK how about this then:

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] wireless: make mac80211 select cfg80211

This lets us keep mac80211 on the menu map even if cfg80211
is not enabled. We now remove that pesky comment about this.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/Kconfig |    5 +----
 net/rfkill/Kconfig   |    1 +
 net/wireless/Kconfig |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 8300d19..8fc6ae6 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,6 +1,6 @@
 config MAC80211
 	tristate "mac80211 - SoftMAC device support"
-	depends on CFG80211
+	select CFG80211
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4
@@ -23,9 +23,6 @@ config MAC80211
 	  When built as a module mac80211 will be built as mac80211, if not sure
 	  you should build this as a module.
 
-comment "CFG80211 needs to be enabled for MAC80211"
-	depends on CFG80211=n
-
 if MAC80211 != n
 
 config MAC80211_RC_PID
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index eaf7658..65e98b8 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -3,6 +3,7 @@
 #
 menuconfig RFKILL
 	tristate "RF switch subsystem support"
+	depends on CFG80211 || !CFG80211
 	help
 	  Say Y here if you want to have control over RF switches
 	  found on many WiFi and Bluetooth cards.
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 982004b..524aeaf 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,5 @@
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
-	depends on RFKILL || !RFKILL
 	---help---
 	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
 	  Enable this if you have a wireless device.
-- 
1.6.3.3

