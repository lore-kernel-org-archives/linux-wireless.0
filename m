Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28231 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2HGRrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 13:47:23 -0400
Date: Tue, 7 Aug 2012 10:47:28 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: <mcgrof@kernel.org>,
	<lf_driver_backport@lists.linux-foundation.org>,
	<linux-wireless@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] compat: fix system crash on 2.6.35 when flushing work
Message-ID: <20120807174728.GF3745@lenteja.do-not-panic.com> (sfid-20120807_194736_675427_F95BE578)
References: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 13, 2012 at 10:38:34AM +0200, Zefir Kurtisi wrote:
> Ubuntu 10.10 stock kernel (2.6.35-22-generic) crashes in
> compat_flush_scheduled_work(), that is called e.g. when
> mac80211 module is unloaded.
> 
> The problem was introduced with 80bf8a83
> compat: backport system work queues system_wq and system_long_wq
> 
> The crash happens in compat_flush_scheduled_work() where both
> flush_workqueue() and flush_scheduled_work() are called successively.
> Removing one of them resolves the issue.
> 
> All compat-wireless tarballs after 2012-03-18 are affected.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  compat/compat-2.6.36.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
> index 9190ecd..8f25be0 100644
> --- a/compat/compat-2.6.36.c
> +++ b/compat/compat-2.6.36.c
> @@ -140,7 +140,6 @@ void compat_flush_scheduled_work(void)
>  	 * go with the old kernel's one first for now (keventd_wq) and
>  	 * if think its reasonable later we can flip this around.
>  	 */
> -	flush_workqueue(system_wq);
>  	flush_scheduled_work();
>  }
>  EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);

I've reverted this in favor for Hauke's fix. Although he did not revert
your patch after inspecing his change it was apparant that the endless
loop was really the issue. The backported fix is on the linux-3.5.y
branch and the backported patch does a bit more justice to review
the fix. I've load / unload tested this on v2.6.35.

I kicked out a new v3.5 release based on this, the -3 release.

>From 5ea4da5f1e96fc1aba89b62290f0aaab0e943b0a Mon Sep 17 00:00:00 2001
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 7 Aug 2012 09:19:08 -0700
Subject: [PATCH] compat: revert 4595ae7579bf17 (upstream 3da0495c)

This reverts the commit:

commit 4595ae7579bf177150d7a661644c852f7d549bfa
Author: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Date:   Fri Jul 13 10:38:34 2012 +0200

    compat: fix system crash on 2.6.35 when flushing work

    Upstream commit 3da0495cf863288b6798e121ccf93c4453c6c768

    Ubuntu 10.10 stock kernel (2.6.35-22-generic) crashes in
    compat_flush_scheduled_work(), that is called e.g. when
    mac80211 module is unloaded.

    The problem was introduced with 80bf8a83
    compat: backport system work queues system_wq and system_long_wq

    The crash happens in compat_flush_scheduled_work() where both
    flush_workqueue() and flush_scheduled_work() are called successively.
    Removing one of them resolves the issue.

    All compat-wireless tarballs after 2012-03-18 are affected.

    Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
    Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>

And then applies the 2 upstream commits:

>From 78fda91b330657f1d66afc32d18cae99f4783f21 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 2 Aug 2012 18:28:01 +0200

    compat: fix endless recursion in flush_scheduled_work

    The hader file defines flush_scheduled_work(a)
    compat_flush_scheduled_work(a), which causes flush_scheduled_work() and
    compat_flush_scheduled_work() to be the same function.

    With this patch it calls the actual function in the kernel.

    This fixes problems when unloading mac80211 from compat-wireless.

    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>

>From 19041dd7befe97f476c187bc15442cd738c67f37 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 7 Aug 2012 00:36:20 +0200

    compat: fix undef syntax

   Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
   Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>

The real fix was to avoid the recursive call to
flush_scheduled_work() by undef'ing it on the c
file.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat-2.6.36.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 8f25be0..72ada4a 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -133,6 +133,7 @@ int compat_schedule_delayed_work_on(int cpu,
 }
 EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
 
+#undef flush_scheduled_work
 void compat_flush_scheduled_work(void)
 {
 	/*
@@ -140,6 +141,7 @@ void compat_flush_scheduled_work(void)
 	 * go with the old kernel's one first for now (keventd_wq) and
 	 * if think its reasonable later we can flip this around.
 	 */
+	flush_workqueue(system_wq);
 	flush_scheduled_work();
 }
 EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);
-- 
1.7.10.4

