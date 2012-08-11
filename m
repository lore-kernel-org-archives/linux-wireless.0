Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37485 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2HKK5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 06:57:32 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [wireless-testing:master 68/100] drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast
Date: Sat, 11 Aug 2012 12:57:26 +0200
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20120811084404.GA7755@localhost> <201208111229.35167.chunkeey@googlemail.com> <20120811104133.GA9132@localhost>
In-Reply-To: <20120811104133.GA9132@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208111257.26417.chunkeey@googlemail.com> (sfid-20120811_125813_323854_ED063FD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 11 August 2012 12:41:33 Fengguang Wu wrote:
> On Sat, Aug 11, 2012 at 12:29:34PM +0200, Christian Lamparter wrote:
> > On Saturday 11 August 2012 11:59:51 Fengguang Wu wrote:
> > > On Sat, Aug 11, 2012 at 11:49:47AM +0200, Christian Lamparter wrote:
> > >   CC [M]  drivers/net/wireless/p54/eeprom.o
> > [...]
> > >   LD [M]  drivers/net/wireless/p54/p54common.o
> > > make: Leaving directory `/c/wfg/tip'
> > > wfg@bee ~/tip/obj-compiletest% ..
> > > wfg@bee ~/tip% q pop
> > > Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812
> > > Restoring drivers/net/wireless/p54/eeprom.c
> > > 
> > Is this patch 1, or patch 2... or both?
> 
> It's the only applied patch (and is from you).

Ok, either I'm confusing, or I confused myself.

In the original response I sent you two patches.
take a look: There's "patch 1: make rawpower __u16"

and the other one is:

"patch2: use max_t"

what I want to know: Which patch fixed the warning as
it looks like from your response that you have applied
both on the same time on that try:
> Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812

I have the suspicion that "patch1" actually
doesn't do anything in this regard, but you
never know.

Regards,
	Chr

BTW: I've attached just one patch (patch2 - this time)
So, you don't need to extract it from the other mail
and can just apply this one. Thanks!
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
