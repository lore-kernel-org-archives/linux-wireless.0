Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40659 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756589Ab2HFPje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:39:34 -0400
Message-ID: <501FE4E9.3080004@xenotime.net> (sfid-20120806_173950_131416_E4AF76BA)
Date: Mon, 06 Aug 2012 08:38:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Christopher Sacchi <chris.sacchi@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Autosleep patch.
References: <CAGh4K3L_nY5B22g5oMBuoY=a1OB7U10yH1ZJvn0dG_O5TVz6+Q@mail.gmail.com>
In-Reply-To: <CAGh4K3L_nY5B22g5oMBuoY=a1OB7U10yH1ZJvn0dG_O5TVz6+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 08:13 AM, Christopher Sacchi wrote:

> This patch (listed below), changes an old function in autosleep.c in
> kernel version 3.5. It's code is listed from the first -- line to the
> 2nd to last -- line.
> This patch was checked with checkpatch.pl with no errors:
> --
> --- power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
> +++ power/autosleepnew.c	2012-08-06 10:52:26.000000000 +0000


The file names should include the full path from the top level of the
kernel source tree.  E.g.:

--- linux.orig/kernel/power/autosleep.c
+++ linux/kernel/power/autosleep.c

This patch uses the name autosleepnew.c, which is not what is
required/expected.

Your previous patches were for wireless (mac80211) components, so they
needed to go to the linux-wireless mailing list.  This patch is not
about wireless, so don't send it to that mailing list, although you
could send it to the linux-pm@vger.kernel.org mailing list.
Please see the MAINTAINERS file for where to send patches.


> @@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
>  	if (!pm_get_wakeup_count(&initial_count, true))
>  		goto out;
> 
> -	mutex_lock(&autosleep_lock);
> +	mutex_lock_interruptable();
> 
>  	if (!pm_save_wakeup_count(initial_count)) {
>  		mutex_unlock(&autosleep_lock);
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> --

Signed-off-by: line is not part of the patch.  It should be near the
end of the patch description, before the actual patch.

Again, please read and follow Documentation/SubmittingPatches.

thanks.

-- 
~Randy
