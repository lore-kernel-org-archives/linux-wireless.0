Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CDD1891A9
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787508502; cv=none; b=VC2OcvuVfYPtMEErxdLOsHNFhruM90G1AxZYHP8trFIsE7kJbpRZ0y+it3ADbDCp5N6ZGb7+I6gc3nrZjSxzvJudQIu2iO6Pp5sEQad2kPC7ERiVb3174ErkJE5IPJxj2N96Ll0oyTei5fWfG5JX2rjPJTJEUkJuT6xYBjerBwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787508502; c=relaxed/simple;
	bh=Oh83goEouOlQ/vDQf3TwfhKOXlMvH5Ov0tIE/JvQI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWIE0DEl6qdOSGIvkr2aUEtfUpthv/KChh9+NNpYXT5J8CRc0UFOh5OwuZ8oBL9yBFe6lxWyIfnD3ehbfFBW66IsT49Qk3M7yGkgT8E+tXu5aXwoypnHtDfvVv95q2kFJ5Q/bammy9WrmcBPPzOiXqH73v74dfbAfsM0PvK2JLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=VxIl4qBZ; arc=none smtp.client-ip=91.218.175.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="VxIl4qBZ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Oh83goEouOlQ/vDQf3TwfhKOXlMvH5Ov0tIE/JvQI5g=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787508497; v=1; x=1788113297;
 b=VxIl4qBZpEDB191X8tUfuN6eULt7M7TzcjdHEiaaIu3SM3h0Nltbq7FdGpuiAL0Nqy8bn6M3
 8i0MyRYmDwjmKpaF7oG1/U01nf8ZL3pLTrbSpnnYXIUKbn369fF+AZjyCiGN4zqAPSRILd8P995
 /4DQJmWSTcJaO7vRgm24RdgWJggIvUG1gVXPIAsWdS82nlN4JAdU+iur6IOXoE2pQ3C8Bvrq1Db
 MyS0svGhANL3fidEn4MFF/PNxXOBsl6vzPdRXoVKufINSbTti91PPVnisL37hIgyS3GvM/tWYU4
 BY+X70YQdghwSn2LMUmNSisnnZSCOVwRZf2O4mLVCvyIQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 67df95abeecea53b;
	Sun, 23 Aug 2026 18:08:17 +0000
X-Mizu-Trace-ID: 67df95abeecea53b
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Pablo Diaz <pablo.diazv@pucp.edu.pe>,
	linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for all 20/40 MHz rates -> assoc fails except at close range
Date: Sun, 23 Aug 2026 11:08:14 -0700
Message-ID: <20260823180814.4081175-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CA+Hv-VrxZV6yg5eBBRsUrNFOzCx9upS735RDO-pfPatUEdWz4w@mail.gmail.com>
References: <CA+Hv-VqAQ38g9hGf+-nBcpRNZrcowicSejRQKgBswPOR-o+adQ@mail.gmail.com> <CA+Hv-VrxZV6yg5eBBRsUrNFOzCx9upS735RDO-pfPatUEdWz4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

On Sat, 2026-08-22 at 23:00 -0500, Pablo Diaz wrote:
> Whether the BIOS tables are bogus or we mis-parse them, mt76 applies the
> value with no sanity check.

Only just came across this. Nice bit of digging, so here's the other half of
it.

Your -1 is the tell. Those tables are in half dB steps, so it's claiming minus
half a dBm, and that isn't a cap anyone writes. Real entries in there are small
positive numbers. What you're looking at is the driver reading bytes that
aren't limits.

Same flat 4 showed up on an ASUS laptop back in July, an MT7922 rather than
your part. Turned out the country list on that thing said one table layout and
the power tables were written in the other. Driver takes its version from the
country list and reads everything with it, so both tables came out a byte off.
There it landed on a zero. Yours coming out negative would be the same fault
reading different rubbish.

I sent a patch for it a couple of weeks ago. It throws out a table whose size
doesn't match what the table says it holds, so a mismatched pair gets dropped
and no limit gets applied at all. That machine's bytes and the walk through
them are on the issue behind it, if you want something to compare yours to.

https://lore.kernel.org/linux-wireless/20260811232839.515463-1-lucid_duck@justthetip.ca/
https://github.com/morrownr/mt76/issues/62

Whether it covers you comes down to whether your tables fail those checks.
Your MTCL, MTGS and MTDS bytes would settle it either way. And if they come
back well formed, then something else is driving it negative and I'd sooner go
find that than clamp it. A bad parse lands on a plausible number as easily as
an implausible one. Which, imo, is the version nobody ever notices.

Devin
