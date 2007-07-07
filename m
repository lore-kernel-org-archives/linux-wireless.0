Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:41160 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbXGGG4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 02:56:20 -0400
Message-ID: <468F390F.9090206@warmcat.com>
Date: Sat, 07 Jul 2007 07:56:15 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Benjamin Bryant <blbryant@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem installing mac80211 on Fedora Core 7
References: <45b4f7d90707062022j384934a1neb431bad641ef5b1@mail.gmail.com> <45b4f7d90707062023i25dfb913s3e22b404490f245c@mail.gmail.com>
In-Reply-To: <45b4f7d90707062023i25dfb913s3e22b404490f245c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Bryant wrote:

> I'm getting the following output:
> 
> # make patch_kernel
> Patching from compatible/ to /lib/modules/2.6.21-1.3228.fc7/source/:
> + Replaced 57 files.
> Checking for required kernel build updates...
> - checking net/Kconfig and net/Makefile...
> - checking net/core/Makefile for old 'wireless'...
> - checking net/core/dev.c for wireless_proc_init vs. wext_proc_init...
> grep: /lib/modules/2.6.21-1.3228.fc7/source/net/core/dev.c: No such

Hi -

The kernel-devel package doesn't include all the kernel sources, just
include files and so on.  You need the kernel SRPM installed to get all
the c source files.

Since Fedora kernels already have a recent mac80211 in them, depending
on what you want to achieve you may be better off either

 - skipping trying to cook mac80211 at all (I guess this is from iwlwifi)

 - using the latest Fedora development kernel with

     yum --enablerepo development update kernel

 - or using the wireless-dev git with

git clone
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

and copying over /boot/config-<something> as .config in there so you
will be working with the most recent mac80211 all the time.

-Andy
