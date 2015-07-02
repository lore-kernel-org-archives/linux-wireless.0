Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46534 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbbGBLlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:41:37 -0400
Message-ID: <1435837294.2285.10.camel@sipsolutions.net> (sfid-20150702_134140_353934_FB4D9D68)
Subject: Re: Association race when acting as AP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Date: Thu, 02 Jul 2015 13:41:34 +0200
In-Reply-To: <CA+BoTQk1YT-CD2sA3Ev9v7+H2hV=OszawLFg9e4FehFoaPkV7A@mail.gmail.com> (sfid-20150702_122838_890623_0571CDEC)
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
	 <1435826335.2285.6.camel@sipsolutions.net>
	 <CA+BoTQk1YT-CD2sA3Ev9v7+H2hV=OszawLFg9e4FehFoaPkV7A@mail.gmail.com>
	 (sfid-20150702_122838_890623_0571CDEC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 12:28 +0200, Michal Kazior wrote:

> > Ultimately, depending on the nl80211 capabilities, the station 
> > should
> > in fact be added (as unauthenticated) before even sending the
> > authentication response frame, and then stepping through the stages
> > appropriately.
> 
> While I think it does make sense (I thought of this too, sounds
> desirable) I think it wouldn't solve the race problem entirely. The
> station might no longer be rejected with Deauth but may end up
> confusing AP's internal/offloaded STA powersave state depending on
> implementation detail (what do you do when you receive NullFunc from 
> a
> station that you don't know assoc id of or isn't fully initialized as
> associated?). 

We'd send a deauth with "class 3 frame from unassociated STA" reason :)

> I.e. station should be transitioned to Assoc state
> before sending the Assoc Resp frame.

Yeah, I guess that's still true, but it doesn't preclude adding the
station before auth response and sending an auth response depending on
whether it could be added; perhaps we need to set it to authenticated
just before sending the frame as well though.


johannes
