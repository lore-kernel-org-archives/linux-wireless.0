Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A8C52ED42
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788876571; cv=none; b=kGh/mPrXrUgzvMDsgozeDFOnGvivrkB8wZpmmVlU57+SZ0T1K2l30Jmyu2DBcAsscEzl+Lo/1ybZ7QrpmF76YxV3GCPVpuDFSTtvaNoYuueA1FpARk1haLibXyDenS9q+J7XIbMQDlrdZ1f03qKMoxZztunC1CtSfCZ3dY0qXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788876571; c=relaxed/simple;
	bh=f6cefW1iNeuWJbi6SCsNRCtKbgoCxvp7qEC++5yYsC4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HDnQmoV27WjJNjhFtPrQUYchhCkY24WNyXJUNdvI5hyuKSI2jydtsM48AVl2tqus65LaMcrlh2yNCN/i+w4OvIJlJu4N7FsRgf8E/q0jeUOzN9X1FJH+C4Z1+L1oI1Yf5qQywexn/2Ixm185dLUcdHkpF4l2ybvJ3iVXwIShrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oKXNjem6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oKXNjem6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f6cefW1iNeuWJbi6SCsNRCtKbgoCxvp7qEC++5yYsC4=;
	t=1788876558; x=1790086158; b=oKXNjem6jK4r1E/SxuuOYlvX/0n+0iv36X3Ib50HyHq2zj/
	o4mb2Qp9Fp7kFDf8Byp4rXftYiDOK8P2Wm5oKcoYpQndn8qFYT2J9ETAkOcvZUG3XzC38nRv47T8K
	ZXUHhXUg3Uyu++QrRugskpSlixgNN/wLq93JIIrLo/4xtlg4w+vN+g2zULFDrKUxZ5YDUVhcuKrNj
	O2LdffuJ88SH/q23Ue33iqC3cR+OyY2jCl5Yp12TDEU0ToiGhvxrBhnFOOyETi1vnlukCvCx6T/0D
	3gwGB6bBuAcT+StlnkjyxViBviiTWBcnTX6KiZ5mbqUT7gOvwKNt9sjUcaGo8esA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3wVX-00000006EAg-2THg;
	Tue, 08 Sep 2026 16:09:07 +0200
Message-ID: <702d4fd96837e42ac5d7491e3001ef6eae09b282.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: keep the TXQ scheduling round number
 across a closed round
From: Johannes Berg <johannes@sipsolutions.net>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: toke@toke.dk, nbd@nbd.name, linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2026 16:09:06 +0200
In-Reply-To: <20260908135224.754049-1-julius@bairaktaris.de> (sfid-20260908_155227_340708_827E0581)
References: <20260908135224.754049-1-julius@bairaktaris.de>
	 (sfid-20260908_155227_340708_827E0581)
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

On Tue, 2026-09-08 at 15:52 +0200, Julius Bairaktaris wrote:
> ieee80211_txq_schedule_start() sets local->schedule_round[ac] to 0 when
> the access category is over its airtime limit, so that
> ieee80211_next_txq() serves nothing until a round passes the check
> again. That round is then numbered 1. ieee80211_next_txq() ends a round
> when it reaches a txq whose schedule_round equals the current number,
> so a txq served in a round numbered 1 is skipped in the next round
> numbered 1 as well.
>=20
> Where the airtime queue limit binds, closed and open rounds alternate,
> so half of the rounds that could refill the queue return nothing.
>=20
> Track whether a round is open in its own flag and leave the round
> number alone. Checking the limit in ieee80211_next_txq() instead would
> walk the active list once per txq served rather than once per round.
>=20
> Measured on an IPQ8074 AP with ath11k advertising AQL through the
> series "wifi: ath11k: airtime queue limits, fairness and a driver TXQ
> scheduler", one 1x1 VHT80 station, BE aql_txq_limit 500/1000 us, 20 s
> runs, three interleaved runs per arm, the skipped selections counted
> where ieee80211_next_txq() ends the round. With a TCP download
> forwarded from a wired host, 4227, 4195 and 4268 selections are skipped
> per run without this change and 15, 24 and 41 with it, at 99 to 100
> Mbit/s either way: the network stack's arrivals start rounds often
> enough to cover the loss. With the download generated on the access
> point, where TCP small queues pace the arrivals, the skipped rounds are
> the ones that would have refilled the queue: 35.6, 44.4 and 42.8 Mbit/s
> without this change and 94.7, 94.6 and 95.0 with it.
>=20

For the record - one last time - since you keep writing everything with
an LLM I will keep dropping it unread.

johannes
