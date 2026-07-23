Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEC047127D;
	Thu, 23 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818569; cv=none; b=r7W18sH7irp9xKGzxgJcgPdxp8C+dmzF0r+TImwfBbRvlrFZoGVAg+8FIa60Z7/DdfGlb3BmfpZyxxEqMJNVpemABQbn427JeJI6n4bUVVwD2HOUji67CFJ4wHQZe6umEqYozZEHkGvloXHUODVRLtgi85hX+RdoyexgdLeQCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818569; c=relaxed/simple;
	bh=/LHb9PbjJ/W28XoMgVzt3faPlUPkc8xEtyV0gyh8X2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4bCVW9NnMH+8Ls2X1K+Wj/RFHd7X8aYbSvgDCA13MFxib8WEKcFb9oPGNGYP5UKtaOWxca4E4zNb6UgS3+y/7pjpKVhd/ZkqO/sL2SCyUSuWT61ZVvKdM2YVTlLV1U0WtSO3y+HbJqRdtBzPs/AuJozdnF5WBKJbhc03xPyBjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ofqJ8Jdc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ofqJ8Jdc"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 23EB51FCC4;
	Thu, 23 Jul 2026 16:55:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784818559;
	bh=v0CAf/eb/QKfGldUDL9kacxXaRwcPuGwyKPcibiP6BE=; h=From:To:Subject;
	b=ofqJ8Jdca7VuP4g2uN9Jp7eHl0z+aZT8YWlBFJsGg5K6AHBPGjRhU8O2gjtb4TWwD
	 +Hl3SVglaSzWOWylA+Ztyalq+SkrpQfjkchNgV6brpgxCeIatm5yaLwb1E4TVAqtbA
	 H37EWqu4vvPGPGtw0KGwBQRFaSOHDkVYrcdW9GHHN1NSFc/2xkN5YQ51NekJY0AvTV
	 RQdU9mtOPecAPagnU19Tx/u2IkY6Dvjj3dkPFY5Xp7RJFNxg7DVMReCOLZS/Ov/cdv
	 tOON8NG9ajEXYHqH47GuCbOm4UmTkcCZBoWOjowFOeml/SRCOPGPpxtinbz94Fk9Tq
	 dYM8sVflhnvBw==
Date: Thu, 23 Jul 2026 16:55:55 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other  areas):Keyword:\\b__counted_by(_le|_be|_ptr)?\\b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: mwifiex: Use flexible array for RX
 reorder table
Message-ID: <20260723145555.GA238048@francesco-nb>
References: <20260518211826.11245-1-rosenp@gmail.com>
 <1e77da9180ee82bf1b0d122f0ddf137949d4278e.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e77da9180ee82bf1b0d122f0ddf137949d4278e.camel@sipsolutions.net>

Hello Johannes,

On Tue, May 19, 2026 at 08:47:00AM +0200, Johannes Berg wrote:
> On Mon, 2026-05-18 at 14:18 -0700, Rosen Penev wrote:
> > Embed the RX reorder pointer array in struct mwifiex_rx_reorder_tbl
> > instead of allocating it separately.
> 
> Others might disagree, but personally, I think you should stop doing
> this. Sure, it *might* (I've been bitten too much by __counted_by) be a
> border-line improvement, but it's not _really_ all that useful,
> especially on these older drivers.
> 
> Did you even test it at all?
> 
...
> If you _really_ want to help, please help review changes rather than
> producing more noise. Maybe even take over maintenance of some specific
> driver that you can test.

I also do not see any specific reason to take this, as of now I have not
enough brain cycles available to properly review this, and if this is
not even tested we should just reject it.

Francesco

