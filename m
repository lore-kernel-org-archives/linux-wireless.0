Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CB9BE63;
	Sun, 26 Jul 2026 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785085330; cv=none; b=Tu/FKOBMTn44d4uFmdNBtP5Koh01lyTtZWwnEzOTlLtFYU9TNpyoIfCAuPpvnJo0FpbPbpPLQsjmRcYBLVUYTqpdRjv8993JQc7EOM6fFnWTI1UkZrl0Ie5am/Z7ck0rDfbu0tXnbAvX39DeI8Kel351Zm/Bx+M4ZQfWIoeAtGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785085330; c=relaxed/simple;
	bh=H5ahAGUABcTvY/yUtF+jhkvA3wyRVDcr2FDZ0Ll09BM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UYdWtTjufVVfKsHVdDWXpvlTgi+hLp7XDOrUNK6pLMxyueKR0APkbjjBXdpez4KJfWo0aEhrIkHdCVhRclf/WJcSWTg+f6UGiMldKMr3IMx4+1u8DCsRIgOTblzfBaKtdhV9k9VpMDyxm9dpXNajDg7JmRLrHaAx3qZxWJUS6wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oD0wFeqB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oD0wFeqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=H5ahAGUABcTvY/yUtF+jhkvA3wyRVDcr2FDZ0Ll09BM=;
	t=1785085328; x=1786294928; b=oD0wFeqB/VA5A2ImN/HdPSaEbSdSnciN6L+0tQndMs1dWNf
	FudQGkpSssst7vdN5fm65+H/d9kG517/MQ9qTELZ0pnPWRPVousqDQov/6kOYUmQnM1Z3FR1rveBy
	aYTqtXhz7D/JW8+cTUA/6G917sIHBmBvB76rx+8GXqlzyPJGalSmeAvKhTJHCU2Ju08WwUh5uWR57
	wV/yvBty43H0Mzfyos9keyphC2pawZZDW1b5n4R+M2ZSyeQ9gN96pXedb/9U4GodEmzhXJ1HJK4A/
	ujHok3dgMOymTkyIG+MzN7HKzTzfUt/fn+OaC55hINTtKvT2Ua7pmPTvFayXNr9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wo2El-0000000Fk94-45cl;
	Sun, 26 Jul 2026 19:02:04 +0200
Message-ID: <56333069155a692ac1a363e84814494684e0c01d.camel@sipsolutions.net>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 origin tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Miri Korenblit
	 <miriam.rachel.korenblit@intel.com>, Pagadala Yesu Anjaneyulu
	 <pagadala.yesu.anjaneyulu@intel.com>
Date: Sun, 26 Jul 2026 19:02:02 +0200
In-Reply-To: <20260726164156.71624-1-enderaoelyther@gmail.com> (sfid-20260726_184208_981630_F422AA81)
References: 
	<b99e4a1428546030b61883063b9542dd953a69f2.camel@sipsolutions.net>
	 <20260726164156.71624-1-enderaoelyther@gmail.com>
	 (sfid-20260726_184208_981630_F422AA81)
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

On Mon, 2026-07-27 at 00:41 +0800, Zhao Li wrote:
>=20
> For the record, destroy_assoc_data already does both. Since f13e573ab3f12
> moved drv_mgd_complete_tx() into ieee80211_destroy_assoc_data(), that lab=
el
> notifies the driver before the link is torn down, then abandons. No
> additional path would be needed. The impact is negligible either way, so =
I
> agree it is not worth touching now.

D'oh. Now I even remember I asked Anji to do that... Oops.

Well, it's not merged yet, so I guess I can update my suggested merge
resolution and send a message...

johannes
