Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYHDDjj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 23:39:39 -0400
Subject: Re: [PATCH] iwlwifi: Don't use buffer allocated on the stack for
	led names
From: Zhu Yi <yi.zhu@intel.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <alpine.LNX.1.10.0808012143050.2294@titan.stealer.net>
References: <alpine.LNX.1.10.0808012143050.2294@titan.stealer.net>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:39:30 +0800
Message-Id: <1217821170.3107.17.camel@debian.sh.intel.com> (sfid-20080804_053942_610861_6DB68ABF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-01 at 21:57 +0200, Sven Wegener wrote:
> Having the buffer on the stack and even re-using it for all led
> devices is bad.
> Not being able to resolve the name member of the led device structure
> to a
> meaningful value leads to confusion during ad-hoc debugging and
> potential
> breakage in the future, if we ever decide to access the name member
> outside of
> the registration function. Move the buffer to our private per led
> device
> structures so that it is accessible after registration.
> 
> A quick grep didn't yield any occurence of using the led device name
> parameter
> outside of the led device registration function, so currently we
> should already
> be safe for normal operation.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

