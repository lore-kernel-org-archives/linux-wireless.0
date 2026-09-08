Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A0230E0F8
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874575; cv=none; b=kjo7ovFNHeqspXfUIqaogwIaSIAMQ8VKe6OCQMfd3grPgXEGmK/UN6a4oVE/MpWkhgilWdrRSvInjO7hCy0PRqPqhoaBUx9IStrWyLv/o2YG9OU9p9Wf3kXe40Zd7sFEo5CfU07WwVJI5vha4bG0qF+6kasllEOVdArRhtPFJq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874575; c=relaxed/simple;
	bh=d91FVQPyCh+jTIQ3aXYMVCYEU0FdnfxhA9uDRZlyrrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEtR8zJGbjv2o7krv0MbUtXUejRZXWGrq3dl4L09qIpCgKDbE2gdg63yJ02dDMxpUJ6MjKBmJCqdmNdzK/wO6GpMnEMSyYgv1I7p2w0NFf0fR5xkB3dc/I/6YhE0wiQl+sIUKsm85uN/hzV9P3ptC4to3J4evtKX8TMOFXYaPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=inVXEMS0; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="inVXEMS0"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue,  8 Sep 2026 15:36:00 +0200 (CEST)
Date: Tue, 8 Sep 2026 15:35:57 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
Message-ID: <aqAPPd4qHy0qjo1k@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
 <20260813090434.2071318-3-sst@poczta.fm>
 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
 <ap_Y8OD0eBAnB8QS@nr200>
 <8934029f86b1c0e75f777185b2768f8e9755cae5.camel@sipsolutions.net>
 <ap_4hS6M8g4u6z--@nr200>
 <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1788874561; bh=lBw5ksq4+FXFhNeSk6hQ2VvNAC5I5/HvJUHhLvQbRj8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=inVXEMS0hcw+yJKwxoTfO1rQ+W2WJgBfZTMu+6P33MSr+KlNzJz/dOtk+SIMZONld
	 6Q0cD7w/ON+PMQlGkEVm2tsqKRSDJ5p3wqvTwyYcbX+93wdPRTEtMmhF5cf8EPqK/T
	 qre2ivN3dxznyx91Y2MmVUihbWNUoCIT8TXtivgE=

On wrz 08, 2026 14:25, Johannes Berg wrote:
> On Tue, 2026-09-08 at 13:59 +0200, Slawomir Stepien wrote:
> > > 
> > > Don't think you're missing anything, there's just the block handling
> > > param->vlan in add_station, it's dead code now. But why not kill it?
> > 
> > For the reason explained below (in my previous message).
> > There can still be a command from userspace with AP base interface (as wdev) with
> > attrs[NL80211_ATTR_STA_VLAN] set and this block will be executed in such case. Right?
> 
> D'oh. Going too fast, I somehow managed to not connect the two things.
> Sorry!
> 
> But it's another messy code path - if you have AP A and B, and VLANs A'
> and B' belonging to A and B respectively, then you can
> 
> 	add_station(A, vlan=B')
> 
> and it gets added on B/B', and B must be IFF_UP (because B' must be
> IFF_UP) but doesn't need to be beaconing and we're back to the bug, it
> seems? Maybe I'm missing something.

You can't add a vlan interface that dosn't have correct "parent" wiphy, get_vlan() checks that
already:

	v = dev_get_by_index(genl_info_net(info), nla_get_u32(vlanattr));
	if (!v)
		return ERR_PTR(-ENODEV);

	if (!v->ieee80211_ptr || v->ieee80211_ptr->wiphy != &rdev->wiphy) {
		ret = -EINVAL;
		goto error;
	}

> Since VLANs have to have the same local address as their AP (i.e. we
> need addr(B') == addr(B)), I guess get_vlan() could check this though,
> if it's indeed a problem, and that would avoid it through the chain of
> other invariants (IFF_UP, beaconing, etc.)

This check I've pasted should be good enough, right?

-- 
Slawomir Stepien
