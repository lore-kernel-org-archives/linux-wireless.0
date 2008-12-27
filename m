Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39380 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYL0HiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 02:38:22 -0500
Subject: Re: How to install Ath5 driver?
From: Pavel Roskin <proski@gnu.org>
To: rajith pr <rajithpr@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fd38e5150812261051y29851b18sf5638c57e355d6f2@mail.gmail.com>
References: <fd38e5150812251125n62086e63y64584282fbe9dbe4@mail.gmail.com>
	 <1230245303.16253.8.camel@dv>
	 <fd38e5150812261051y29851b18sf5638c57e355d6f2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 02:38:19 -0500
Message-Id: <1230363499.2633.54.camel@dv> (sfid-20081227_083833_342181_5E9B7602)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-12-27 at 00:21 +0530, rajith pr wrote:
> Hi Pavel,
> 
> I intend to work on the ath5k driver only. Iam actually stuck with the
> Enabling ath5k section of
> http://wireless.kernel.org/en/users/Drivers/ath5k. May be a trivial
> think but i dont have an option but ask :-)
> 
> Enabling ath5k section talks about some configuration but i dont know
> where to configure these. Should i run some configuration tool and
> follow the steps ??

I've edited that text slightly to mention kernel configuration in the
beginning.  It's mentioned later in the text.

The kernel configuration is described in the README file in the Linux
sources.  There are several ways to configure the kernel, such as "make
menuconfig" and "make xconfig", but they all edit the ".config" file in
the directory where the kernel is going to be compiled.

In my opinion, "make menuconfig" is more intuitive that the X based
configuration tools.

To enable ath5k, you need "CONFIG_ATH5K=m" or "CONFIG_ATH5K=y" to appear
in .config along with the required dependencies of the driver.  "m" is
for compiling ath5k as a module, "y" is for compiling into the kernel.
I think compiling as module is more convenient in most cases.

I don't know any automatic way to enable a particular option and its
dependencies, so you'll need to go through the configuration and enable
the dependencies manually.  The link you referred to tells you what
options to enable.

Actually, that page is becoming obsolete.  SoftMAC is gone from the
current git repository.  ath5k has other dependencies, such as PCI.  But
I was reluctant to edit that text, as some users may be compiling older
kernel, where SoftMAC is present.  As for PCI and some other
dependencies, they are most likely already enabled, so mentioning them
could confuse some users.

-- 
Regards,
Pavel Roskin
