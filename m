Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab1FVUwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:52:31 -0400
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1308775296-11627-1-git-send-email-arik@wizery.com> (sfid-20110622_224204_011118_097AB353)
References: <1308775296-11627-1-git-send-email-arik@wizery.com>
	 (sfid-20110622_224204_011118_097AB353)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 22:52:28 +0200
Message-ID: <1308775948.29571.30.camel@jlt3.sipsolutions.net> (sfid-20110622_225235_016971_0DC67FA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 23:41 +0300, Arik Nemtsov wrote:
> Sometimes when reporting a MIC failure rx->key may be unset. This
> code path is hit when receiving a packet meant for a multicast
> address, and decryption is performed in HW.
> 
> Fortunately, the failing key_idx is not used for anything up to
> (and including) usermode, so we allow ourselves to drop it on the
> way up when a key cannot be retrieved.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

It'd be nice to also update the docs for the cfg80211 function to
document the -1 special case, but other than that:

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

