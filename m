Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C436417BF9
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787585382; cv=none; b=DOZWUHh64geQp7U26pvlkx9fy8+F24xBGqMDwK0G3MdrYUOfPJPKGg3F+EeXvc1M12Th4hbgMiSRmNuRGR6MKi74jkldqOIWk6R5CDTHnj8XX6MV5Fx4lVGG236eLqyQ6Dpx+vFFS6cMK5U5ziAO46G9/e5FFc5lV2BORJOnwSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787585382; c=relaxed/simple;
	bh=TQM9PhntWAt2lt8k5M4COgt8bAYljmeqxXab3pR2gKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saCplt8jSaIdMTVszPGU3GPgHMY/sIuRONxX+2nykp870/PfP0OVUFBw8pY/cm/lgpYA3HjOHxI7/xKzWkUQJ8Lwm2XNXltSCzdbIsYRrBhCVhMLpoHfMJ92OYq+dHkdn1Y3SjHbodQq8SQ9tTo9D/FwM6i+nh/wVs2gKmr7DT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=DwQAdg+N; arc=none smtp.client-ip=95.215.58.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="DwQAdg+N"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TQM9PhntWAt2lt8k5M4COgt8bAYljmeqxXab3pR2gKM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787585375; v=1; x=1788190175;
 b=DwQAdg+NvfOLwXda4JA26GXw2phcKyTsIl3+Obge8gztA0zBlYbqoyhyWZ/fWJVdq/R3dkXn
 +uqFu16g/BxUYCcBsNFkACQ5NaCs6XrUVzEnIkpoK96MvpO4nD+RV3LmhfGDi5hAhAW+FGg+nFa
 P6Di7mo1o+zKgIkXpcW1e4QwZoNbUWiGCBv1PW/1qZA71ii/ROjzQ0es3x4gQRVDrjHXaHRr9qa
 XKEOKdOfUZ3KAHoEg5or63rEYt4bVU4yUGx4+/ke6TTmpVCnpeB/4pnJvPtY75lwXBlqDWTW1kc
 yjpNb5JKfM265sfK/azQcRAKz+2w68AA8MgFNR5Fp6GCg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id abc171f7b01dda4c;
	Mon, 24 Aug 2026 15:29:25 +0000
X-Mizu-Trace-ID: abc171f7b01dda4c
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	kun.wu@mediatek.com,
	deren.wu@mediatek.com,
	sean.wang@mediatek.com,
	quan.zhou@mediatek.com,
	ryder.lee@mediatek.com,
	leon.yen@mediatek.com,
	litien.chang@mediatek.com,
	jb.tsai@mediatek.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 0/2] wifi: mt76: refine USB/SDIO TX path error handling
Date: Mon, 24 Aug 2026 08:29:18 -0700
Message-ID: <20260824152918.11268-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819082129.1062282-1-eason.lai@mediatek.com>
References: <20260819082129.1062282-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2026-08-19 at 16:21 +0800, Eason Lai wrote:
> This series fixes a UAF in the SDIO TX path when out of memory and
> a memory leak in the USB TX path.

Thanks for turning that around so fast, and for taking all of it. The
code reads right to me now.

One thing to sort out before it lands. 2/2 is marked for stable and 1/2
is not, but the two only work together. The padding helper frees the skb
itself when it fails, which is fine today because the caller returns
without touching it. 2/2 changes that, and starts reporting the prepare
failure with a skb that is already gone. 1/2 is what stops the helper
freeing. So a stable tree that takes 2/2 on its own gets a use after
free where there is no bug today.

It will not get caught on the way through, either. 2/2 applies and
passes without 1/2, because the frame returns before the padding runs.

Marking 1/2 for stable is all it takes. The stable rules say you do not
have to list a prerequisite that is already in the same series, but only
if that patch is itself marked for stable.

The Closes line did not make it onto either patch:

https://github.com/morrownr/mt76/issues/83

Devin
