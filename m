Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18950 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab0DEUdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 16:33:47 -0400
Subject: Re: Convert arc4 from a cipher into a block cipher
From: Pavel Roskin <proski@gnu.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Content-Type: text/plain
Date: Mon, 05 Apr 2010 16:33:45 -0400
Message-Id: <1270499625.28743.37.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-04-03 at 09:49 +0200, Sebastian Andrzej Siewior wrote:
> This patch series converts arc4 into a block cipher and converts all its
> users (except those in staging) to use it. The first two patches ensure
> that two implementations can coexist, the following patches convert each
> user so we remain bisectable.
> - lib80211_crypt_tkip was tested with ipw2200
> - mac80211 was tested with zd1211rw

Are you trying to speed up arc4?  Or you want to simplify the code?  Or
maybe you are trying to make arc4 unsuitable for anything other than WEP
and TKIP?  The later should be fine, actually, considering the known
security issues.

-- 
Regards,
Pavel Roskin
