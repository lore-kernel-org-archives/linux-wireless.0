Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577D42989BC
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776269156; cv=none; b=tl6X8Hvzi52BsCFHiDGxyVmkd2Quijk7b6IQwuvqF9luVxDNTJqRu+0pIH0WTzO+BuvdRSun8MwY1+Rn3lcdVohxMv9u/ZaV6cjEPpsK16qSYfRVUsZO9IeaZKexqUsLOmhm/sR+jM6LinwwPNjPNbspi4k5PjQOpQmMDxFeUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776269156; c=relaxed/simple;
	bh=iwN4wHTBsfLFKci0H7PA8rIYYv2bD9nTXgU0TIlgPRc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hG0t7cbK1Ftsa4ePHyW+6W3L9JBrYhE+2p5bL7dhvsJOFWUibuZVLyHIbintsMOHoiChTro8kdXF0wz5Mnoo7liIPRWj2JQwcMxogt7BlMlhhH2HzPRgstrQn4oULqG78yrFP98Hn0GtJ1+YusS/p8549LUbaCX/PV/pzKOADHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UH4c/yW9; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UH4c/yW9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nVCIhm+64kTSsrmLU18tTGq9u3NTD95uakO0tiD4c8Y=;
	t=1776269155; x=1777478755; b=UH4c/yW9G+z591UJT04MoBI94B6zUuXYkHK7/WzKxalfskR
	fpWxMexDHLs2f/QwPMtHrys3AXJ8MvcE5oZk2AtW/Z9KcO3+phv+LGPzbvMN3PVDU2Glug8hrkazu
	gMRv4e87uo6D4JaY1UKN+LkLN/L6xIXn0+bAi/A6cleVv1jxKrW+dSYLjFcb/Dy8rNWpieTouFsWX
	VoAj7n28ZxxppzvjuqPc66MQsiIEOQksJv5zySMwNNEHXq9IOqNq4dJcwLnGfIX3ZLTBb38Ce7c5s
	7PRcDd6wOXCWKWeaUT/OM8AYgV3DikpgnVorUyaP6lHTVVcZEl2YhuKcjpYsdUoA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wD2kR-00000006VIb-1jON;
	Wed, 15 Apr 2026 18:05:52 +0200
Message-ID: <9c77d6dfd7de1a54a3a454516af664a53bddd00b.camel@sipsolutions.net>
Subject: Re: [PATCH 17/20] wifi: cfg80211: provide HT/VHT operation for AP
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo MARTIN-GOMEZ <pmartin-gomez@freebox.fr>, 
	linux-wireless@vger.kernel.org
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Date: Wed, 15 Apr 2026 18:05:50 +0200
In-Reply-To: <5633ace2-45df-4ee6-a41f-831de3e90d60@freebox.fr> (sfid-20260415_180219_977065_1257F0CF)
References: <20260415124514.284345-22-johannes@sipsolutions.net>
	 <20260415144514.32ad98454543.Ia9692671b699164edcc0bdaf4fdbdbefc50b18f8@changeid>
	 <ddfdac5d-602f-4f67-80bf-d41924b0b7e7@freebox.fr>
	 <b5a0822b7ebf8e816e096e6a628db6b21fad40ef.camel@sipsolutions.net>
	 <5633ace2-45df-4ee6-a41f-831de3e90d60@freebox.fr>
	 (sfid-20260415_180219_977065_1257F0CF)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-04-15 at 18:02 +0200, Pablo MARTIN-GOMEZ wrote:
> On 15/04/2026 17:42, Johannes Berg wrote:
> > On Wed, 2026-04-15 at 17:22 +0200, Pablo MARTIN-GOMEZ wrote:
> > >=20
> > > > + * @ht_oper: HT operation element (or %NULL if HT isn't enabled)
> > > Might be some nitpicking you can ignore, but HT operation element is =
optional when HT is enabled. With the current comment, someone might (wrong=
ly) deduce that if `ht_oper` is NULL then HT is not enabled.
> > >=20
> >=20
> > Not sure how you mean that, but not really? If the AP has HT then it
> > must have HT operation, otherwise the clients can't use it?
> Oh my bad, you can ignore my comment. I wasn't sure if HT operation
> element was mandatory, so I quickly checked the standard and the wording
> of second table of 6.5.3.3.2 misled me in thinking it was optional ("The
> parameter is optionally present if dot11HighThroughputOptionImplemented
> is true; otherwise not present.")
>=20

Huh. I'm not sure what you're referring to (spec version is highly
relevant), but HT operation in a beacon frame, REVmf D2.0 says:

	The HT Operation element is included by an AP and a mesh STA
	when dot11HighThroughputOperationImplemented is true and the AP
	or mesh STA is not a STA 6G.

johannes
