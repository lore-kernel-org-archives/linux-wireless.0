Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44395 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYQz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 12:55:56 -0400
Message-ID: <5424491B.4000402@candelatech.com> (sfid-20140925_185558_682270_D4523395)
Date: Thu, 25 Sep 2014 09:55:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Pink <pink@Informatik.TU-Cottbus.DE>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about debugging mac80211 without printk
References: <542448C0.9040505@Informatik.TU-Cottbus.DE>
In-Reply-To: <542448C0.9040505@Informatik.TU-Cottbus.DE>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2014 09:54 AM, Pink wrote:
> Hi,
> 
> actually if have the following problem, if have a lot of debug messages using printk inside the mac layer but if there is a
> critical bug in the source code of the mac80211 module
> the system goes into kernel panic state during execution. Unfortunately so far i now, it isn't possible
> after a system restart to identify the rough position of the bug looking for the debug msg's written before the bug has occured in
> dmesg or syslog because the messages were not saved in follow of the crash.
> 
> Now i thought user mode linux (uml) is maybe a potential solution to identify the bug, if the kernel running the mac layer
> is executed as virtual machine in uml. But i didn't found any kind of description how to forward the physical wireless card except using TAP/TUN device to the
> vm so
> that the kernel inside the vm can run its mac layer directly on the card.
> 
> Now my question what tools are you use for the development and testing of the ath wireless driver
> as well as the complete wireless stack including mac80211. Is it user mode linux or something else?
> If user mode linux is used, is there any howto available to forward the atheros card to the vm.

Have you tried using a serial-console?  That is usually adequate for getting
crash dumps and resolving most issues.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

