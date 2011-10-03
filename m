Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14950 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1JCLCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:02:37 -0400
Message-ID: <4E899645.5060708@qca.qualcomm.com> (sfid-20111003_130256_706726_BF179102)
Date: Mon, 3 Oct 2011 14:02:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Pull request: ath6kl 20111001
References: <4E86E7A9.9070909@qca.qualcomm.com>
In-Reply-To: <4E86E7A9.9070909@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again John,

On 10/01/2011 01:12 PM, Kalle Valo wrote:
> here's a pretty big pull request from ath6kl.git. I was supposed to send
> this already earlier, but I wanted to have a fix for an important TCP
> corruption bug first. Even there are quite a few changes, I still ask
> you to consider this for the 3.2 release. It has received extensive
> testing and we have fixed a bunch of bugs from the current version in
> wireless-next.

Actually I had to do an update to the pull request and add the commit
below to make it properly compile on ARM.

commit 62c83ac4d6bcfa6a116c8f1c8ace05cb3933a4f1
Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Mon Oct 3 13:44:40 2011 +0300

    ath6kl: include vmalloc.h in debug.c

I just pushed that change to github to the same for-linville branch.

Also I noticed that while compiling ath6kl for beagleboard I need this:

diff --git a/include/linux/of.h b/include/linux/of.h
index 9180dc5..219c29d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -17,6 +17,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/errno.h>
 #include <linux/kref.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spinlock.h>

But I'll send that to the device tree maintainers.

Kalle
