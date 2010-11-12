Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35861 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0KLCAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 21:00:13 -0500
Received: by vws13 with SMTP id 13so757121vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 18:00:12 -0800 (PST)
Message-ID: <4CDC9FA5.10002@lwfinger.net>
Date: Thu, 11 Nov 2010 20:00:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Robie Basak <rb-oss-3@justgohome.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
In-Reply-To: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 06:41 PM, Robie Basak wrote:
> Hi,
> 
> I'm getting a panic when I to turn off the wireless using the Fn-F2
> combination on my Asus Eee PC 701SDX. Although I'm using Ubuntu 10.10,
> I've tried it using the mainline kernel (as supplied by Ubuntu for
> testing bugs against mainline). So far I've reproduced consistently
> against Ubuntu's 2.6.35-22-generic-pae as well as Ubuntu-supplied
> mainstream 2.6.35-02063504.201008271919 and
> 2.6.37-020637rc1.201011020905.

Is Fn-F2 the radio kill switch?

> There are no problems at all if I rmmod r8187se before hitting the
> switch; I can turn wireless back on and r8187se autoloads and wireless
> works fine.
> 
> I have also reported this to Ubuntu downstream; that report also
> includes various automatic information about my system you might find
> helpful: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285
> 
> Please also see my side note in that report about r8187se causing a hang
> after disconnecting AC after suspend. I don't know if that is related or
> not.
> 
> I can't seem to get a crash dump. Setting /proc/sys/kernel/panic doesn't
> seem to help the kernel reboot after a panic. I've taken a photo of what
> I can see at http://i.imgur.com/QSXMD.jpg
> 
> Is this a problem with Eee PC ACPI or in r8187se? Which way up is the
> backtrace? I think it's most-recent first at an educated guess?

The calling sequence is up screen. Thus rtl8180_pci_remove() calls
unregister_netdev(), etc. It is really tough debugging without seeing what
routine is actually causing the panic.

> What else can I do? I'm happy to hack, try patches etc.  Any pointers
> would be appreciated, particularly towards getting a full dump - I've
> spent a while trying to find a solution but haven't got anywhere. I've
> installed (Ubuntu) linux-crashdump but nothing appears in /var/crash,
> presumably because I'm killing the power since I can't get it to reboot,
> and there's no reset button. If you need me to compile a kernel direct
> from mainstream source instead of using the Ubuntu mainstream builds I
> can manage that.

At this point, I see no point in building a mainstream kernel.

Do you have another host that might be setup as a net console?

Larry
