Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYETDt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 23:49:28 -0400
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
From: Zhu Yi <yi.zhu@intel.com>
To: John Goulah <jgoulah@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <183c1cc10805191823w5855227akce4aa1bb9f1b6198@mail.gmail.com>
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
	 <1211168475.31033.9.camel@debian.sh.intel.com>
	 <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com>
	 <1211245264.2532.24.camel@debian.sh.intel.com>
	 <183c1cc10805191823w5855227akce4aa1bb9f1b6198@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:48:55 +0800
Message-Id: <1211255335.7814.5.camel@debian.sh.intel.com> (sfid-20080520_054932_157841_1EEEF65D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-19 at 21:23 -0400, John Goulah wrote:
> Ok,  I assume you mean the patch for the kernel config that allows
> this all to work?

I mean the recent patch introduces CONFIG_IWLWIFI.

> Would that mean you're not supporting compiling on any kernel older
> than 2.6.26 with this change?

I'd suggest we patch compat-wireless like this (given the fact it
doesn't make use of Kconfig).

Thanks,
-yi

--- config.mk	2008-05-20 11:46:55.000000000 +0800
+++ /tmp/config.mk	2008-05-20 11:46:49.000000000 +0800
@@ -30,6 +30,7 @@ ifneq ($(CONFIG_PCI),)
 
 CONFIG_ATH5K=m
 CONFIG_ATH5K_DEBUG=n
+CONFIG_IWLWIFI=m
 CONFIG_IWLCORE=m
 CONFIG_IWL3945=m
 CONFIG_IWL4965=m


