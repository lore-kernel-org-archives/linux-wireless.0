Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456FD420476
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788041617; cv=none; b=iw78G5R7APM+hyAFeAx/xObtlmzrDvM0gRxM77lF3x4FOLuXL/XDrHguF0ZxBhAemGq/x77E3ahatlq1MU8axYV9lRJlFD9E6mlB7WhnmfuOdvybz85EuU8wpdO9QIDHt8NatLv1QaQA8p16h/Qt+DocI1YHFJA86eV39nzuYOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788041617; c=relaxed/simple;
	bh=cmGv3INF7CjXFYHoCdz/i7fRZHrlOBuYR43kDH8a1kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+3iUKSzoieg3RkZO3HKpwV+2CWJUgaInF1Ix660aUZWcbMX8DlMd2cccnZkuAwnBlpbttO57w62SkbJ3LvDWx389UKCuYkTphajU5qgozCskovJZTNL054MGr62kxsIQZsNT6nB34MmdYwzUun+04cKDHkSaW/yMNaIa9Ssn38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=K1s0SziR; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="K1s0SziR"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cmGv3INF7CjXFYHoCdz/i7fRZHrlOBuYR43kDH8a1kM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788041613; v=1; x=1788646413;
 b=K1s0SziR/lV8TeafvK+KC9JEMw0D58FgJB2qxHlWPkwCL3ypPjU09qq/NvPQkwIguJ3zXgA5
 nz6qPh4bl84vNOClV/KzXL5W8MjqyTwbSWUOekVPTrbyW0NNbfFK+0pq9vNmhZ7jkYw/UNHoZYy
 U4DkNH9wdY3foe4pj/1lfDtNBtLe/+pgKj5ZL/Vlc53cTX+Gt+N0/vGMEPDuYi5p3uWFWIzmNyU
 1UE5D25GHIr7zUd6WN3M5rCZYUaPF301Pm672ssxw9xSeyrRmEqbfqzQagjjypRhSFLCitt9bS3
 k1PIRrlrOdi71DDaHcaplmONJh+8RpDSNtDkY5egZg6FA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2d95993bb1fe720b;
	Sat, 29 Aug 2026 22:13:22 +0000
X-Mizu-Trace-ID: 2d95993bb1fe720b
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jonas Hort <jonas.hort@posteo.de>,
	Sean Wang <sean.wang@kernel.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	lorenzo.bianconi83@gmail.com,
	regressions@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Date: Sat, 29 Aug 2026 15:13:19 -0700
Message-ID: <20260829221319.25334-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de>
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de> <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de> <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de> <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info> <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2026-08-24 at 08:18 +0000, Jonas Hort wrote:
> Setup is still up and I can build and test whatever is useful.

Your bisect holds here, on a different machine and a different access
point, running your June firmware. Three states, each replicated:

  both commits reverted        clean, two runs of six minutes
  only the later one reverted  stalls, two runs
  neither reverted             stalls, three runs

Tail welded and head climbing, which is your signature. The tree is
7.2-rc5 with one unrelated ACPI patch of mine, nowhere near this path.

db134691924f lands fifteen commits after ff643b81bc38, and reverting it
alone still stalls, so the builder rewrite is the one that matters.
Reverting the builder on its own is not available either: v7.0's version
dereferences a link pointer that the later commit leaves unpublished
until after the firmware call, so it would need a check neither version
has.

A correction to my last message. I pointed you at the link count, since
the new code reports one link whenever the update concerns the primary.
That undercount is real but it's not the cause. Telling firmware one
link always is clean over two six-minute runs. Skipping the
undercounting update entirely, so firmware is never told anything wrong,
stalls on both runs. Writing the entries in v7.0's order stalls on all
three.

On the August firmware, stock still stalls, twice, the detector firing
95 and 141 seconds into the run.

The band pair matters. Same driver, same August firmware, two runs each:

  5 GHz + 6 GHz     stalls
  2.4 GHz + 5 GHz   clean, full duration
  2.4 GHz + 6 GHz   clean, full duration

Not the channel width. Narrowing the 5 GHz link to 40 MHz, so that pair
carries the same narrow-plus-wide mix as the clean ones, still stalls on
both runs.

The sharpest pair there is the two runs where the iperf3 stream never
established, leaving only the UDP pressure: 5 plus 6 stalled with the
queue peaking at 187, and 2.4 plus 6 stayed clean at 186. The other
three clean runs peaked above 1000.

Sean, the two things I can't see from out here: what firmware does with
a multi-link record naming one link while a second is associated, and
why 5 plus 6 should differ from 2.4 plus 6.

Jonas, thank you for the bisect. Five steps, every bad verdict confirmed
on the queue signature.

Devin
