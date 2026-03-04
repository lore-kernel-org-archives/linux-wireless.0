Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4533E358
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2026 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772624077; cv=none; b=VNV/vF/9a2UyWo7Z+HcKIX2GPHq0lrebH17tgu8kppSwg8dGE9InzKqx25lduYomVrzE/5Zcr9wk7FzfkVsm0cBD82W75bm24xUFBCOPanduBVaKFWJrrvPdnKXBhub/dMEnW/yszeDnxey1R+MuaboPPD0J7LxiiZFxaEsXOhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772624077; c=relaxed/simple;
	bh=+ydg5JekApmDwwUyG1JhY4TukpfxHfk5RCBiyF2Tx6E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lhyposn9aF+Np/TngmuCMwZRn7+SIhOQjTjvGlrLFLhKygMOdm+u9mLVAon+ny54hZW51MZExunKpiwHW825Grlgljw+4qLOqwUd7jk5uYaevOKW8bxoY4zEyvLHSajF0VMPXKo1M4I+wajzMnC7qtbginkJf4lH7rCmg5u+IqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=M6Lvgdzh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="M6Lvgdzh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=P1Spv9yTDyLoz7LclTPXhKbpatkXvNkr6UT20YFNfZA=;
	t=1772624076; x=1773833676; b=M6LvgdzhOSWvDNYiOThddKvJvLHp3zo+PABAvEpewmW+SF3
	uY5uRdk2yA1GcX8T4TxC5RLa0uvboXwIstKL7SepSM+jSujNm9eNxyqnIeC8PTGsSGZTtWdAkZan1
	0KigS8jO2KY0s8i9qD7AFOWaAdJmfOxmP4V5BjNYldCG1md7FUrdBkXNsqIm+Z+B0Yls7v/7RC1Iy
	qvz93x5V1HuvCFa2MdtAJxJ8SiesD9zmjxIagOMFOPFSTXWiDiv/MPWf1bHNHmkROfpgUIQynclj9
	do5DAN58mQdMpcGZ+jnIzpg5jxJJsbulJ939R1vQx4pzyBJK7dBoeLmxgtD3lctQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxkUr-000000082zn-1xVN;
	Wed, 04 Mar 2026 12:34:33 +0100
Message-ID: <6f10a9f5daea102dc2f7780b93b8f8f7e48025fc.camel@sipsolutions.net>
Subject: Re: pull-request: ath-next-20260303
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Mar 2026 12:34:31 +0100
In-Reply-To: <18112483-1280-4ede-bd59-10cac700404e@oss.qualcomm.com>
References: <79e82568-e951-43f4-ac87-2319245a5490@oss.qualcomm.com>
	 <18112483-1280-4ede-bd59-10cac700404e@oss.qualcomm.com>
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

Hi,

On Tue, 2026-03-03 at 08:34 -0800, Jeff Johnson wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-ne=
xt-20260303

I'm almost surprised this even still works, don't you use https://?

>=20
> FYI the reason for the early PR is that I made the mistake of pulling som=
e
> patches into ath-next before I realized that Kees & Linux had applied the
> treewide kmalloc_obj() feature, so now I need to merge so I can then fast
> forward to wireless-next/main to pick that up. I don't want to take any m=
ore
> ath-next changes until that is in place.

Sure, that's fine, I often send almost a PR per week, so should be happy
to accept that too :)

johannes
