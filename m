Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0MSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 07:18:52 -0500
Message-ID: <1356610754.15149.11.camel@jlt4.sipsolutions.net> (sfid-20121227_131855_726162_5B372851)
Subject: Re: [PATCH 5/7] ath6kl: convert ath6kl_info/err/warn macros to real
 functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:19:14 +0100
In-Reply-To: <20121227114447.27069.54329.stgit@localhost6.localdomain6> (sfid-20121227_125310_781763_6DBF0411)
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
	 <20121227114447.27069.54329.stgit@localhost6.localdomain6>
	 (sfid-20121227_125310_781763_6DBF0411)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 13:44 +0200, Kalle Valo wrote:

> +	va_start(args, fmt);
> +	vaf.va = &args;
> +	ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
> +	va_end(args);

Note that by inserting the tracing here later, you're relying on the
fact that "%pV" does va_copy(). This isn't true in all kernel versions,
I think there's on version or so where %pV is supported but didn't
va_copy(). That may lead to problems (I don't remember what kind) here.

This is relevant for compat only, I think I carry a patch there to add
va_copy() into the tracing or something.

johannes

