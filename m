Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57656 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0KLApH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 19:45:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PGhlI-0003NV-QY
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 01:45:04 +0100
Received: from function.justgohome.co.uk ([217.169.15.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 01:45:04 +0100
Received: from rb-oss-3 by function.justgohome.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 01:45:04 +0100
To: linux-wireless@vger.kernel.org
From: Robie Basak <rb-oss-3@justgohome.co.uk>
Subject: r8187se panic
Date: Fri, 12 Nov 2010 00:41:50 +0000 (UTC)
Message-ID: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm getting a panic when I to turn off the wireless using the Fn-F2
combination on my Asus Eee PC 701SDX. Although I'm using Ubuntu 10.10,
I've tried it using the mainline kernel (as supplied by Ubuntu for
testing bugs against mainline). So far I've reproduced consistently
against Ubuntu's 2.6.35-22-generic-pae as well as Ubuntu-supplied
mainstream 2.6.35-02063504.201008271919 and
2.6.37-020637rc1.201011020905.

There are no problems at all if I rmmod r8187se before hitting the
switch; I can turn wireless back on and r8187se autoloads and wireless
works fine.

I have also reported this to Ubuntu downstream; that report also
includes various automatic information about my system you might find
helpful: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285

Please also see my side note in that report about r8187se causing a hang
after disconnecting AC after suspend. I don't know if that is related or
not.

I can't seem to get a crash dump. Setting /proc/sys/kernel/panic doesn't
seem to help the kernel reboot after a panic. I've taken a photo of what
I can see at http://i.imgur.com/QSXMD.jpg

Is this a problem with Eee PC ACPI or in r8187se? Which way up is the
backtrace? I think it's most-recent first at an educated guess?

What else can I do? I'm happy to hack, try patches etc.  Any pointers
would be appreciated, particularly towards getting a full dump - I've
spent a while trying to find a solution but haven't got anywhere. I've
installed (Ubuntu) linux-crashdump but nothing appears in /var/crash,
presumably because I'm killing the power since I can't get it to reboot,
and there's no reset button. If you need me to compile a kernel direct
from mainstream source instead of using the Ubuntu mainstream builds I
can manage that.

Cheers,

Robie

