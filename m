Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KLQJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:09:51 -0500
Received: by fxm6 with SMTP id 6so224328fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 08:09:50 -0800 (PST)
Message-ID: <4CDD66C4.10603@lwfinger.net>
Date: Fri, 12 Nov 2010 10:09:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Robie Basak <rb-oss-3@justgohome.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk>
In-Reply-To: <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk>
Content-Type: multipart/mixed;
 boundary="------------040104030608020409020509"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040104030608020409020509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/12/2010 09:55 AM, Robie Basak wrote:
> Larry,
> 
> The patches have helped - thanks!
> 
> Failure case A:
>   1) Boot with AC power connected and wireless on
>   2) Switch wireless off
>   3) Kernel panic
> 
> With just the change_panic_to_warn patch, case A works fine now.
> However, the following sequence of events now causes some sort of
> infinite loop (with lots of stack traces in dmesg) instead of a hang
> like it did before:
> 
> Failure case B:
>   1) Boot with AC power connected and wireless on
>   2) Suspend
>   3) Resume (and Network Manager kicks in to reconnect etc)
>   4) Remove AC power
>   5) (wait a few seconds)
>   6) Some sort of loop with lots being dumped to dmesg, no wireless
> connection resumes
> 
> With the addition of the lock_pci_remove patch, case B goes away too.
> However, adding more to the failure case still causes problems:
> 
> Failure case C:
>   1) Boot with AC power connected and wireless on
>   2) Suspend
>   3) Resume (and Network Manager kicks in to reconnect etc)
>   4) Remove AC power
>   5) (wait a few seconds)
>   6) Restore AC power
>   7) (wireless disconnects; some sort of loop in dmesg; it does manage
> to associate at times but this never lasts long)
>   8) (network Manager gives up) but the loop in dmesg continues
>   9) Reloading the module and toggling the wireless switch seems to fix
>      it
> 
> Note that I can work around cases B and C by having
> SUSPEND_MODULES=r8187se in /etc/pm/config.d. The original problem does
> seem to be resolved. Case C also seems pretty non-deterministic. I can't
> reproduce it reliably. I have also managed to cause a hang using various
> combinations of switching AC power, suspend and the wireless switch but
> I haven't managed to reproduce it.
> 
> All of the stuff in dmesg I could see seems to be the same RE|WE bits
> not clear stack trace from your patch.
> 
> Does this help? Is there anything else I can do?

OK, we are making progress.

First of all, that locking patch that I sent is garbage. Throw it away.

I have fixed the problem with the remove_proc_entry() warning. See the attached
patch.

Apply the new patch and the "change panic to warning" patch and redo your case
B. Send me the dmesg output and a description of what happened. That data you
can send directly. No need to spam the list with the lengthy dmesg output.

I think my guess of a locking problem was correct, but turning IRQs off was not
the solution. I hope the stack dumps from the first patch will clue me as to the
source of the problem.

Larry

--------------040104030608020409020509
Content-Type: text/plain;
 name="rtl8187se_fix_proc_entry_warning"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8187se_fix_proc_entry_warning"

When the driver is unloaded, it generates a warning at fs/proc/generic.c:816.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-realtek/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- linux-realtek.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-realtek/drivers/staging/rtl8187se/r8180_core.c
@@ -322,7 +322,7 @@ void rtl8180_proc_remove_one(struct net_
 		remove_proc_entry("stats-tx", priv->dir_dev);
 		remove_proc_entry("stats-rx", priv->dir_dev);
 		remove_proc_entry("registers", priv->dir_dev);
-		remove_proc_entry(dev->name, rtl8180_proc);
+//		remove_proc_entry(dev->name, rtl8180_proc);
 		priv->dir_dev = NULL;
 	}
 }

--------------040104030608020409020509--
