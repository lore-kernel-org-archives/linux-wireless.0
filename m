Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55415 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0KMSoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:44:10 -0500
Received: by gxk23 with SMTP id 23so2391038gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:44:09 -0800 (PST)
Message-ID: <4CDEDC74.3040902@lwfinger.net>
Date: Sat, 13 Nov 2010 12:44:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Womack <james.c.womack@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org>
In-Reply-To: <loom.20101113T191727-421@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2010 12:18 PM, James Womack wrote:
> 
> It's good to see that this problem is being examined closely. I have been living
> with this issue on my EeePC 701SD for some time and it has been very
> frustrating. I can confirm that the same issue Robie describes occur for my
> 701SD with r8187se wireless card (Fn+F2 causes a kernel panic when turning the
> wireless card off -- this doesn't seem to occur when turning it on if the
> netbook starts up with the wireless adapter off). This has occured in Ubuntu
> versions 9.04 through to 10.10. I recently switched to Debian Squeeze (testing,
> beta1), currently running 2.6.32-5-686 kernel and am experiencing an identical
> problem. I'm not experienced in debugging this type of issue myself, but would
> be happy to test any suggested fixes for the issue and report back results
> (though you would need to advise as to how to do this and what to include in
> replies).

Testing would require that you have kernel source, apply the patches, and build
a new kernel with those included. On some distros, these steps are easier than
for others. Is your skill set up to this?

I will push the patch that changes the panic/crash into a simple warning with
the request that this be applied to stable. If/when this happens, you will have
that fix in your standard kernel. How long it takes will depend on the distro.

It is strange that I was not aware of this problem until Robie recently posted
in this list. Running the RTL8187SE on my computer has been a pain as the BIOS
in my computer does not have that device in its whitelist of approved devices.
As such, rebooting with it required that I shut down, remove the card, boot to
GRUB, and then hot-plug the card while being careful not to short it. That
changed in the past 2 days as I now have an ExpressCard to mini PCIe extender
that allows me to boot with the card installed. Unfortunately, I do not yet know
how to change the RFKILL setting with this device.

Larry
