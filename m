Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684546D560
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225384; cv=none; b=DTyAvdPE8uhKfnRbfKCwV5vWyG+0JWS2TNSMLYB/oNXVl5q5Zxxee6BiNmtMo+TWvGh9f3yyEy/6M2wvB6YVE2FtEvTJ23blXxVTN9v+P0wPN081jTMBTcZKa/g8rDEwnDFGB8OfVSmzOX0DGA+31T4G5sf8dquFzvzew6MUKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225384; c=relaxed/simple;
	bh=Rf4qCbZoQHGPChFcewnsd8ooJvTFn3nmrtPhMuawCWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9EvSqka7OhpB3N8dck5FmY1Ar4Vn6RKyfWVCrogtK90GjjLtc3i77Kj+dYVC3Qp40i6FtuFvNhkVJ9HamvPx7SNHKC75B6CcnK/VZYANQvAqFhVxn9DmNVgNOLxgh+oENdGw7JZ47tOOBqk//ugFsrdOU8WCTTL9U0KAq8zPrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=YAeFXn3A; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YAeFXn3A"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-34bb8b31647so3432000eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 11:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791225381; x=1791830181; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LG/1ygDLMu07afoR/u2Nzu+nNQTEaKdwzisUSGQg8tE=;
        b=YAeFXn3ASXoJ7SrbbzIowqutW4+MAnDBLDJP71pAJ1ZjE2Lrh9lCO1MVPm2AdpVF5N
         qMMFqgBdNDkSf7SO5ds9Ei/DQagKDWYEZbyf9lnlWkCWJcjcynuGGdphLFOXE8FnWJyY
         3RqyfN2VVtI+3A+dLFRzuokBrtxoQPR1hobbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791225381; x=1791830181;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LG/1ygDLMu07afoR/u2Nzu+nNQTEaKdwzisUSGQg8tE=;
        b=b9Yzk87yvi57K6fZmoaM470LfsOqxM5p5y6yPRqD4XEVG93lySmWJpZyNSwwdJbAHb
         mZN+OBu5tqLMMiwIfcGHLkfPxjTbui9YbfLLRuoyHKB+U0TOXVnBZLDHQriu2krKKV+z
         nH0tFonIAC6WwrTIQQQUUbp0tWoCcCYJbLt3hrCD6JO/xVKcKmNdBczz2PeOT1I3SY2E
         P3mEYtuAaW6Xe0wqV/2AFj7JTbs6pJ9MFf78hblUuaC932F0qd9Ycek9aCx2GqVmP5wE
         GHvMuQjY0sPimOg67sL9LRXPK3fobYOJsV19n2FCKDZyJrShV3jJ22cZbyRAZMsMeJW4
         wFog==
X-Gm-Message-State: AFuF++m0mpIZgoNv4ZzhxF6SqcKGBQvA68Lml00KOcmM1g7CNUphpTPF
	z+lcoQq5RTdg+VG303uy1d49Zs+VhKSINQAxlPxmKnKyDlBRC6zFLy9coG8Sw8a8BQ==
X-Gm-Gg: AYBFou0K4cF/txNroeA+9C0v0O8DCZJ3cLhxFhqCBrFNN721VLDjzGnJDEU+IxpHOY0
	m2Z0vJxx7NdKXxhqLa6J45vwUqysj1p4+/v3tJVDQDNKHewmvdiDUtQUSZ+ujV7lY03MAr7OMLG
	owQKhg4otOmvOO+EIjeCUMXi7i7b68qfKk3QrbYBFtQ1dx4Qo2X4uDJLMoPjPLhjztQ+FQ+Qpnb
	4JMxIMCHqUTSUdzhXaerNjrFsLv9MgTdVTAscdi18NIiqAyHwos1bcJhV4zckfGV7+migp9ZlUL
	fxwaFZqi+P1xIaIPLK97/KuKsPQ4hcOLaTy0uZYcDlp3ObbVfeb/GWg0j7dwHi/eFqhvsbVFL41
	QlMsp9qaI6DxeET5+Ff3gV9pLiXxZ3G4pyieoo3h2LGbvKvKVlNsKbhdadcvnsNDQOJgHJpqEeh
	Q2SQD8vmZ8y4A0vus2xYbSKzhUMtzAJYuw+jAi9mlSPnDOzK8W5VfNt6SR5g/zu67XApo2PQxI6
	dyOudld/Ld7hbXrPCNta3ay7OpkcgCSYv3sV4M5Zzq2Kpc=
