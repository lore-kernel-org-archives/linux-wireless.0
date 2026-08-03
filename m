Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D736C5AE
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 10:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751324; cv=none; b=Va0MM98djcv9oAHuXo9jjEjXkPlLC+Guxnihu0WPQkoxnT5xbm5MGbF+AwuiMkZNXKA9oUNRBx0vPLL8aTVLFO/Ujn+y0XCBbrd2BTWXsZmg59iFiSJKVoGQ1mzrwJG1x9WCMm6kEw9DStlvsZfuYotdMz3vvBEasMLcaQiP+dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751324; c=relaxed/simple;
	bh=gfXCWvWx5d1eSW0PWb47Shqa6RilzchJzy2xmh7Up5w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cwUIv9OUWPnaVfeqI7KlaoHRafcgtR1O1WgSDPXxKk8GWRIVsMDWo2wAa5trLQddNOAV8OqSskVtbc+8qr9pz/aKzmHQIlNQfbRAABOf8Ma3aU8V5fDK5LEWHi/f2fKK/iAmixcX+km4ZbIcxGF3Fxw2HSoJr/cip1OXXYr1dcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DZp3zAL+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DZp3zAL+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gfXCWvWx5d1eSW0PWb47Shqa6RilzchJzy2xmh7Up5w=;
	t=1785751323; x=1786960923; b=DZp3zAL+wfO5d/WzVanm1pojTr5uGwJfsJig7opCzTx1noW
	zLQMYnQr3toc5oF0Y/Fj72a1Rycm7ZCRv+gohAw7Va72CRGgFzPKPAxNLyQ6bqEsJbGTAXN+izQUg
	jmD5ON6afDVYP2lF3HILZnWKf00UEB+FBGDTCpBgW1njEpJ35OsWUh2pWY57mWml/04/DjWhiNn9A
	hvuvnAJx4tVfTM1WJi/1q/eERTNY1Jbrit5dj5lRcZ1CRqmEAMyAyjmK2b69/rLcqAo3X06xl7OrH
	LbsJ4Ac27UbhMI1lafuzgck8pafZmA6sIqp4Vp4BxDiQ8w9c6pXliKnZ+HmPYJ9w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqpUd-000000088UN-335L;
	Mon, 03 Aug 2026 12:02:00 +0200
Message-ID: <a1fa50f9372f9a051d09fecdde5503996253f3d9.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 0/1] wifi: mac80211: keep paired old chanctx
 alive
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, vega@nebusec.ai
Date: Mon, 03 Aug 2026 12:01:58 +0200
In-Reply-To: <4cd5a1c8e807d064714a2f6fed46ea49d1033ace.camel@sipsolutions.net>
References: <cover.1785730815.git.zhilinz@nebusec.ai>
		 (sfid-20260803_063526_248734_4BF193C7) <4cd5a1c8e807d064714a2f6fed46ea49d1033ace.camel@sipsolutions.net>
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

On Mon, 2026-08-03 at 10:40 +0200, Johannes Berg wrote:
> Hi,
>=20
> FWIW, none of your mails seem to be reaching the mailing list - I have
> emails sent after yours on it, so I don't think it's just a delay.

User error, sorry. They did make it to the list, and are also in
patchwork.

(Maybe I really _need_ that vacation ...)

johannes
