Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [206.117.179.246] ([206.117.179.246]:35703 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975Ab2A3Vnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 16:43:33 -0500
Message-ID: <1327959791.25132.56.camel@joe2Laptop> (sfid-20120130_224336_257761_1F03C4BD)
Subject: Re: micro-project proposal -- WARN_ON -> WARN_ON_ONCE under
 drivers/net/wireless
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Jan 2012 13:43:11 -0800
In-Reply-To: <20120130192811.GD2493@tuxdriver.com>
References: <20120130192811.GD2493@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 14:28 -0500, John W. Linville wrote:
> Anyone looking for a little "janitorial" project to do under the
> drivers/net/wireless tree?
> 
> find drivers/net/wireless/ -type f -exec grep -H WARN_ON {} \; | \
> 	grep -v WARN_ON_ONCE | wc -l
> 653
> 
> That looks like an awful lot of "WARN_ON" calls.  Do all of them
> really need to SPAM the log files every single time they are hit?
> Couldn't a lot of them be WARN_ON_ONCE instead?
> 
> Patches welcome...
> 
> John

$ grep -rP --include=*.[ch] "\bWARN_ON\s*\(" drivers/net/wireless | \
  wc -l
280

There are also:
$ grep -rP --include=*.[ch] "\bWARN_ON\s*\(" drivers/net/wireless | \
  grep "define"
drivers/net/wireless/b43legacy/b43legacy.h:# define B43legacy_WARN_ON(x)	WARN_ON(x)
drivers/net/wireless/b43/b43.h:# define B43_WARN_ON(x)	WARN_ON(x)

Any reason anyone can think of this
shouldn't be a sed conversion?

