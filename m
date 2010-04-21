Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24496 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0DUWik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 18:38:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 15:38:40 -0700
Date: Wed, 21 Apr 2010 15:38:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_hw: make two initvals consto for the AR9001
 family
Message-ID: <20100421223838.GA2266@tux>
References: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
 <1271802516-15195-2-git-send-email-lrodriguez@atheros.com>
 <1271886897.6212.9.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1271886897.6212.9.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 21, 2010 at 02:54:57PM -0700, Pavel Roskin wrote:
> On Tue, 2010-04-20 at 18:28 -0400, Luis R. Rodriguez wrote:
> > This makes ar5416Addac_9160 and ar5416Addac_9160 const
> > I guess we skipped them long ago.
> 
> It's a step in the right direction, but it makes the code more
> misleading.  Those arrays are not constant.
> 
> Please see ath9k_hw_def_set_addac() and ath9k_hw_4k_set_addac().  They
> both modify ah->iniAddac for AR9160.
> 
> The compiler doesn't warn about it because the definition of
> INIT_INI_ARRAY uses a cast that removes the const modifier.
> 
> It's not an objection against the patch, it's just a reminder that we
> have a real problem with the code that is likely to affect parallel
> operation of more than one AR9160 device in the system, especially if
> they are working on different channels.

Yeah good point, well not sure how to resolve that, other than leaving
it as is for now. Let me know if you come up with something.

  Luis
