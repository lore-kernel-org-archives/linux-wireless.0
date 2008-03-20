Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:53289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYCTSMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 14:12:50 -0400
Date: Thu, 20 Mar 2008 19:13:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH/RFC] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
Message-ID: <20080320181310.GA17884@uranus.ravnborg.org> (sfid-20080320_181255_424441_619E2AC3)
References: <1206023695.16475.137.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206023695.16475.137.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 20, 2008 at 03:34:55PM +0100, Johannes Berg wrote:
> In many cases, especially in networking, it can be beneficial to
> know at compile time whether the architecture can do unaligned
> accesses. This patch introduces a new Kconfig symbol
> 	ARCH_CAN_UNALIGNED_ACCESS

Can we please have a single symbol defined and name it:
HAVE_*

Then the architectures that HAVE this feature can select the symbol.

So somewhere in maybe lib/Kconfig or maybe arch/Kconfig add:

config HAVE_UNALIGNED_ACCESS_SUPPORT
	bool

And then for x86 select the symbol:

 config X86
+	select HAVE_UNALIGNED_ACCESS_SUPPORT


This follows the suggestion as available in
Documentation/kbuild/kconfig-language.txt

	Sam
