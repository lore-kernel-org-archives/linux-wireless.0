Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BEB27EFE9
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338358; cv=none; b=XVIWcudIEaJYiZHNP03EXmQgwgLtk56OCGw5Rwt6QDty+08CeGBbwUvWbsCT2ygrMmD/Pfv4cIeCXuis6k8iMUbGpHTGdE/MPniHZrLr5DXfNCnf0uS9+81lgfMmNYehECZNBHZzFBiDJmubnrRGohZ9LCk526NCuWVv2vrr5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338358; c=relaxed/simple;
	bh=vKfEcO7AqTf31f5HWzZI5dsNdrrcDTP1akoBKWid5mk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iTt1mvFcuVUMJjrtIlGTK6r6LWLlY6FpXUK3ZxIteDqIBbV5PakbFkCWsHr/wh7J+h44bE/5tbb2nK6r8YnrieIi754U4vwdGc4LELyskDXbq8xHaTdwmWMcXCLyKAiaJ62CjlhUC7R9oVkbfiQ4e+O6dN25n2GgwzSlWPHRYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=G14XW8Sg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="G14XW8Sg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=vKfEcO7AqTf31f5HWzZI5dsNdrrcDTP1akoBKWid5mk=;
	t=1783338357; x=1784547957; b=G14XW8SgI24q945G/E+MxlcZdqP/qvyNjhym4r/Cm4po9mS
	IRWDaJyvopE+U40THtDwI1gl4Qxb1Fz2nIR2hCDBo36Vnmb4ZyYfprNcz6a9Z/MEWAk0ZxV7f7oQO
	X55aOMnPVuh8eW/jxClK3Lazw5SVNQjwASf7D8mTyMBaGRAJyXZ93vcNUzBqdM/s+pOek2RccwJEV
	3LD9QE1chU7ck3nCLsUDGNTlWhFgGgmy8vGfJTClUvM0NkjjocajH3dGFFQ4zVMZ+awATSW6P0RGj
	5XMJqinQELjnvBK+bz3nVMYoQE6LSc6FSlaQF9E1KD/8WFDf9wTduSmBq4MgeYOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wghlq-0000000DNb4-273m;
	Mon, 06 Jul 2026 13:45:54 +0200
Message-ID: <c48d02d04101e50ece0feab60fb04f63aef37140.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v3 00/33] wifi: mm81x: add mm81x driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: arien.judge@morsemicro.com, dan.callaghan@morsemicro.com, 
	ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, Andrew Pope	
 <andrew.pope@morsemicro.com>, Bassem Dawood <bassem@morsemicro.com>, Chetan
 Mistry <chetan.mistry@morsemicro.com>, James Herbert
 <james.herbert@morsemicro.com>, Sahand Maleki
 <sahand.maleki@morsemicro.com>, Simon Wadsworth <simon@morsemicro.com>
Date: Mon, 06 Jul 2026 13:45:49 +0200
In-Reply-To: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com> (sfid-20260626_083032_515938_B5135BBF)
References: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
	 (sfid-20260626_083032_515938_B5135BBF)
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

On Fri, 2026-06-26 at 16:28 +1000, Lachlan Hodges wrote:
> This series adds the first Wi-Fi HaLow driver to support the Morse
> Micro mm81x chip family via USB and SDIO.

I've applied the cfg80211 patches in this set, please send a pull
request for the actual driver.

johannes
