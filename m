Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:44623 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYL1T3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 14:29:52 -0500
Received: by rn-out-0910.google.com with SMTP id k40so3066215rnd.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 11:29:51 -0800 (PST)
Message-ID: <fd38e5150812281129g204a757dyc543190f2a58f6ae@mail.gmail.com> (sfid-20081228_202956_855549_ABD3677B)
Date: Mon, 29 Dec 2008 02:29:51 +0700
From: "rajith pr" <rajithpr@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: How to install Ath5 driver?
In-Reply-To: <fd38e5150812280754pb11f846k984e9aa7dcc1a56c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <fd38e5150812251125n62086e63y64584282fbe9dbe4@mail.gmail.com>
	 <1230245303.16253.8.camel@dv>
	 <fd38e5150812261051y29851b18sf5638c57e355d6f2@mail.gmail.com>
	 <1230363499.2633.54.camel@dv>
	 <fd38e5150812280754pb11f846k984e9aa7dcc1a56c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

The problem is solved, the issue was with the initrd. I think 2.6.27
cannot init 2.6.28. After creating a 2.6.28 initrd using mkinitramfs
command, iam able to
boot my new kernel and modprobe ath5k.

Thanks,
Rajith.

On Sun, Dec 28, 2008 at 10:54 PM, rajith pr <rajithpr@gmail.com> wrote:
> Hi Pavel,
>
> Thanks for the explanation. Now, i understand enabling the Ath5 driver
> requires installation of a configured kernel and installation of
> driver.
>
> I have been able to build both the configured kernel and the drivers.
> But when i boot the kernel i get a run time errr: Coudnt open
> directory /lib/modules/2.6.28-rc9-wl but i have confirmed the the
> directory exists.
>
> google search is not giving me any result to fix the issue on ubuntu.
> I have pasted my menu.lst for my grub loader.  My Ubuntu 8.10, kernel
> 2.6 is my new kernel.
>
> title           Ubuntu 8.10, kernel 2.6.27-7-generic
> root            ()/ubuntu/disks
> kernel          /boot/vmlinuz-2.6.27-7-generic
> root=UUID=F8B8EED2B8EE8E86 loop=/ubuntu/disks/root.disk ro
> ROOTFLAGS=syncio quiet splash
> initrd          /boot/initrd.img-2.6.27-7-generic
>
> title           Ubuntu 8.10, kernel 2.6.27-7-generic (recovery mode)
> root            ()/ubuntu/disks
> kernel          /boot/vmlinuz-2.6.27-7-generic
> root=UUID=F8B8EED2B8EE8E86 loop=/ubuntu/disks/root.disk ro
> ROOTFLAGS=syncio  single
> initrd          /boot/initrd.img-2.6.27-7-generic
>
> title           Ubuntu 8.10, memtest86+
> root            ()/ubuntu/disks
> kernel          /boot/memtest86+.bin
>
> title           My Ubuntu 8.10, kernel 2.6
> root            ()/ubuntu/disks
> kernel          /boot/mylinux root=UUID=F8B8EED2B8EE8E86
> loop=/ubuntu/disks/root.disk ro ROOTFLAGS=syncio quiet splash
> initrd          /boot/initrd.img-2.6.27-7-generic
>
> Any idea wht is the issue or pointers to resolve this?
>
> Thanks,
> Rajith
>
> On Sat, Dec 27, 2008 at 2:38 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Sat, 2008-12-27 at 00:21 +0530, rajith pr wrote:
>>> Hi Pavel,
>>>
>>> I intend to work on the ath5k driver only. Iam actually stuck with the
>>> Enabling ath5k section of
>>> http://wireless.kernel.org/en/users/Drivers/ath5k. May be a trivial
>>> think but i dont have an option but ask :-)
>>>
>>> Enabling ath5k section talks about some configuration but i dont know
>>> where to configure these. Should i run some configuration tool and
>>> follow the steps ??
>>
>> I've edited that text slightly to mention kernel configuration in the
>> beginning.  It's mentioned later in the text.
>>
>> The kernel configuration is described in the README file in the Linux
>> sources.  There are several ways to configure the kernel, such as "make
>> menuconfig" and "make xconfig", but they all edit the ".config" file in
>> the directory where the kernel is going to be compiled.
>>
>> In my opinion, "make menuconfig" is more intuitive that the X based
>> configuration tools.
>>
>> To enable ath5k, you need "CONFIG_ATH5K=m" or "CONFIG_ATH5K=y" to appear
>> in .config along with the required dependencies of the driver.  "m" is
>> for compiling ath5k as a module, "y" is for compiling into the kernel.
>> I think compiling as module is more convenient in most cases.
>>
>> I don't know any automatic way to enable a particular option and its
>> dependencies, so you'll need to go through the configuration and enable
>> the dependencies manually.  The link you referred to tells you what
>> options to enable.
>>
>> Actually, that page is becoming obsolete.  SoftMAC is gone from the
>> current git repository.  ath5k has other dependencies, such as PCI.  But
>> I was reluctant to edit that text, as some users may be compiling older
>> kernel, where SoftMAC is present.  As for PCI and some other
>> dependencies, they are most likely already enabled, so mentioning them
>> could confuse some users.
>>
>> --
>> Regards,
>> Pavel Roskin
>>
>
