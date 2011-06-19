Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1FSHdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 03:33:19 -0400
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308422749-16939-1-git-send-email-arik@wizery.com> (sfid-20110618_204617_593817_7090F1B4)
References: <1308422749-16939-1-git-send-email-arik@wizery.com>
	 (sfid-20110618_204617_593817_7090F1B4)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 09:33:16 +0200
Message-ID: <1308468796.4145.0.camel@jlt3.sipsolutions.net> (sfid-20110619_093328_051374_9D862DE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-06-18 at 21:45 +0300, Arik Nemtsov wrote:
> Sometimes when reporting a MIC failure rx->key may be unset. This
> code path is hit when receiving a packet meant for a multicast
> address, and decryption is performed in HW.
> 
> Fortunately, the failing key_idx is not used for anything up to
> (and including) usermode, so we allow ourselves to set a bogus one
> when a key cannot be retrieved.

I guess we don't have a choice, but for the record I don't really like
lying. I'd rather also adjust nl80211 to not have the attribute in this
case, rather than an attribute with a bogus value.

johannes

