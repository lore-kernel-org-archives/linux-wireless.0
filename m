Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:64021 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0BNRVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 12:21:51 -0500
Received: by iwn39 with SMTP id 39so1502904iwn.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 09:21:49 -0800 (PST)
Message-ID: <4B78312A.7060308@lwfinger.net>
Date: Sun, 14 Feb 2010 11:21:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Frederic Leroy <fredo@starox.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
References: <4B38A298.7070103@googlemail.com>	<1262037590.16627.99.camel@localhost.localdomain>	<3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>	<20100213234456.5ae49b67@houba>	<20100214004010.GB18815@tuxdriver.com> <20100214131810.1a8b49ac@houba>
In-Reply-To: <20100214131810.1a8b49ac@houba>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2010 06:18 AM, Frederic Leroy wrote:
>  
> It was my impression too, but as you say, YMMV. It will be my first
> driver, although I already hacked the kernel, make netfilters modules
> and read lwn ;).
> 
> For the process, it is still unclear for me. I copy rtl8180*[ch] to
> rtl8192*[ch], and start to hack into to make clean git patches ?
> 
> On which tree should I base my work : 
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git ?

Before you start with the mainline driver, I would suggest a little cleanup of
the driver in staging. The Realtek drivers are full of dead code such as

//	unused code that is not a comment

or

	if (0) {
	....
	} else {
	...
	}
or

#ifdef SOMECONFIGVARIABLE
	....
#else
	....
#endif

and finally

	if (priv->config_var) {
		....
	} else {
		....
	}

where config_var is set to some initial value and _NEVER_ changed.

When you are trying to translate their code to a new driver, such dead code is a
major distraction. My recommendations are as follows:

* Make certain the driver in staging works in its present form.

* Prepare a patch to eliminate the unused branches of if(0) and if(1) code and
the code that has been commented out. After the driver is tested to check for
silly mistakes and the patch passes scripts/checkpatch, push the patch to GregKH
for inclusion in future releases. If something prevents you from reaching the
goal of a mainline driver, at least your efforts will be not be lost.

* Next pick one of the ifdef variables, determine if the existing make file sets
it, and eliminate it from the code. After successful testing, push that patch to
Greg. Repeat until all such configuration variables are eliminated.

* Now start working on the priv->config_var stuff that never changes.

* The next step would be to convert the driver to use the standard EEPROM module
rather than their code. I just did that for the RTL8187SE driver. I can provide
a copy of that patch if it has not reached wireless-testing by the time you need it.

After the staging driver is leaner and cleaner, then you can start on the port.
As the RTL8192SU is a USB device, you may want to start with rtl8187 rather than
rtl8180, which is a PCI device. Once you reach the point of getting a driver
that has minimal functionality, you can use the USB capture routines to compare
your version with the one that works.

Writing a new driver is a very involved process as I have found with the
RTL8187SE. In fact, my first two attempts failed, in large part because I did
not do the steps above. The current attempt looks more promising as it has
successfully read the EEPROM and is about 1000 register read/write steps toward
getting the device initialized.

Larry
