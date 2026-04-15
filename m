Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90EC54654
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776267777; cv=none; b=senmyLRLJOsBfTk6W4lzGYM84/EdSQspHOFStyt/lB2N93C1xj/KBoesAFmjNSCkNCfBIhMKPDBwA8ma6Qj2FfdgTagcLLsqpHwRWJP0MBjKE2LxOV2WjLEYpoWtW1pte2C7pie1OD66/JiNwP8ctscmuEYFsuf5L2YEGpdHVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776267777; c=relaxed/simple;
	bh=irTGmatTrTINJVCD4G9wJ1Ty5ok5Iw7O0G+YO5FwrJ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mifTdKnGZxnwUVSnb29AlrkBZXA6uIAbQJ1OIKUWdIj5/meeOeHzUuVtrIXSSgw+96pLRBDb+qEBjgif0tNSJ7L9xdzCw9UryJHQ241RAWun82wEOeHJy/cp8fLoO8SnNBAo2Yc+s4XPsEzZApb+IdT4k5bvEc2xKz045L7KSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FmwtUiDv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FmwtUiDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=irTGmatTrTINJVCD4G9wJ1Ty5ok5Iw7O0G+YO5FwrJ0=;
	t=1776267776; x=1777477376; b=FmwtUiDveg065jP+Yh3ruXcLikiEaqeVMXvotYgeo5k2Lcr
	2ouLL5+flxvuP+FbPD7EKw2xTkJw3dDg1Y+iEknPXrzwHKZY+qxZmpgYFLI3jjeHzmqb6+X5NXC6V
	GzVJzB/BdwqcxqvLa16NYEH82xRVPdJmZTjAqGmYT3Kb27j9cwWlDKWoCzlKAAkqiWzIOYXwpywz1
	OlL/MAiUF3tE2tjuAi+N5wI/tEq0PFC4aNbxe5eSRR0Eg9l/tbBEaUEKwIcgcErgYTA7XzLVmTNKF
	1QVyqzqNxMBXxl+nY+DaNlCQH/9WAJSUqI+xFglhtoM9ScJBtUly6+jUCQCbC8pw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wD2OE-00000006UYK-1eU8;
	Wed, 15 Apr 2026 17:42:54 +0200
Message-ID: <b5a0822b7ebf8e816e096e6a628db6b21fad40ef.camel@sipsolutions.net>
Subject: Re: [PATCH 17/20] wifi: cfg80211: provide HT/VHT operation for AP
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo MARTIN-GOMEZ <pmartin-gomez@freebox.fr>, 
	linux-wireless@vger.kernel.org
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Date: Wed, 15 Apr 2026 17:42:53 +0200
In-Reply-To: <ddfdac5d-602f-4f67-80bf-d41924b0b7e7@freebox.fr> (sfid-20260415_172238_311476_04A5EB08)
References: <20260415124514.284345-22-johannes@sipsolutions.net>
	 <20260415144514.32ad98454543.Ia9692671b699164edcc0bdaf4fdbdbefc50b18f8@changeid>
	 <ddfdac5d-602f-4f67-80bf-d41924b0b7e7@freebox.fr>
	 (sfid-20260415_172238_311476_04A5EB08)
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

On Wed, 2026-04-15 at 17:22 +0200, Pablo MARTIN-GOMEZ wrote:
>=20
> > + * @ht_oper: HT operation element (or %NULL if HT isn't enabled)
> Might be some nitpicking you can ignore, but HT operation element is opti=
onal when HT is enabled. With the current comment, someone might (wrongly) =
deduce that if `ht_oper` is NULL then HT is not enabled.
>=20

Not sure how you mean that, but not really? If the AP has HT then it
must have HT operation, otherwise the clients can't use it?

johannes
