Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37097 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2HKJty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 05:49:54 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [wireless-testing:master 68/100] drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast
Date: Sat, 11 Aug 2012 11:49:47 +0200
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20120811084404.GA7755@localhost>
In-Reply-To: <20120811084404.GA7755@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201208111149.47874.chunkeey@googlemail.com> (sfid-20120811_115047_640655_81F9C729)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 11 August 2012 10:44:04 Fengguang Wu wrote:
> Hi Christian,
> 
> FYI, there are new compile warnings show up in

Thanks for telling me. Are these "normal" gcc's warnings
for PPC? Because the usual C=2 CF=-D__CHECK_ENDIAN__
doesn't show anything (on a x86 no cross-compile).

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git master
> head:   0eba6e668abe4e0760d9d5e20921cc6000a77a85
> commit: 9bc63816be9bf504414d350e605a4b30f857907d [68/100] p54: parse output power table
> config: powerpc-allmodconfig (attached as .config)
> 
> All error/warnings:
> 
> drivers/net/wireless/p54/eeprom.c: In function 'p54_get_maxpower':
> drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> drivers/net/wireless/p54/eeprom.c:292:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> drivers/net/wireless/p54/eeprom.c:293:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> drivers/net/wireless/p54/eeprom.c:294:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]

interesting, rawpower is declared as u16.
whereas le16_to_cpu returns a __u16. 
(is that all, or is there something I don't see?)

Anyway, since you are currently the only person
I know, would you mind telling me if either (or
both?) of those patches has/have an effect?

patch 1: make rawpower __u16
---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d4d8610..f503a3b 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -283,7 +283,7 @@ static int p54_get_maxpower(struct p54_common *priv, void *data)
 	case PDR_SYNTH_FRONTEND_LONGBOW: {
 		struct pda_channel_output_limit_longbow *pda = data;
 		int j;
-		u16 rawpower = 0;
+		__u16 rawpower = 0;
 		pda = data;
 		for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
 			struct pda_channel_output_limit_point_longbow *point =
---

patch2: use max_t
---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d4d8610..0a9a3e7 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -288,10 +288,10 @@ static int p54_get_maxpower(struct p54_common *priv, void *data)
 		for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
 			struct pda_channel_output_limit_point_longbow *point =
 				&pda->point[j];
-			rawpower = max(rawpower, le16_to_cpu(point->val_qpsk));
-			rawpower = max(rawpower, le16_to_cpu(point->val_bpsk));
-			rawpower = max(rawpower, le16_to_cpu(point->val_16qam));
-			rawpower = max(rawpower, le16_to_cpu(point->val_64qam));
+			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_qpsk));
+			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_bpsk));
+			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_16qam));
+			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_64qam));
 		}
 		/* longbow seems to use 1/16 dBm units */
 		return rawpower / 16;
---

Regards,
	Christian
