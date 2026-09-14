Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C77D3DAAA8;
	Mon, 14 Sep 2026 06:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367252; cv=none; b=LJNeZAN8c57USEOUsUNUK/pOwnfVq36lwpsIIkiMTvyj1uEYUI/7mGFjvsrdtGBSKvYBxuygRDvYcKYg31WTUUTxy7+QJ5TfBbQHRpusAIzcaWbcl6xHab0ezRhxOabZP0iZBr9Mww36Ep4X6ZjS7/g/y+oajQPYgw/4Gx3/3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367252; c=relaxed/simple;
	bh=kQ1wLOrlNGgnoOESkNYswVmIUbQhPUbGTp00rdaU/q0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HE/RFwHuAVPBACUpBitEu8dxN0tZN5X2VXpE2+ughFKeA8QP5n4XCzHiEnOrfDh3aCvBGx4/2d31YuvJc6ewgK8B10obI/uXiyU6Ug4xBD0i4xMnYMcFN/EpMHtZlSQMePedQnEAbJO/n413qM1PVAqnjTxwrbhQH6Bajvg6mqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hpCsC+4Z; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hpCsC+4Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kQ1wLOrlNGgnoOESkNYswVmIUbQhPUbGTp00rdaU/q0=;
	t=1789367248; x=1790576848; b=hpCsC+4ZcURTs0yEGVl0Kb/K6lJJrPuzTd1CL4Z5Ol2K42c
	FkV3O6oUF0oB35rVrXBy4vfKzIJjIjqWg1RwK8pg0oWRtwlx9NJQDyzXUMf6dW/Xv3JdBlBlHRDDJ
	GQCHWtNd8uIrgefv39WUwc/CX7zOcUM++a+i6pF1D+tWfc5p+PjmHj/th4pBsQJMkDlVgolKr0S2f
	8Mgk1dtxEhTmOdJMQ6qApOW9L5dDTLnmmn/pcaMEop2Yf35QWyvWYAHYsPdiwzoTc/apLDH4Yx7C5
	ZaW/vtofNjDH9VbvSBQfIzoni+5Gr5pcxUhjC5i4LxNw04BbDxYlGI0OvGTMi6QA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x609u-0000000FGCz-0W3H;
	Mon, 14 Sep 2026 08:27:18 +0200
Message-ID: <9b3fd802df431355eb0784a79069e46a4e935e02.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: verify if AP_VLAN belongs to the
 correct AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 14 Sep 2026 08:27:17 +0200
In-Reply-To: <20260910080454.725913-1-sst@poczta.fm>
References: <20260910080454.725913-1-sst@poczta.fm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-09-10 at 10:04 +0200, Slawomir Stepien wrote:
> The get_vlan() only checks if NL80211_ATTR_STA_VLAN target is an
> AP/AP_VLAN/P2P_GO interface on the same wiphy. It has no notion of which
> specific AP a given AP_VLAN belongs to. Without a check in mac80211
> itself, NL80211_CMD_NEW_STATION and NL80211_CMD_SET_STATION could
> add/move a station onto an AP_VLAN interface that actually belongs to a
> different AP on the same wiphy.
>=20
> Reject the userspace request unless the VLAN interface's bss pointer
> matches the bss of the interface the station is being added to/belongs
> to.

Hmm. I thought I mentioned earlier that AP_VLAN belongs to AP whenever
their addresses are the same - doesn't that mean this validation can be
in cfg80211?

johannes
