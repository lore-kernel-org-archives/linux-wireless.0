Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2F0JXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 05:23:19 -0400
Message-ID: <1340788995.11012.4.camel@jlt3.sipsolutions.net> (sfid-20120627_112323_198771_F3E7D406)
Subject: Re: [PATCH] mac80211: flush queues before deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Jun 2012 11:23:15 +0200
In-Reply-To: <1340621899-15002-1-git-send-email-eliad@wizery.com> (sfid-20120625_125810_846874_3DBECCF4)
References: <1340621899-15002-1-git-send-email-eliad@wizery.com>
	 (sfid-20120625_125810_846874_3DBECCF4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 13:58 +0300, Eliad Peller wrote:
> On deauth/disassoc we tear down all BA sessions. These
> DELBA packets are sent on the appropriate TID, while
> deauth/disassoc is always sent on VO. This sometimes
> ends with the DELBA being sent after the deauth was
> already sent.
> 
> Fix it by flushing all the pending frames before
> sending deauth/disassoc (in ieee80211_send_deauth_disassoc).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> i think flushing in ieee80211_send_deauth_disassoc is the
> easiest thing to do here, as it handles all the (future) cases.
> however, i don't care moving the flush to a higher function
> if someone prefers it.

I thought about this a bit ... Currently we have two calls to this
function, one from the actual set_disassoc() and one from
ieee80211_mgd_deauth(). In the latter case, we don't actually need the
flush I think, and in set_disassoc() we already have a flush call, so I
think it makes more sense there?

johannes

