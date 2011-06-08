Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1FHLol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:44:41 -0400
Subject: Re: [RFC] cfg80211: Fix handling of previous_auth deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com> (sfid-20110608_134252_247174_F1F51856)
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	 <1307530922.3961.4.camel@jlt3.sipsolutions.net>
	 <BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com>
	 (sfid-20110608_134252_247174_F1F51856)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:44:39 +0200
Message-ID: <1307533479.3961.13.camel@jlt3.sipsolutions.net> (sfid-20110608_134444_823851_30327B09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[you should send as text, the list won't accept html]

>         Maybe I'm confused -- what's "this issue"?

> Sorry.  I covered the issue in a previous post but it wasn't threaded
> in.   Here's a summary:
> 
> 
> If you read the IEEE docs just right, they say that if an AP believes
> a STA is authenticated, but it receives an AUTH request, it should
> send a DEAUTH downstream with PREV_AUTH_NOT_VALID.  Some APs actually
> do this.  The STA and AP can fall out of sync, eg, if the STA reboots
> unexpectedly.  What happens then is that the a mac80211 STA will send
> an AUTH, and get a DEAUTH  which will clear authtry_bssess[].
>  mac80211 keeps retrying, though, and the second time the AP sends a
> successful AUTH response and marks the STA authenticated again.
>  Meanwhile cfg80211 doesn't have any state in authtry_bsses[] for the
> AP so it drops the successful reply on the floor.  Thus the state
> mismatch perpetuates.


Right, makes sense.

>         It seems mac80211 shouldn't pass such up since it isn't
>         actually
>         connected. But then we just pass them up and rely on cfg80211
>         to sort it
>         out. Why do we even attempt to remove something from
>         authtry_bsses when
>         receiving a deauth frame? This only makes sense when we sent
>         it
>         ourselves and want to abort the authentication that way I
>         guess?
>         
> It's a little confusing to me that the same function is in charge of
> outgoing and incoming packets, but yes, I see no point in removing
> anything from authtry_bsses[] for a received DEAUTH since it is not
> applicable.

Yeah, indeed. Would not modifying authtry_bsses for a _received_ DEAUTH
fix it?

johannes


