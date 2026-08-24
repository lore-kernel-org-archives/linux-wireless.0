Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945B3161A2
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 04:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547047; cv=none; b=Oj+uBsxN972rgg+hBrSLzg1EhA2H7Nxphkoi89M83QeN4f9tLyUnMBp9bSLnEM7TDgYlZif3gEwZdfLsA9uyicSPAZRJDYk7pYfTEAOhycjAiVoO/AVGZ3u9BgbR/1896QCm1bzukd6GNQLxMo0HBmM5/RyyAEQfW+o/5VWGIf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547047; c=relaxed/simple;
	bh=e3byyq4g1dQsxQ7PXakyFcYRfesWBe/OXxD5///SQFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9HuhzcFF0Ij8UcnEKw+EjpPj3QqEsV8vEt4qyQzyz1KsHbDaJXMDMmIQ+kygqOTOFML2Og2RC5dxrYG4gO9AI8sgYwgLo+mZyLOeuHKaKTkVknxu18YXig3po0e1s/4/yZzcE3+XQooVlstfYHOUIaL9x94azyx7BMb+7ZoTbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=tBsH6hJT; arc=none smtp.client-ip=95.215.58.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="tBsH6hJT"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e3byyq4g1dQsxQ7PXakyFcYRfesWBe/OXxD5///SQFQ=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787547042; v=1; x=1788151842;
 b=tBsH6hJTEWsBQAfR5i9RxEdcU6B+x8UR4R8KgfR8OEGuXFVFiR3akgj0tg4uV/0sZILue6M2
 MfLFhJFFP8iozFzqJ5Kac9ej9SPTIZz2MynjQB6vK9Ubp7y+PwnczbLpTFlvGCJYjQQDdN49lG1
 4S5IXQ8hS2XiOLVzMhy01/gRZImUJqnACNraOD/AfHXkmlAUymUPeRfeHjAwg7mcDrmdcH6PnfD
 4rGD6cY3sJ/AfC4FIm7wpPj1rL9XQ3/6dSrvZSz5lsWAkcNjeDTdwhA9Fr1uKa2frHhfyq2x8OO
 7nYlET5jgx9WL5RevkF2OCMHwnzWGuyImagOTDJ/zKlZQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 6a715984413e6a0c;
	Mon, 24 Aug 2026 04:50:42 +0000
X-Mizu-Trace-ID: 6a715984413e6a0c
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jonas Hort <jonas.hort@posteo.de>
Cc: Sean Wang <sean.wang@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	lorenzo.bianconi83@gmail.com
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Date: Sun, 23 Aug 2026 21:50:39 -0700
Message-ID: <20260824045039.50873-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de> <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de> <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-08-23 at 20:54 +0000, Jonas Hort wrote:
> Bisect is done. First bad commit:
>
> ff643b81bc38eaff6c0ab783a62e4ba9e10d2476
> wifi: mt76: mt7925: pass mlink and mconf to sta_mld_tlv()

Jonas, that is a careful bisect and it holds up here.  The commit is Sean
Wang's, absent from v7.0, present in v7.1, and ea757740dd87 really is its
parent.  Adding Sean, who knows this code far better than I do.

The part I would look at first is the link count.  Before, it came from the
number of valid links, capped at two.  After, the primary is always written
and a second only when the caller passes one, with the count taken from
however many got written.  So a two link station updated on the primary
would tell firmware it has one link where it used to say two.  Subtle, and
easy to miss in a change that is otherwise a straight simplification.

That is from reading the diff rather than reproducing it, so Sean may well
see something I have not.  Nothing has touched that function since, so 7.1,
7.2 and mainline all behave the same way.

Jonas, yes please to the bisect log.  If the setup is still up, that commit
also added a rate limited warning about a missing primary mconf, so it may
be worth grepping your failing runs for MLD_TLV_LINK.

Thank you for the work you put into this, it was not a small ask.

Devin
