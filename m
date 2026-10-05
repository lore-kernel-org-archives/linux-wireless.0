Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F39648A8A7
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791207483; cv=none; b=XenHv3Z6cQrWdOMFdog1mAze65uvEMRqzxkBIxOABEkEWVqYelbLbdis79iak90xtBYObTGbze6VbaCQ64zd0lI10fKqndu/VRydAul4pOYCYPcr1IaEj7ybY1npuWKLHC5z4PpTl+gtPxiAUohtJsjRXfan7x/IDa5coeJs/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791207483; c=relaxed/simple;
	bh=tsD+72ay9wb71IdSpC4+FLmo/xPuApLQiydD4fzr+4c=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=At4LIdWc3w7y3qAuKoLXWxW5sJj7CVdzzaUugTcwHZsAYQwG0R9cfIGMjDXwqdsN/iZ7aU03NV4Cf0BHISKbLiz6fjyoGbwfv0RXcwOepvP5Yyza7euaJhoE/MJcqGqQgzZmDanV6iPfZqURZW+vWzkn7q0NX6Ks2xtcW+hjxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=m0cb+oXC; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="m0cb+oXC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xLHLFk09IuzogOuO46h6fzRe6mTFTm5HcTBtAtzLGoo=;
	t=1791207481; x=1792417081; b=m0cb+oXCCnnyxx0fdAuOwHRk5p4Epk/bkRS99zjZ78iU1zl
	Ee/6CvTGXcjZjxY8CEnKdIKo3O5aT3XVeFZCOh/1JrYGrkPQD4dhll/+KbW5C1mfx1aXB8K8ddhAH
	tXvptOsSvrZ1gIUOKlqpoiJR4ipJJZQiCOfuWLJWCc6RzDgds7A7VjhAKKYdRoxs+O3I9Be+GRVfv
	QSB9g5DqJG4RusJ4wMLk0Plj2uURZQEPzcxCh4vdo53byTC76Rjv8M5kwmva8syhdiQllVvOYYu49
	f1Jewy8jT8cCAyG8jXhnIyFn/3uZkxU5ccpvCqU8v1BCJrxsNhi45++pcoUfrqzw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDitC-00000005Lku-3Wdr;
	Mon, 05 Oct 2026 15:37:58 +0200
Message-ID: <ecbcbd4c91074e404aebb86bc709f8ff90f2f26a.camel@sipsolutions.net>
Subject: Re: pull-request: nxpwifi-next-20260929
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <chunfan.chen@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2026 15:37:58 +0200
In-Reply-To: <20260929103331.2797952-1-chunfan.chen@gmail.com> (sfid-20260929_123348_494205_E1BBD6F2)
References: <20260929103331.2797952-1-chunfan.chen@gmail.com>
	 (sfid-20260929_123348_494205_E1BBD6F2)
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

On Tue, 2026-09-29 at 18:33 +0800, Jeff Chen wrote:
>=20
>       wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()

Somehow that commit has a blank line between your Signed-off-by and
other tags, can you please redo that? I was half going to pull it
anyway, but it shouldn't be that much of an issue?

johannes
