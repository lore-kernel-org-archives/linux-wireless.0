Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51996 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2KZRyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 12:54:43 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8 2/4] wireless: allow Atheros card to not depend on ath.ko
Date: Mon, 26 Nov 2012 19:54:38 +0200
Message-ID: <2506395.2kHeiLs1u6@lx-vladimir> (sfid-20121126_185459_840240_83DD1917)
In-Reply-To: <CAB=NE6V2DTQD9Q2Chj0ftk4oYE1aykCJtCaeAu_WSp3RTVSjhA@mail.gmail.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <87mwyaw1vj.fsf@purkki.adurom.net> <CAB=NE6V2DTQD9Q2Chj0ftk4oYE1aykCJtCaeAu_WSp3RTVSjhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, November 22, 2012 10:54:20 AM Luis R. Rodriguez wrote:


On Nov 22, 2012 8:41 AM, "Kalle Valo" <kvalo@adurom.com> wrote:
>
> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:
>
> >> > As was discussed, I prepared this patch that address Kconfig issue for the
> >> > Atheros wifi cards.
> >> >
> >> > Any opinions on this?
> >>
> >> Looks good to me, but I didn't check that carefully...
> >>
> >> Actually I think ath6kl can make use of this as well, it shouldn't
> >> depend anything from ath.ko.
> >
> > Indeed it should.
>
> -ECONFUSED :)
>
> Do you mean that ath6kl should or should not depend on ath.ko?
Should not.
  Luis

Patch with ath6kl excluded follows.

> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

>From 0a94dcf0b652d71dbcf079823f4b03cd14ddbc47 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 26 Nov 2012 19:51:46 +0200
Subject: [PATCH] wireless: allow Atheros card to not depend on ath.ko

There are 2 different things:
- sub-menu for "Atheros Wireless cards" family
- module ath.ko with common Atheros code

Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
Thus, being "Atheros card" and "depending on ath.ko" was the same.

To allow module to belong to the
"Atheros Wireless cards" family but not use ath.ko,
2 conditions above need to be separated.

So, this patch introduce new Kconfig variable ATH_CARDS for belonging
to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
variable to express dependency on common Atheros code in ath.ko. Modules
that depend on this common code now express it by setting ATH_COMMON.

Right now, ath6kl do not depend on common code and thus do not set ATH_COMMON.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig          |    7 +++++--
 drivers/net/wireless/ath/ar5523/Kconfig   |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig    |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig    |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig |    1 +
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index c25dcf1..1a67a4f 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,4 +1,7 @@
-menuconfig ATH_COMMON
+config ATH_COMMON
+	tristate
+
+menuconfig ATH_CARDS
 	tristate "Atheros Wireless Cards"
 	depends on CFG80211 && (!UML || BROKEN)
 	---help---
@@ -14,7 +17,7 @@ menuconfig ATH_COMMON
 
 	  http://wireless.kernel.org/en/users/Drivers/Atheros
 
-if ATH_COMMON
+if ATH_CARDS
 
 config ATH_DEBUG
 	bool "Atheros wireless debugging"
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 11d99ee..0d320cc 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -1,6 +1,7 @@
 config AR5523
        tristate "Atheros AR5523 wireless driver support"
        depends on MAC80211 && USB
+       select ATH_COMMON
        select FW_LOADER
        ---help---
          This module add support for AR5523 based USB dongles such as D-Link
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 338c5c4..c9f81a3 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,6 +1,7 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on (PCI || ATHEROS_AR231X) && MAC80211
+	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index c7aa664..5fc15bf 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -17,6 +17,7 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211
+	select ATH_COMMON
 	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 267d5dc..13a2045 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -1,6 +1,7 @@
 config CARL9170
 	tristate "Linux Community AR9170 802.11n USB support"
 	depends on USB && MAC80211 && EXPERIMENTAL
+	select ATH_COMMON
 	select FW_LOADER
 	select CRC32
 	help
-- 
1.7.10.4




