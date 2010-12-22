Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49193 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0LVSb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:31:59 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:31:42 -0800
Date: Wed, 22 Dec 2010 13:31:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] compat-wireless: build led support conditionally
Message-ID: <20101222183155.GB8384@tux>
References: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
 <AANLkTik9=gSpE6sRoYZu-RZv3PjeQdtf_Y9hc=X-Z7w=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTik9=gSpE6sRoYZu-RZv3PjeQdtf_Y9hc=X-Z7w=@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 10:23:48AM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 22, 2010 at 1:10 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> > diff --git a/config.mk b/config.mk
> > index 964c646..1f95908 100644
> > --- a/config.mk
> > +++ b/config.mk
> > @@ -133,7 +133,9 @@ CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
> >  CONFIG_MAC80211_RC_PID=y
> >  CONFIG_MAC80211_RC_MINSTREL=y
> >  CONFIG_MAC80211_RC_MINSTREL_HT=y
> > +ifdef CONFIG_LEDS_TRIGGERS
> >  CONFIG_MAC80211_LEDS=y
> > +endif #CONFIG_LEDS_TRIGGERS
> 
> Without using a space for the ifdef'd variable the
> include/linux/compat_autoconf.h will end up still defining it but you
> should not get it set on the local Makefiles, in this case we want it
> to not be defined in the compat_autoconf.h as well so how about
> instead (handing off to my atheros address as I use mutt there, one
> second)

>From 47d9c7d253a7b2a78af69f0d8177ee55df74ea0e Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed, 22 Dec 2010 19:10:34 +0100
Subject: [PATCH] compat-wireless: build led support conditionally

Do not build compat-wireless with LED support when the kernel does not
contain a led subsystem.
This fixes some compile problems when CONFIG_LEDS_TRIGGERS is not set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 config.mk |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/config.mk b/config.mk
index 964c646..3a38d34 100644
--- a/config.mk
+++ b/config.mk
@@ -133,7 +133,9 @@ CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
 CONFIG_MAC80211_RC_PID=y
 CONFIG_MAC80211_RC_MINSTREL=y
 CONFIG_MAC80211_RC_MINSTREL_HT=y
-CONFIG_MAC80211_LEDS=y
+ifdef CONFIG_LEDS_TRIGGERS
+ CONFIG_MAC80211_LEDS=y
+endif #CONFIG_LEDS_TRIGGERS
 
 # enable mesh networking too
 CONFIG_MAC80211_MESH=y
@@ -243,7 +245,9 @@ CONFIG_B43_PCI_AUTOSELECT=y
 ifdef CONFIG_PCMCIA
 CONFIG_B43_PCMCIA=y
 endif #CONFIG_PCMCIA
-CONFIG_B43_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_B43_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
 # CONFIG_B43_FORCE_PIO=y
@@ -252,7 +256,9 @@ CONFIG_B43_PHY_N=y
 CONFIG_B43LEGACY=m
 CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
-CONFIG_B43LEGACY_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_B43LEGACY_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 # CONFIG_B43LEGACY_DEBUG=y
 CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
@@ -408,18 +414,24 @@ endif #CONFIG_COMPAT_KERNEL_29
 
 CONFIG_P54_USB=m
 CONFIG_RTL8187=m
-CONFIG_RTL8187_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_RTL8187_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 
 CONFIG_AT76C50X_USB=m
 
 ifndef CONFIG_COMPAT_KERNEL_28
 CONFIG_AR9170_USB=m
-CONFIG_AR9170_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_AR9170_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 endif #CONFIG_COMPAT_KERNEL_28
 
 ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_CARL9170=m
-CONFIG_CARL9170_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_CARL9170_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 # CONFIG_CARL9170_DEBUGFS=y
 # CONFIG_CARL9170_WPC=y
 endif #CONFIG_COMPAT_KERNEL_29
@@ -559,7 +571,9 @@ CONFIG_RT2X00_LIB_CRYPTO=y
 ifdef CONFIG_COMPAT_KERNEL_25
 CONFIG_RT2X00_LIB_LEDS=n
 else #CONFIG_COMPAT_KERNEL_25
-CONFIG_RT2X00_LIB_LEDS=y
+ifdef CONFIG_LEDS_CLASS
+ CONFIG_RT2X00_LIB_LEDS=y
+endif #CONFIG_LEDS_CLASS
 endif #CONFIG_COMPAT_KERNEL_25
 # CONFIG_RT2X00_DEBUG=y
 # CONFIG_RT2X00_LIB_DEBUGFS
@@ -567,7 +581,9 @@ endif
 
 # p54
 CONFIG_P54_COMMON=m
-CONFIG_P54_LEDS=y
+ifdef CONFIG_MAC80211_LEDS
+ CONFIG_P54_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 
 # Atheros
 CONFIG_ATH_COMMON=m
@@ -594,7 +610,9 @@ endif #CONFIG_COMPAT_KERNEL_27
 # In more recent kernel versions use the in kernel rfkill module.
 ifdef CONFIG_COMPAT_KERNEL_31
 CONFIG_RFKILL_BACKPORT=m
-CONFIG_RFKILL_BACKPORT_LEDS=y
+ifdef CONFIG_LEDS_TRIGGERS
+ CONFIG_RFKILL_BACKPORT_LEDS=y
+endif #CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_INPUT=y
 endif #CONFIG_COMPAT_KERNEL_31
 
-- 
1.7.3.2.90.gd4c43

