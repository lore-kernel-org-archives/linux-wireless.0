Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56409 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaHKPFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:05:08 -0400
Message-ID: <1407769505.9844.8.camel@jlt4.sipsolutions.net> (sfid-20140811_170513_342149_E9E33D4F)
Subject: Re: [PATCH] mac80211: fix chantype recalc warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Aug 2014 17:05:05 +0200
In-Reply-To: <1406553419-16196-1-git-send-email-michal.kazior@tieto.com> (sfid-20140728_152602_275094_B446F46C)
References: <1406553419-16196-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140728_152602_275094_B446F46C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-28 at 15:16 +0200, Michal Kazior wrote:
> When a device driver is unloaded local->interfaces
> list is cleared. If there was more than 1
> interface running and connected (bound to a
> chanctx) then chantype recalc was called and it
> ended up with compat being NULL causing a call
> trace warning.
> 
> Warn if compat becomes NULL as a result of
> incompatible bss_conf.chandef of interfaces bound
> to a given channel context only.

Err, this slipped my radar - where does this need to go?

Also - is this really the right thing? Why does this happen in this
situation? Shouldn't they all be not connected or not have a chanctx or
be compatible?

johannes

