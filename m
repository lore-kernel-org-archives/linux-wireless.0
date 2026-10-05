Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36EB37DE99
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791204264; cv=none; b=fHICByD6DBgKojqWbfQOorzM6oO2d36S+9VvdzSYBWzOCQROqlpSw56b8uX81iRYCgEKIR5rurOP8mKusGPNE0a5AV8SQq+JAHOeuXbpsBYIMuFlJD8T5wX/Nw/kq/04jUVjM/8Vx4VFBmttn0V8cQeYuOU2C9Qs+x94XxW7VoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791204264; c=relaxed/simple;
	bh=aQrg+MzWEb3JQcw0hzjC4IMHX4htf9QanQhV+BM5ED4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rbCBcDayVg7kkqTA3T1CNsV55SMqF5fSbegEUCX17mUdnNCOxw1TF71Mysnrd+Y15noiaKuDIVpGkS6SgpjQsH70RaoPoOhgtGvVccIwo0lCrXGsMjoSpt82Y+/9n4qf4WoTdJbouySHhzPkukA4UvkQMB0XACdrNXhPQ23LP3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=o+Hih0wL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="o+Hih0wL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=aQrg+MzWEb3JQcw0hzjC4IMHX4htf9QanQhV+BM5ED4=;
	t=1791204262; x=1792413862; b=o+Hih0wL3PrTTPCOGuXtvhteqgA7GK7vgiyhFt+A/SGUPqG
	pU5FZd89kmI0jSFp1hMq6g+MkkNUS6if9gCgys6ZxGmzLyYQjGs0znRsX9rK/UWYYbH1p9L3JG2a5
	jN5sOyYXOKpZVe37tZpsZSxfwsHVkLkGI5gg2FNbqcmV77eEugdD+VNlG6VeuMmf+OBeh4DGTee3S
	TtMAazy9Zzo3Y+YuogGY1X+KbCEyhgKYflQ0ZzBpWA2v0086mi9D3h5npwdHRkl8tDlZpoBuIWN9/
	oFvk2noDlhgLqrLvAYvtJu9LvjNU7Z+CO2EUB4TO4mneO1dxIDSGqr62qI+LmxfQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDi3I-00000005J7c-0KUp
	for linux-wireless@vger.kernel.org;
	Mon, 05 Oct 2026 14:44:20 +0200
Message-ID: <31185bc5614afbdb56ffd266f5e81941b45b3498.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 00/13] wifi: lock contention improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2026 14:44:19 +0200
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
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

On Mon, 2026-10-05 at 12:06 +0200, Johannes Berg wrote:
> As before, on top of the series I just sent:
> https://lore.kernel.org/linux-wireless/20261005100525.1991059-20-johannes=
@sipsolutions.net/
>=20
> The idea is the same: make some methods unlocked to avoid lock
> contention on the wiphy mutex, adding also a new "update beacon"
> method (but that needs driver opt-in, for iwlwifi that'd be ~40
> lines changed since it can send commands async).

Enabling this also for get/dump station isn't horrible either and might
help with those use cases Qualcomm has, but it does require another two
driver methods (if they have [link_]sta_statistics).

But who knows - feedback on this first please :)

johannes
