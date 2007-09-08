Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:50590 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXIHM7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 08:59:39 -0400
Date: Sat, 8 Sep 2007 14:59:38 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: COMMON symbol warnings
Message-ID: <20070908125938.GA9802@deine-taler.de>
References: <1189100314.28781.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189100314.28781.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> After my compile run with __CHECK_ENDIAN__ the modules were built and I
...
> WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw-mac80211/zd1211rw-mac80211] is COMMON symbol
> WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw/zd1211rw] is COMMON symbol
> 
> any idea what that means? It's from scripts/mod/modpost.c:
>         switch (sym->st_shndx) {
>         case SHN_COMMON:
>                 warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
>                 break;

It looks like that modpost warns about symbols that are shared
between objects. In the zd1211rw case this is a extern symbol
shared between objects, but this has never created an issue.
Surely one could write a function which returns the pointer to
prevent the warning, but I can't see the definite necessity.

-- 
Uli Kunitz
