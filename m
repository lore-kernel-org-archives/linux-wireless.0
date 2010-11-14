Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38087 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0KNStG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 13:49:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PHhdQ-0003rf-B2
	for linux-wireless@vger.kernel.org; Sun, 14 Nov 2010 19:49:04 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 19:49:04 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 19:49:04 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Sun, 14 Nov 2010 18:49:00 +0000
Message-ID: <ibpauk$v12$1@dough.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <4CE00BEE.8060100@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/11/10 16:18, Larry Finger wrote:
> On 11/14/2010 06:22 AM, James Womack wrote:
>> Okay, I've downloaded the necessary tools and extracted the kernel
>> source. I have a tutorial on how to patch and build the kernel. Where
>> should I apply your patches?
>
> Change directory to the main directory of the kernel source - the one with
> subdirectories like arch, block, crypto, drivers, etc. Apply patches with a
> command of the form
>
> patch -p1 --dry-run<  <nameofpatch>
>
> If that works without any error, then leave out the "--dry-run" to apply the
> patch. If/when it is necessary to remove the patch, adding a "-R" option will do
> that.
>
> When you build the kernel, you should do that as a normal user, not root. If the
> source files are not owned by that user, you should do a chown on that tree
> before starting.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Hey, I tried patching the kernel I downloaded, but the dry runs both 
presented errors detailed below:

james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run < 
/home/james/rtl8187se_change_panic_to_warn
patching file drivers/staging/rtl8187se/r8185b_init.c
Hunk #1 succeeded at 356 with fuzz 2 (offset 92 lines).
Hunk #2 FAILED at 302.
1 out of 2 hunks FAILED -- saving rejects to file 
drivers/staging/rtl8187se/r8185b_init.c.rej
james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run < 
/home/james/rtl8187se_
rtl8187se_change_panic_to_warn  rtl8187se_lock_pci_remove
james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run < 
/home/james/rtl8187se_lock_pci_remove
patching file drivers/staging/rtl8187se/r8180_core.c
patch unexpectedly ends in middle of line
patch: **** unexpected end of file in patch
james@mercury:/usr/src/linux-source-2.6.32$

Do I need to do anything to the kernel source before applying the patches?

James

