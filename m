Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490096;
	b=UAkGTFp6EB0daddMe7pBgqkBXnSyBWzhTKmHxG8QPgBKlzET/+m516eO8uOcRgvEEbdk
	 g6q3PjpBYOfyLYLcAwBb32VEm/Frz8HoFe4JdK/e4PK4lTULD8rI6T78F0w857U+rI/qU
	 0LTFYc5k+bTZteoJsyTs4RhZ48kaB5nSWAUUw8YSO21jLnPEwt8UXPa8B1SSVO2FMG23v
	 bvmBKDpuYqRzTMRODL+Bg8mvpf0BVCalOSSdqRTPmUyBrSXKepWJsr6T0mC+L88yrK1aq
	 OeC66PPf/OYuHK2YgVgPH1iNoGHmOXS9xUxyGVSM+K8k+Rjyzyi4iiL1IK8oFP6Ll6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490096;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=dDSPmAeSz6brBNu8fQ7IOQc9bc9W3mTNan1N4VkyxOs=;
	b=G3d5kcdvQOgVxSD1yvkapEtxzWT6nVeW5Zv1hcc8DwsiqQBTdLGP6kop0LCJR36+DtyP
	 02Jrtq+5L7z364AvzO+zCvf7CQneb5c2wZNmkE9rpRVunaWD0G8wkyN2SHKRJ+DHHaTv/
	 YlRf0op2NmMHak2bZVXfjZfZ9p7G22ktGEQYUB8V2pjk/Yq+9lGiamDBkiIVfZ7Qoizpo
	 pCgwnM4bfG0snHZyrHWolzQXAAImM9L3WaWdMTT/Hy4h9GWq58iZnLXtNbBHEMgBn4nH3
	 1ydtGherVI37mU16oDizGlh6bEzkO84e8v9sV2AvcGbN9BJucxq+7X4umnuub6o9mog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z80g66Ps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2E8606A31B;
	Tue, 20 Oct 2026 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z80g66Ps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1011A1F000C4;
	Tue, 20 Oct 2026 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490095;
	bh=dDSPmAeSz6brBNu8fQ7IOQc9bc9W3mTNan1N4VkyxOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z80g66Ps5QuE8en45kpCqDQbsP46vvka9IxSMgXC47/w7Zu1H/Oz7oaTquJbQ+/tW
	 toGnNIgprhqk3Y2C2YnQFxiTRZFPPT6FBsZCKvNCfspOKPKAA1yE8JYXXQkc1S23Cs
	 5Kcw2e/lGDsccb4HUd21Vhh+cd6nXlXT1uDwooPhhDVRC4z/XtsZhaduDxSDkwwxkN
	 g/kRyEXdr2shHIPFeJpWOkjzixToGm/Fkp18g1qPF/USQTwAMHIHtKt3105faJNfIp
	 WjHCtHAsIgXTakecPs7wjChN6eP3Neopkgcq7Pw1VCNIqrfYmO1xmfwmIPwgWuKz25
	 Byw1QqdFGBKhA==
Date: Tue, 20 Oct 2026 10:54:51 +0100
From: Lee Jones <lee@kernel.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
Message-ID: <20261020095451.GE1206986@google.com>
References: <20260928100508.3487525-1-lee@kernel.org>
 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
 <20260928142434.GA2112133@google.com>
 <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>
 <20261020065830.GA1206986@google.com>
 <591baf4f5983a2205550523a792681dad4b77b66.camel@sipsolutions.net>
 <cbf2c9297ab7ff1b2ef5fd98876e952fe5a52e7f.camel@intel.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cbf2c9297ab7ff1b2ef5fd98876e952fe5a52e7f.camel@intel.com>

On Tue, 20 Oct 2026, Grumbach, Emmanuel wrote:

> On Tue, 2026-10-20 at 09:42 +0200, Johannes Berg wrote:
> > On Tue, 2026-10-20 at 07:58 +0100, Lee Jones wrote:
> > > 
> > > You were also right to suspect the client-side TIM path in
> > > ieee80211_rx_mgmt_beacon(), when (dynamic_ps_timeout == 0) (for
> > > instance,
> > > when power-save is disabled on the client interface) and
> > > IEEE80211_CONF_PS
> > > is not set, mac80211 currently ignores its AID bit in the TIM and
> > > never
> > > sends a wake nullfunc frame to flush the AP's buffered frames.
> > > 
> > > If you're happy for me to do so, I'll send the following 2-patch v3
> > > series:
> > > 
> > >  1. Symmetric PM-bit handling in ieee80211_rx_h_sta_process() (only
> > >     consulting the PM bit on data and bufferable management frames,
> > > while
> > >     waking sleeping stations on Auth / (Re)AssocReq as-per
> > > 9fef65443388).
> > > 
> > >  2. Sending a wake nullfunc in ieee80211_rx_mgmt_beacon() when the
> > > TIM
> > >     indicates buffered unicast traffic while IEEE80211_CONF_PS is
> > > not set.
> > > 
> > > Does this help or hinder?  Your call.  If you decline, I'll go
> > > ahead and
> > > close out our internal (Android) report as `Won't Fix` and move on
> > > to
> > > something else.
> > 
> > I think what you do with your report is probably not my problem ;-)

Yeah, TMI, sorry! =:-)

> > IMHO adding the client side defence definitely makes sense, though in
> > many/most cases it'll be up to the firmware anyway.
> > 
> > I don't think I have a problem with the AP-side spec alignment, even
> > if
> > it's a touchy area, but depends how complex the code gets perhaps? I
> > don't think any client would rely on us not handling the PM bit in
> > those
> > frames, and they're supposed to set it to 0 (reserved) anyway, so I'm
> > not very worried about it. The patch was fine and I guess moving that
> > around to apply to both sides wouldn't really change it much? Want to
> > try?
> > 
> 
> FWIW: the firmware on Intel devices will send an NDP with PM=0 when we
> get a TIM bit set even if we are already awake. This is meant to re-
> sync the AP in case we are out of sync. So 2. makes sense to me.

Okay, let me follow-up.  Bear with.

-- 
Lee Jones
