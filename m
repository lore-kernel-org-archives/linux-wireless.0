Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57231 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466Ab0KOVG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 16:06:28 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PI6Fq-000874-Re
	for linux-wireless@vger.kernel.org; Mon, 15 Nov 2010 22:06:22 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 22:06:22 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 22:06:22 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Mon, 15 Nov 2010 21:05:36 +0000
Message-ID: <ibs7c3$3dn$1@dough.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net> <ibpauk$v12$1@dough.gmane.org> <4CE0455A.50709@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <4CE0455A.50709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/11/10 20:23, Larry Finger wrote:
> On 11/14/2010 12:49 PM, James Womack wrote:
>> Hey, I tried patching the kernel I downloaded, but the dry runs both
>> presented errors detailed below:
>>
>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>> /home/james/rtl8187se_change_panic_to_warn
>> patching file drivers/staging/rtl8187se/r8185b_init.c
>> Hunk #1 succeeded at 356 with fuzz 2 (offset 92 lines).
>> Hunk #2 FAILED at 302.
>> 1 out of 2 hunks FAILED -- saving rejects to file
>> drivers/staging/rtl8187se/r8185b_init.c.rej
>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>> /home/james/rtl8187se_
>> rtl8187se_change_panic_to_warn  rtl8187se_lock_pci_remove
>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>> /home/james/rtl8187se_lock_pci_remove
>> patching file drivers/staging/rtl8187se/r8180_core.c
>> patch unexpectedly ends in middle of line
>> patch: **** unexpected end of file in patch
>> james@mercury:/usr/src/linux-source-2.6.32$
>>
>> Do I need to do anything to the kernel source before applying the patches?
>
> You needed a different version of the patch for 2.6.32. Apply the attached
> version. You only need the one patch.
>
> Larry

Hello,

I managed to compile the patched kernel. To confirm - the issue of the 
kernel panic occuring when Fn-F2 is used to turn off the wireless card 
is resolved. Thank you. I'll let you know if I notice any side effects 
from the patch.

James

