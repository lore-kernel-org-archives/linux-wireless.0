Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47826 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab0KPJzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 04:55:52 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PIIGU-0002aS-FO
	for linux-wireless@vger.kernel.org; Tue, 16 Nov 2010 10:55:50 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 10:55:50 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 10:55:50 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Tue, 16 Nov 2010 09:55:50 +0000
Message-ID: <ibtkeo$efc$1@dough.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net> <ibpauk$v12$1@dough.gmane.org> <4CE0455A.50709@lwfinger.net> <ibs7c3$3dn$1@dough.gmane.org> <4CE1C5F7.90607@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <4CE1C5F7.90607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/11/10 23:44, Larry Finger wrote:
> On 11/15/2010 03:05 PM, James Womack wrote:
>> On 14/11/10 20:23, Larry Finger wrote:
>>> On 11/14/2010 12:49 PM, James Womack wrote:
>>>> Hey, I tried patching the kernel I downloaded, but the dry runs both
>>>> presented errors detailed below:
>>>>
>>>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>>>> /home/james/rtl8187se_change_panic_to_warn
>>>> patching file drivers/staging/rtl8187se/r8185b_init.c
>>>> Hunk #1 succeeded at 356 with fuzz 2 (offset 92 lines).
>>>> Hunk #2 FAILED at 302.
>>>> 1 out of 2 hunks FAILED -- saving rejects to file
>>>> drivers/staging/rtl8187se/r8185b_init.c.rej
>>>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>>>> /home/james/rtl8187se_
>>>> rtl8187se_change_panic_to_warn  rtl8187se_lock_pci_remove
>>>> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run<
>>>> /home/james/rtl8187se_lock_pci_remove
>>>> patching file drivers/staging/rtl8187se/r8180_core.c
>>>> patch unexpectedly ends in middle of line
>>>> patch: **** unexpected end of file in patch
>>>> james@mercury:/usr/src/linux-source-2.6.32$
>>>>
>>>> Do I need to do anything to the kernel source before applying the
>>>> patches?
>>>
>>> You needed a different version of the patch for 2.6.32. Apply the
>>> attached
>>> version. You only need the one patch.
>>>
>>> Larry
>>
>> Hello,
>>
>> I managed to compile the patched kernel. To confirm - the issue of the
>> kernel panic occuring when Fn-F2 is used to turn off the wireless card
>> is resolved. Thank you. I'll let you know if I notice any side effects
>> from the patch.
>
> After you do the Fn-F2 sequence, there should be a stack dump in the output of
> the dmesg command. Could you please post that? With it, I should be able to find
> what is leading to the original error. It does not happen on my system.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Okay, I used dmesg | tail to print the last 10 lines of dmesg. Hopefully 
this is what you were asking for:

[  812.500300]  [<f81d97c1>] ? eeepc_rfkill_hotplug+0x127/0x142 
[eeepc_laptop]
[  812.500311]  [<c116a27d>] ? acpi_ev_notify_dispatch+0x4c/0x57
[  812.500320]  [<c115db60>] ? acpi_os_execute_deferred+0x1a/0x23
[  812.500330]  [<c103fc20>] ? worker_thread+0x142/0x1c2
[  812.500337]  [<c115db46>] ? acpi_os_execute_deferred+0x0/0x23
[  812.500347]  [<c104289e>] ? autoremove_wake_function+0x0/0x29
[  812.500354]  [<c103fade>] ? worker_thread+0x0/0x1c2
[  812.500362]  [<c1042680>] ? kthread+0x5f/0x64
[  812.500369]  [<c1042621>] ? kthread+0x0/0x64
[  812.500379]  [<c1003ca7>] ? kernel_thread_helper+0x7/0x10
[  812.700057] r8180: WW:Card reset timeout!
[  812.908439] r8180: Freeing irq 18
[  812.920050] r8180 0000:01:00.0: PCI INT A disabled
[  812.920056] r8180: wlan driver removed
[  812.920058]


Regards,
James

