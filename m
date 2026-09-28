Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730CB4DA9C8;
	Mon, 28 Sep 2026 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605479; cv=none; b=GysuMqHNMBeFnLonMoJw9jy6iavWcqNkrvDuHzR46LVnmSgyj1I2+/7AN4axEi9lhOwxWe/R451uNXClrLVoi6KIoXleTAYhcLEwt69rGuiGEdaNmp2ThQEy3UY/XrnbrIEHgLasF2/Wn1qI5m/jorF/MI1tTKP4kkpcwOyL9BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605479; c=relaxed/simple;
	bh=6hO0k1pgsw2vurDF0IHMdTPmWJmark3y3VgHYLvVF+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKzSKrfZxjfyHZDpcBqoX2HAE3kdsWOHTcb70A1CSWk3YBI+FWOYipw9LAAHiinNLLda821ixCaQ8pi5w6yynXrFENxxG3ENBApWTdVkw2/eJ0jG4YsE9WVM+UE3849DfKkKxX7ar5A1b++RbG8rwqv96dH3z8vVNoIRFmspKbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsY5mKi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsY5mKi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04521F000FF;
	Mon, 28 Sep 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790605478;
	bh=fXbrnW1fWsR72eYJ8bpmbgEXsg8SPc9tkZGjT0raZT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZsY5mKi0O2i5njNF+4luqOavNLmwMJkpa+LsT476fT7jMEIM+QAUV2RF5/OVVlcpx
	 2MXiYDcu3mi0kk33JfH5gOS137f6DHVh9iHJ+4QnN1NnxHrh6MJGHkNepeQF29V2fE
	 a/ktJRiwkFeLuBW4fJaKYAEW4fi9IvMtBZKU/6DPk1QsQsGU5W9aIJf/M/pdu2cthu
	 wEZsT0Yoi2E9i4BQ99Lr/UxQP2Vj/hJejPcjbxmoZU+79CtPIv9nNMfDcvOQTmsynm
	 T3B/cM4hDlP//mj88ekzWgVo23C5FyWItaV6Qy+AAJ+exxxPx6knI6oPSgYCQVDbYi
	 hiNXtW46WcXkw==
Date: Mon, 28 Sep 2026 15:24:34 +0100
From: Lee Jones <lee@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
Message-ID: <20260928142434.GA2112133@google.com>
References: <20260928100508.3487525-1-lee@kernel.org>
 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>

On Mon, 28 Sep 2026, Johannes Berg wrote:

> On Mon, 2026-09-28 at 10:05 +0000, Lee Jones wrote:
> > Per IEEE 802.11, the Power Management subfield in the Frame Control
> > field is reserved in non-bufferable management frames (such as
> > Authentication, Association Request, and Reassociation Request) and a
> > station remains in Active mode during authentication and association.
> > 
> > When commit 9fef65443388 ("mac80211: always update the PM state of a
> > peer on MGMT / DATA frames") allowed non-bufferable management frames
> > to update peer power-save state so that re-authenticating stations
> > could transition from doze to awake (sta_ps_end()), it also allowed
> > non-bufferable management frames with the Power Management bit set to
> > transition an awake station into power-save mode (sta_ps_start()).
> > 
> > Restrict wake-to-doze transitions (sta_ps_start()) in
> > ieee80211_rx_h_sta_process() to data, action, disassociation, and
> > deauthentication frames using hdr->frame_control (avoiding inspecting
> > encrypted action frame payloads prior to ieee80211_rx_h_decrypt()) while
> > preserving doze-to-wake transitions (sta_ps_end()).
> > 
> 
> This doesn't make sense to me - you don't really say why you're making
> this change other than saying what the spec says, but then you're
> explicitly not spec compliant both ways - without any explanation either
> way?

Fair point, sorry for that.

The commit message was purposely vague due to the fact that the change
fixes a security issue and I didn't want to publish a HOWTO guide for
exploiting it.  However, I obviously overdid it a little and left out
the reasoning you'd need to review the patch.  The short version is that
an unauthenticated peer can currently change an associated station's
power save state with frames that shouldn't be able to have that
capability which can be used against the station.

Happy to send you the details off-list.

Plans for v2 with your blessing:

 - Rewrite the commit message to explain the problem and the reasoning
   properly, rather than just quoting the spec.

 - Make the PM handling consistent in both directions, so it doesn't
   honour the bit in one case and ignore it in the other, while keeping
   the re-authenticating station case from 9fef65443388 working.

Does that work for you?


-- 
Lee Jones
