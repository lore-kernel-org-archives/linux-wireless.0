Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1FHLCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:02:05 -0400
Subject: Re: [RFC] cfg80211: Fix handling of previous_auth deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org> (sfid-20110607_013247_523227_4CDD0493)
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	 (sfid-20110607_013247_523227_4CDD0493)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:02:02 +0200
Message-ID: <1307530922.3961.4.camel@jlt3.sipsolutions.net> (sfid-20110608_130208_823429_CACA7F67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 16:00 -0700, Paul Stewart wrote:
> The WLAN_REASON_PREV_AUTH_NOT_VALID DEAUTH message is sent
> to remove current successful authentications, not to to abort
> a new authentication attempts.  Therefore, filter this reason
> code out when deciding whether to remove authtry_bsses[] entries.
> 
> This is the least invasive change which prevents this issue
> from appearing.  

Maybe I'm confused -- what's "this issue"?

> It doesn't address the fact that the mac80211
> code still retries authentications if it is DEAUTHed for some
> other reason during authentication.  If one of those retries
> succeeds the client can do nothing with it sicne authtry_bsses[]
> has been cleared.

So basically you're getting a deauth while trying to auth? Rather than a
rejected auth? Hmm.

It seems mac80211 shouldn't pass such up since it isn't actually
connected. But then we just pass them up and rely on cfg80211 to sort it
out. Why do we even attempt to remove something from authtry_bsses when
receiving a deauth frame? This only makes sense when we sent it
ourselves and want to abort the authentication that way I guess?

johannes


