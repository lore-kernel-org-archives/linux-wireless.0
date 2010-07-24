Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0GXJGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 05:06:30 -0400
Subject: Re: [PATCH] mac80211: simplify key locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100724053301.GA6773@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
	 <20100724053301.GA6773@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 11:06:25 +0200
Message-ID: <1279962385.8223.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-23 at 22:33 -0700, Jouni Malinen wrote:
> On Tue, Jun 01, 2010 at 10:19:19AM +0200, Johannes Berg wrote:
> 
> > net/mac80211/key.c
> commit ad0e2b5a00dbec303e4682b403bb6703d11dcdb2
> 
> >  void ieee80211_key_free(struct ieee80211_key *key)
> 
> > -	if (!key->sdata) {
> > -		/* The key has not been linked yet, simply free it
> > -		 * and don't Oops */
> 
> It looks like this function can still be called with key->sdata == NULL
> in some cases and that does indeed result in an oops below:
> 
> > +	local = key->sdata->local;
> 
> 
> I've seen this issue pop up in FT testing and based on a quick code
> review, at least ieee80211_add_key() calls ieee80211_key_free() in an
> error case (sta not found) without having first called
> ieee80211_key_link(). Which one is wrong - the caller or the freeing
> function? Should we just restore the previous key->sdata == NULL handler
> here?

I think it's just another stupid bug.

I removed the comment because the linked vs. not linked handling is a
bit different now I think ... I don't think we should restore the NULL
handling as it was before, since __ieee80211_key_free() should be able
to handle this now.

The fix should be passing in the local pointer to ieee80211_key_free() I
guess. Can you try that?

johannes

