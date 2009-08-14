Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021AbZHNTdV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 15:33:21 -0400
Subject: Re: Spare warnings - wireless drivers
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 12:33:22 -0700
Message-Id: <1250278402.30019.6401.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-13 at 13:31 -0700, Luis R. Rodriguez wrote:

>   CHECK   drivers/net/wireless/ipw2x00/ipw2100.c
> include/net/inet_sock.h:208:17: warning: do-while statement is not a
> compound statement
> drivers/net/wireless/ipw2x00/ipw2100.c:2847:21: warning: symbol 'i'
> shadows an earlier one
> drivers/net/wireless/ipw2x00/ipw2100.c:2770:16: originally declared here
> drivers/net/wireless/ipw2x00/ipw2100.c:7888:22: warning: symbol 'mode'
> shadows an earlier one
> drivers/net/wireless/ipw2x00/ipw2100.c:188:12: originally declared here
> drivers/net/wireless/ipw2x00/ipw2100.c:7952:18: warning: symbol 'mode'
> shadows an earlier one
> drivers/net/wireless/ipw2x00/ipw2100.c:188:12: originally declared here
> drivers/net/wireless/ipw2x00/ipw2100.c:8000:18: warning: symbol 'mode'
> shadows an earlier one

[...]

Thanks Luis.

Does not look like sparse was ever run for ipw2x00 ... the driver
specific ones will be addressed. Seems like other people also ran into
the:

>   CHECK   drivers/net/wireless/ipw2x00/libipw_module.c
> include/net/inet_sock.h:208:17: warning: do-while statement is not a
> compound statement

There is already a patch for this one ([1]) but I cannot tell of the
kmemcheck folks merged it.

Reinette

[1] http://thread.gmane.org/gmane.linux.kernel/861983

