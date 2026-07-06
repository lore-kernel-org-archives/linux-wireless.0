Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C246379C2F
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347958; cv=none; b=aCmxdDKp4jYEDYgGz2xfCbs2OJQ63aUQCGtlBrabGG/U3AQjV3ac6DqKfoSS9qdBLSu/Qm4EvrzcjWeERd4T9dhhRoRhWV7SwdSCfBzzO/oncOS1J5Wd/Q/iHJ7VErrceochyFk/+07L44t/iEwrwWakoTjx8LdG2OrxPWvQibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347958; c=relaxed/simple;
	bh=ZTgP4U9kkQh7SJIRlxN0gsuBrHAfZeW0661GMSxdiiQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dsbWNFDrurpx9tIM6eYCyLoGA/BycSxl4h297/t3B+jN+RRLolwO4+3Gcpb5o+QoHJXAZ7sd52+936Q5wxJf9iD7i443YVQIMnORRxscS5K3Xf3sOHXH5GC2GcIx3k2cu8p4Ib1cEp/MHuocx6GtnpqgwcOnWYIZoyyWq5pMXzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PsYc4QLe; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PsYc4QLe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZTgP4U9kkQh7SJIRlxN0gsuBrHAfZeW0661GMSxdiiQ=;
	t=1783347957; x=1784557557; b=PsYc4QLeTd+MV/q1e1LLfCt2cP94clZca066sFc382Hn27V
	F5umDRauOXkENScpMV/WyeAeUg/bKHAbmcj0Z9wakALUpzGSSJ4BmKNO05OPFOfaiUqt/IBmAgBlu
	5+IgGrugGehAmP3DnthY7SyFcv1zMk8W6lhSS+NS5og0PbkGGAWaVTFaCMUdN3jrSW0JdXWa/5Hdl
	32FwjZ/zZJzPt0tQepCxb+3ZJrCiOj2WoT7mLwhi0vCO8263jclAfec09/Z8FO6Qfe+B6qnSknLq3
	Uo6udO6eo+VPVDaKCfH1DNU5q22KPP/iP7iOiP/oGOiPwWjsMHftYhJsRsk03GFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wgkGf-0000000DTkQ-3p4k;
	Mon, 06 Jul 2026 16:25:54 +0200
Message-ID: <d27322fdce8adc2a947c3af1fd9ab31aa777ff62.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v3 00/33] wifi: mm81x: add mm81x driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: arien.judge@morsemicro.com, dan.callaghan@morsemicro.com, 
	ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, Andrew Pope	
 <andrew.pope@morsemicro.com>, Bassem Dawood <bassem@morsemicro.com>, Chetan
 Mistry <chetan.mistry@morsemicro.com>, James Herbert
 <james.herbert@morsemicro.com>, Sahand Maleki
 <sahand.maleki@morsemicro.com>, Simon Wadsworth <simon@morsemicro.com>
Date: Mon, 06 Jul 2026 16:25:52 +0200
In-Reply-To: <5nwjtflsihwo745k6cqi7lqsb5dblcb3fymw25y5hwcosxtfjj@y2szij6jmes2> (sfid-20260706_145024_902094_0F460D67)
References: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
	 <c48d02d04101e50ece0feab60fb04f63aef37140.camel@sipsolutions.net>
	 <5nwjtflsihwo745k6cqi7lqsb5dblcb3fymw25y5hwcosxtfjj@y2szij6jmes2>
	 (sfid-20260706_145024_902094_0F460D67)
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

On Mon, 2026-07-06 at 22:50 +1000, Lachlan Hodges wrote:
> On Mon, Jul 06, 2026 at 01:45:49PM +0200, Johannes Berg wrote:
> > On Fri, 2026-06-26 at 16:28 +1000, Lachlan Hodges wrote:
> > > This series adds the first Wi-Fi HaLow driver to support the Morse
> > > Micro mm81x chip family via USB and SDIO.
> >=20
> > I've applied the cfg80211 patches in this set, please send a pull
> > request for the actual driver.
>=20
> We were actually going to send a v4 this week sometime just to modify
> the firmware path for linux-firmware... I can either just send that
> as a PR or would it be best to send a v4 as patches again? Obviously
> PR is easier but I didn't want to include further changes without
> at least letting you know.

Please just send a PR. If you want to get it merged soon then please
send it soon, there's netdevconf coming up next week.

johannes
