Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A878D3932EE
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791273345; cv=none; b=c6dIbMjU6R5syoJFMqSJefQcmt8uTLZ8MOBTyoltXbnlMa8n3rOkNW4iBFC7x5LgODiiuebU9GVUwq+rGd1amwN34tVnwyQwUAFGi3tkEiAlLK/KcToMRE0OLddvgDgo7u0vd2OBr+lZd/eT/hZVOG3MdFaAGkTXg3e4TxLaRQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791273345; c=relaxed/simple;
	bh=/6VCxIoRLnavcfWlTZ/l3aFzZ4khwANHfmIrxFMbKJw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VE5OMFqA2rDxsCDe0gcihFWI8W3vbyoX+s+Smsf9j9Wms7x/P2sBOrGIkXuoGI6EokUauT3sZwNQWQX980T9xfpnKneH4MW6RKiqT64UxkUKUqM/IYVhvdLh6yCKQ2YTmE3EAD5as0lrk+lZid4bYT6ZWI8m7euN2rct6DiVLIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dWvdex17; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dWvdex17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/6VCxIoRLnavcfWlTZ/l3aFzZ4khwANHfmIrxFMbKJw=;
	t=1791273343; x=1792482943; b=dWvdex17D4hHNYo9WuFJoxHuZotmO3MFAaOvZEUfxl8JWxL
	9gE08NVKXwAjPHhMwUh306bFrBTiexymif4V7NLUpzS94j1onm4h2ge0WStZhQ4nCVtF/KSlk5kok
	srcNO9jLCAxU2lOBR6cG0AZOJFlydUl1AQwala1DSWoFC+bePgyeZjBjwzJzIP1a+CBKucHNyag8B
	HbBAEVzFqsjnuX/ayBuaW12RVQUJDUvVR8/D3CCi9XpcxOWAzd7WMLWvdupRYNLXoLPzUcC77mXaI
	FUqiW4h5Jr1ushLZrmv5T1vqBwwEKByu7RGr/IwtjbpcODCNgI/I7JblGiu21X5g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE01T-00000006Qha-1hDg;
	Tue, 06 Oct 2026 09:55:39 +0200
Message-ID: <52f1488ca882edc3901a7559dc4afee4fb8351e7.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 00/12] wifi: AP side locking improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
Date: Tue, 06 Oct 2026 09:55:38 +0200
In-Reply-To: <623f20912fee5ed614e3a884f54c116bb8f2944c.camel@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
		 <3db68884-f6b5-499c-9959-7eec59ba40cd@oss.qualcomm.com>
	 <623f20912fee5ed614e3a884f54c116bb8f2944c.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-10-06 at 09:14 +0200, Johannes Berg wrote:
> On Mon, 2026-10-05 at 19:05 -0700, Jeff Johnson wrote:
> > With both the redux and this series applied, I prompted my review agent=
:
> > prior to the 2 patchsets (18 patches and 12 patches) ath12k relied upon=
 the
> > wiphy mutex to serialize many of the mac80211 operations. are any ath12=
k
> > object references now subject to new race conditions with this entire s=
et of
> > 30 patches applied?
>=20
> :)
>=20
> > The reply:
> > <LLM>
> > New Race: ath12k_reg_notifier vs ath12k_mac_op_start/ath12k_mac_op_stop=
 on
> > ah->state
>=20
> That's a fair point,

Actually, I think it was wrong: ah->state is only used within the
NL80211_REGDOM_SET_BY_DRIVER block, which is already only called in
reg_process_self_managed_hint(), which already holds wiphy mutex. It
might be correct about ah->regd_updated in this case, but then it found
that was _already_ racy.

> but easy to resolve - we can just lock the wiphy in
> the loop of notify_self_managed_wiphys(). It already can't go away since
> we have cfg80211_mutex. Looking slightly deeper, we should guarantee
> that we hold the wiphy mutex for a bunch of these operations to the
> driver, and that needs more than a single line of code, but looks
> totally doable.

That's probably still desired so we have _any_ locking, but needs to
drop the wiphy mutex in ath12k and rtw89.

johannes
