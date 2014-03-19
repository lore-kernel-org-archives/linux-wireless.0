Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39189 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933380AbaCSOCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:02:52 -0400
Message-ID: <1395237744.2854.12.camel@dubbel> (sfid-20140319_150255_396905_EC0D9EE2)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 19 Mar 2014 16:02:24 +0200
In-Reply-To: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com>
References: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: protect AP VLAN list with local->mtx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 13:14 +0100, Michal Kazior wrote:
> It was impossible to change chanctx of master AP
> for AP VLANs because the copy function requires
> RTNL which can't be simply taken in mac80211 code
> due to possible deadlocks.
> 
> This is required for future chanctx reservation
> that re-bind vifs to new chanctx. This requires
> safe AP VLAN iteration without RTNL.
> 
> Now VLANs can be iterated while holding either
> RTNL or local->mtx because the list is modified
> while holding both of these locks.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Applied to my mac80211-next-csa.git tree.

--
Luca.

