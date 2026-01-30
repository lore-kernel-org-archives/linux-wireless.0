Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6821257F;
	Fri, 30 Jan 2026 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769779512; cv=none; b=FFBwX1ChFpAxNl0E+aBSYJ/wdLTYWhU1Z5qe8KMbzmJuthcvIPvu59V7Ak1lKptSLV4HRxHJTpEmf31h56PYrUUu2J0evI/XkbKaL2aNuVJHYTLLZCxtjBViqsGKCLBH/ZhIiqXBwur2skLOmCf+fQS0GavYZDY6dciH/tWc0fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769779512; c=relaxed/simple;
	bh=yrEC2sikfBDxUvHlMbdY9HPnWSEjsThkF+Y9aZMdYNY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FtaXnHLxQaEVdRVBkbweY8fZkt9l75VXk55C+Gq+e6BALuB0maNda783VjxdIQTj/DmJ7CuWgsnmeCsNNi7g/HdplwQAecvCBdQ3oNgqXU5YXO/j0S0LQIr5mdrXYb/4rAQlfKptg/k50d9EBumRKHl8eW0N6FTbNtKaC8SqxAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Fr883NZ1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Fr883NZ1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yrEC2sikfBDxUvHlMbdY9HPnWSEjsThkF+Y9aZMdYNY=;
	t=1769779511; x=1770989111; b=Fr883NZ1mYOEzy+tkSDufM948lugGbxsbIOUHT8yphw/Amd
	PDOsgoOvYaU7G8ctVryRtvb2KGzUxoD38wfoQ/u1MpXDmG9x2bqY53B0h98DPvMp/h+/axRF9C6dK
	KpUY5oG8fICHa8kVFTbfmQd+AY09fPq3K0fqhLOm3ypYb6yf6bjyEquWXWpDZU0LyQvPYBzipoJHS
	aXtleOPwxQLe02a94BymhFKzUT0PCo9hpKgyp0V0Z1px6SSRiMO4FqApknmDEoErKxQpxfabjAwlR
	xDvXxKXoKYixXgvt/YsN+/j2VEAQh+7m74K5YKlTiANu0aDDqr/D5VZL5Y8SNHMQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vloUk-00000007t1Y-3pME;
	Fri, 30 Jan 2026 14:25:07 +0100
Message-ID: <d8026b7f005a4d20562983e344d70d3d6f72d82a.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: ath9k: add range check for epid in
 htc_issue_send()
From: Johannes Berg <johannes@sipsolutions.net>
To: Aleksandr Nesterenko <alexandernesterenko837@gmail.com>, 
	jeff.johnson@oss.qualcomm.com, davem@davemloft.net, kuba@kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 30 Jan 2026 14:25:05 +0100
In-Reply-To: <20260130125915.47036-1-alexandernesterenko837@gmail.com>
References: <20260130125915.47036-1-alexandernesterenko837@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-01-30 at 13:59 +0100, Aleksandr Nesterenko wrote:
>=20
> While htc_connect_service() now validates the endpoint ID before storing
> it, htc_issue_send() can still receive invalid epid values from callers
> such as htc_send() and htc_send_epid().

I'm not convinced, what makes you think so?

Arguably, even the prior fix was somewhat confusing, because it used the
ENDPOINT_MAX value as an indicator that the response wasn't success,
could have checked that more explicitly.

(And why did you send the same thing three times in 6 minutes?!)

johannes