X-Received: by 2002:a05:7300:d405:b0:33c:259a:759 with SMTP id 5a478bee46e88-3511153bb6dmr12168863eec.36.1791225381049;
        Mon, 05 Oct 2026 11:36:21 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:3452:be62:94e:a46d])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-351469f75fesm175515eec.5.2026.10.05.11.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 11:36:19 -0700 (PDT)
Date: Mon, 5 Oct 2026 11:36:18 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Francesco Dolcini <francesco@dolcini.it>
Subject: Re: [PATCH wireless-next v2 09/18] wifi: cfg80211: document wiphy
 mutex for radar/CAC events
Message-ID: <asPuIvquaejUkaLE@google.com>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
 <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
 <asPiiI6-JpMd3vKr@google.com>
 <c5990e315e83eb6014d6ab02f9846a9d10a901f8.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5990e315e83eb6014d6ab02f9846a9d10a901f8.camel@sipsolutions.net>

On Mon, Oct 05, 2026 at 07:52:11PM +0200, Johannes Berg wrote:
> Woah, thanks for looking through this! :-)

Ha, well sometimes I read stuff with the "mwifiex" keyword in it :)

> On Mon, 2026-10-05 at 10:46 -0700, Brian Norris wrote:
> > > The DFS state of channels and the CAC state of the wdev is
> > > protected by the wiphy mutex, so the radar and CAC events
> > > must be reported by drivers with the wiphy mutex held. In
> > > mac80211 we do this, but some drivers don't yet:
> > >  - mwifiex/nxpwifi have an event handling worker,
> > 
> > FWIW, one of the two contexts that call cfg80211_cac_event() in mwifiex
> > does *not* (by inspection) seem to hold this. 
> 
> Yeah I know - that's why I wrote "some drivers __don't__ yet".
> 
> It's always been broken though, and I kinda just wanted to move on. It's
> racy, but I think mostly wrt. the valid_links warning (which isn't
> relevant here) and the data accesses, nothing worse will happen.

OK.

> > Is this something you'd
> > prefer individual driver users/maintainers resolve?
> 
> I think so. Or we can discuss it should be async in cfg80211, or an
> async version? I guess first we should discuss how to solve it either
> way, and look at all the drivers that still have the issue.

At first, I thought it'd be trivial to just throw in
wiphy_lock()/unlock() in 1 or 2 places, similar to commit 0d7c2194f17c
("wifi: mwifiex: add missing locking for cfg80211 calls"). But I'm not
sure that's actually sound -- it might introduce some locking inversion
problems, where (for example) mwifiex_del_virtual_intf() expects to be
able to flush/destroy these workers, but it's already holding the wiphy
mutex.

(I wonder if commit 0d7c2194f17c is similarly unsound.)

Either I'm missing something (quite possible), or it'll take a little
more thought on what the right solution should be.

Anyway, I'm fine with your approach of document first, fix later. It's
hard to move anything if you have to reason through every crazy /
lightly-maintained driver for every problem.

> > >  void cfg80211_cac_event(struct net_device *netdev,
> > >  			const struct cfg80211_chan_def *chandef,
> > 
> > Should we add an assert to this API?
> > 
> > 	lockdep_assert_wiphy(wiphy);
> 
> Well I figured if I do that now then tools (and perhaps people) will
> start complaining and that'd just put more pressure on everyone to fix
> it ... that's why I didn't yet, but I guess I should've outlined that
> better in the commit message (even after a --- marker).

Ack.

Brian
