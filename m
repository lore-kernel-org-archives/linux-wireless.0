Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B73A48F7
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507364; cv=none; b=U2o9uFgfHTdn8++mLkCqzDF6lzUcsTl6ZeDEBI3YJQTHsHmZIt8xqnZdiekT0Mp0ufO6qKPGfUq3MzYtU38DFLAIitV1KYCwV6+NyTScR1YKAJ/WWX/X4cYjrdMpAoyuKMvtEPQ9fRibRwHkdMmLZZCB7YtTQxKnSkoYKsOMYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507364; c=relaxed/simple;
	bh=9BmdIQOXzcZzIhJ6OxYyzRvCgAum9ek2MaBmEeYMRYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYuBsZqXoqQHyM32Nbm5a7E+F/zKuIx+E/yDxeKEedgS+B1UvOW93I2RSV5hKVNLKiX/LSul0EfYof3U/kAAMyMu/dj3r5KmNzv3CbyiQo6ljQEVwk+0xVhDQxoWsBl3sxfpkEx9G3rPqr6UvwP58UCh0SgcTPvr675d1Jv4Dus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=F+vb7NOL; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="F+vb7NOL"
Received: (wp-smtpd smtp.wp.pl 9849 invoked from network); 4 Sep 2026 09:29:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1788506956; bh=pXZi44vTEGgPV6aGYuUGoiM66gCNBhbOFDok4gwgmH4=;
          h=From:To:Cc:Subject;
          b=F+vb7NOL/LpdKYnXADgzCQbxmuB4H0gs1w3VwQwzs99yvUDzf/FwybnTuysDDLha7
           ikrNokBfUJ+bYiNrvxUDfLpGNubyurY/uikKjQaqR32ViI71VtnEuGdjSWgFTV0ahM
           uVWvLpu71Noyg4W0Zc6o+I83jzbi/BDoyKqPJLbkYu4uaEfRm9AyNkRR9mGAfDQm5O
           QvfpGAATip7yWBQ5uUa18cvq6j3V1HBP3EgZeChGiy6/kqNo/FOYSftQgCEC4HLvhl
           RYGnE2kfM1J3iQJR5tQ+dvD/sJQcp9VtFi8MaOManx9Ifht3YwUEiSVGyQk4Vzd9gS
           9v1r9tc+Hcg0A==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johannes@sipsolutions.net>; 4 Sep 2026 09:29:16 +0200
Date: Fri, 4 Sep 2026 09:29:15 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: queue frames while off-channel
Message-ID: <20260904072915.GA41290@wp.pl>
References: <20260820131217.21824-1-stf_xl@wp.pl>
 <2476da0c8b837dba5750f7a556d9bac2387a9c59.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2476da0c8b837dba5750f7a556d9bac2387a9c59.camel@sipsolutions.net>
X-WP-MailID: fb1a43119bde8ad007de71e1487c6112
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0RPx]                               

On Fri, Sep 04, 2026 at 08:56:13AM +0200, Johannes Berg wrote:
> On Thu, 2026-08-20 at 15:12 +0200, Stanislaw Gruszka wrote:
> > 
> > The change depends on the iTXQ resumption handling introduced by
> > commit 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
> > and the wake_tx_queue support introduced by
> > commit a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to drivers"),
> > so use those in 'Fixes' tag.
> 
> That doesn't really make any sense, IMHO.
Going to drop those 'Fixes:' tags and comment. but I don't know
what the tag should be then.
I saw in docs that 'Fixes:' is required for -stable submissions
for net tree, but maybe I could just skip it for mac80211?

> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -267,20 +267,14 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
> >  }
> >  
> >  static ieee80211_tx_result debug_noinline
> > -ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
> > +ieee80211_tx_h_check_offchannel(struct ieee80211_tx_data *tx)
> 
> I (vaguely?) had these ordered by execution order, might make sense to
> move around and try to keep that.
Ok, will move.

> >  {
> > -
> >  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> > -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
> > -	bool assoc = false;
> > -
> > -	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
> > -		return TX_CONTINUE;
> 
> 
> Not sure you should remove that, still you want injection to go out?
> 
> Not sure injection should even be queued - maybe you do want to send
> while scanning on a random channel? Or maybe not? Maybe someone depends
> on that behaviour? Or maybe not? Kinda hard to say...
I will keep it v2, change indeed could cause regression for someone.

Regards
Stanislaw
