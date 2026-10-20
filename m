Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792479547;
	b=ZOlyGKeGrtP5v0vojJKy/0V3pBeQAlMOL8ErIzgC4/GiHW6St5+qwmZhh+cCKrNrkZNz
	 MjcMqeEErpEzQqzGsFX9svOvG3Wpe+PfABQxgn7s78TTU09nXkpJpdVZYJCEWGOqzYmZl
	 TH0PdzxIdHZbqOsPCH8jJj85iRgB/fwOzzJz294yz8lKsibC0m57daIqyE8/soQzZ+HL5
	 naj6DyWMfIXSexq33gHbsgqiNMk1tCb0jgPpMkCwD+MFAI0owLUAPHfP7CyRK+MWz/otb
	 mKAwQR9rvBn0Z9Jx9Vawn81Fys8ZEwqQc3cO9j2kGZtviZLqjeIN3wG0KDmqP2OCM0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792479547;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=4/hno+IzPu9Ull5daDpWz8o3VVQOt88GXjWGdsHXcmg=;
	b=KWZTAMwclwPPRIGXynPxXQWoOnJ0dMrISQQVUEceEOMl4kgqFMDpVEgKe/Nw82uXfzcj
	 X0+045qWYKxEB1DEiTI89Y7Zb5qt1sGKDL1LTi4E7YQasyNZdtiKoI/mwOogcxUC+k9mg
	 aFLekrhPBOKgtG9mIbUqUNq+ETJMFNusQMoP08UePLi+Sm8Y1E34kLUEhiNfrxB5ydpkn
	 nzf15jTmtbudy4L1lnFrYReChPRPElhiDsah70nO+mFF7R7wzyY8BNlFpb5andKsN9+eb
	 lhiVAbIV1r8jsJwAWnk8s3QY83t/gjGTMJjHxnfvjxXXmw0odpnlPn1UQjxBYsVVrJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146BA606A32D;
	Tue, 20 Oct 2026 06:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1889B1F000C7;
	Tue, 20 Oct 2026 06:59:04 +0000 (UTC)
Date: Tue, 20 Oct 2026 07:58:30 +0100
From: Lee Jones <lee@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
Message-ID: <20261020065830.GA1206986@google.com>
References: <20260928100508.3487525-1-lee@kernel.org>
 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
 <20260928142434.GA2112133@google.com>
 <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>

Sorry for the delay.  It's been a busy few weeks.

> On Mon, 2026-09-28 at 15:24 +0100, Lee Jones wrote:
> > 
> > The commit message was purposely vague due to the fact that the change
> > fixes a security issue and I didn't want to publish a HOWTO guide for
> > exploiting it.  However, I obviously overdid it a little and left out
> > the reasoning you'd need to review the patch.  The short version is that
> > an unauthenticated peer can currently change an associated station's
> > power save state with frames that shouldn't be able to have that
> > capability which can be used against the station.
> > 
> > Happy to send you the details off-list.
> 
> I think I've (conceptually) known about this issue for ... years?
> 
> First, arguably wake-to-doze are _less_ interesting to attack, since
> then the TIM bit will end up getting set and if the STA isn't sleeping
> it'll see the beacon and recover fairly easily (though not entirely sure
> we actually implement that in mac80211), and if it keeps sending traffic
> then the state corruption is short-lived.
> OTOH, corrupting doze-to-wake could lead to traffic getting dropped if
> TX filtering status isn't implemented well on the AP side/driver since
> the STA is actually sleeping and won't see any frames.
> 
> Second, I don't think in general this issue is fixable, and while it's
> good to implement this closer to the spec, security wise it doesn't
> really do anything as is?
> 
> If, for example, there's any bufferable MMPDU the attacker can just
> replay it - we've been doing this before MIC/replay check forever
> (unless that's offloaded). It can also - although this is harder -
> intercept and modify the PM bit, since it's not protected by the AAD.
> 
> It's also wrong that we're doing this *after* the reorder buffer, since
> that potentially holds the frames for a long time, and the spec says to
> look at the PM bit after the frame exchange sequence completes (REVmf
> 11.2.3.2). We should fix that too, but it doesn't really matter for this
> discussion:
> 
> Any unprotected complete frame exchange sequence can modify the state
> anyway, QoS NDP for example.
> 
> >  - Rewrite the commit message to explain the problem and the reasoning
> >    properly, rather than just quoting the spec.
> > 
> >  - Make the PM handling consistent in both directions, so it doesn't
> >    honour the bit in one case and ignore it in the other, while keeping
> >    the re-authenticating station case from 9fef65443388 working.
> > 
> > Does that work for you?
> 
> Well, I think it's really only a spec compliance cleanup, but then we
> might as well try to fix some of the other issues?
> 
> I also think we might be better off making sure that as a client we
> handle the TIM indicating traffic while awake and send a wake frame, and
> perhaps checking AP side handles filtered/un-acked traffic well.

Agreed on both counts.

Since the PM bit in the Frame Control header is unauthenticated and
processed prior to decryption, an unauthenticated QoS Null frame can
still flip the AP's PS state anyway, so the AP-side change is best
treated as a spec-compliance cleanup.

You were also right to suspect the client-side TIM path in
ieee80211_rx_mgmt_beacon(), when (dynamic_ps_timeout == 0) (for instance,
when power-save is disabled on the client interface) and IEEE80211_CONF_PS
is not set, mac80211 currently ignores its AID bit in the TIM and never
sends a wake nullfunc frame to flush the AP's buffered frames.

If you're happy for me to do so, I'll send the following 2-patch v3 series:

 1. Symmetric PM-bit handling in ieee80211_rx_h_sta_process() (only
    consulting the PM bit on data and bufferable management frames, while
    waking sleeping stations on Auth / (Re)AssocReq as-per 9fef65443388).

 2. Sending a wake nullfunc in ieee80211_rx_mgmt_beacon() when the TIM
    indicates buffered unicast traffic while IEEE80211_CONF_PS is not set.

Does this help or hinder?  Your call.  If you decline, I'll go ahead and
close out our internal (Android) report as `Won't Fix` and move on to
something else.

Thanks.

-- 
Lee Jones
