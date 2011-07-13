Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3962 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1GMMTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:19:16 -0400
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <4E1D4479.8090201@qca.qualcomm.com>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013300.8517.98566.stgit@localhost6.localdomain6>
	 <1310531333.1143.25.camel@Joe-Laptop>  <4E1D4479.8090201@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 05:19:14 -0700
Message-ID: <1310559554.1662.6.camel@Joe-Laptop> (sfid-20110713_141920_870938_A585A3F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 10:08 +0300, Kalle Valo wrote:
> On 07/13/2011 07:28 AM, Joe Perches wrote:
> > On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
> >> diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
> > [] 
> >> +			ath6kl_err("Unable to decrement the command "
> >> +				   "credit count register: %d\n", ret);
> > I think all of these ath6kl_<level> uses in all the patches
> > should coalesce formats that are split across multiple lines.
> > This helps grepping the sources for a specific dmesg.
> > 			ath6kl_err("Unable to decrement the command credit count register: %d\n",
> > 				   ret);
> I agree, that would improve readibility. The reason why the lines were
> split is because of checkpatch warnings. I could unsplit them but then
> someone else might start complaining about high number checkpatch
> warnings about long lines. So I really don't know what to do with them.

Add this patch to checkpatch?
I'll submit it to Andrew Morton later.

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b0aa2c6..c0be3c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -210,7 +210,7 @@ our $typeTypedefs = qr{(?x:
 
 our $logFunctions = qr{(?x:
 	printk|
-	[a-z]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
+	[a-z0-9]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
 	WARN|
 	panic|
 	MODULE_[A-Z_]+



