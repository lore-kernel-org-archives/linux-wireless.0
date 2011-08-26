Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:39031 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751248Ab1HZJCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 05:02:40 -0400
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	linux-kernel@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	devel@linuxdriverproject.org, Greg KH <gregkh@suse.de>,
	Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
In-Reply-To: <CACna6ryWtZG9obyj0w=d5jrF-y1pYNmanhkze2F429kHCLCi=A@mail.gmail.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
	 <CACna6ryWtZG9obyj0w=d5jrF-y1pYNmanhkze2F429kHCLCi=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 02:02:37 -0700
Message-ID: <1314349357.9624.3.camel@Joe-Laptop> (sfid-20110826_110256_931866_84C68AA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-26 at 10:55 +0200, Rafał Miłecki wrote:
> 2011/8/25 Joe Perches <joe@perches.com>:
> > Convert multiple BRCMF_<debug_level> macros to a single
> > brcmf_dbg(level, fmt, ...) macro.
> I'm not sure if that "_dbg" suffix is a really good choice. You use
> "_dbg" for all the kinds of messages, while "DEBUG" is already one
> kind of messages.

No, not really.  These _are_ debugging uses.

The #include is called dhd_dbg.h and
the whole block is guarded by

#if defined(BCMDBG)

> We have also other types like EMERG, ALERT, CRIT,
> ERR, WARNING, NOTICE, INFO and DEBUG.

Except for the last, those aren't debugging uses,
these are.



