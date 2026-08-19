Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A66346A0B
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102321; cv=none; b=jCjaPkO1/mM7xfMbfdEHBhuzcIV4OJd8WQurqSUOqOPriGyGzN3soP6wysd1GEhVs2n3xyWA3VkV1yYsRXb2qZtcVDE16P7wSZS+yYlz+mzO9Eg2CEKZlWM0P4E84blUwDrhu6STUZRBolqzu9m4jTPVoijqZACIZdKc+122+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102321; c=relaxed/simple;
	bh=ZjugNn5Vq03eTTWqVLQlz6kQYnIMpwR3Qn5/6vVZObc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBJmJwZCx/Ru7fJMG6PvgbjYRElLbmxG6ydv7nhkbwQVbhlpD/+0xzSKw4bLvy3FzbzXtF8BzRWAUkU/sI1BC0+1XBinQ+L5gdsDGgWXMr3XVXWDguwe1xtuW3+3HmrSc4QkFoMTDtWAhHSgwTLMGijh0slaHOu1Uvy1AKLeoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=XZ5x1p3a; arc=none smtp.client-ip=91.218.175.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="XZ5x1p3a"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZjugNn5Vq03eTTWqVLQlz6kQYnIMpwR3Qn5/6vVZObc=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787102316; v=1; x=1787707116;
 b=XZ5x1p3a6mVYzy2UuX2oYCLZRKPJYNNnx+MonCJ9FLXSApIrE+cOk6gjIIFeiXGJ/QtxWClz
 30dtyTU1UolLN9Jg3H7+Q+q1peGCkIYrj4Be3qTSY++ViazKT00epHa5ek0KDgUtOi93fP8z6r5
 buGBwCBsFcnkYaewlK/hmkfgkbcrzvqQWbBipsKTlKSTcVCo5oveJyjSvgL4D8QD0dBPGp77Is9
 LtdfXM8zuJUdHmqXT0c1MX0DdylwQNQav/NtOHuD5IHGBWk5w6LzQf40Zrn9DaiLuiirT0KdIlK
 hFTLF4W60xdmEvtLPSiXW/GWcoGB7gBpdSI43x4Nk4r+g==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id cd7e0096429ff81b;
	Wed, 19 Aug 2026 01:18:26 +0000
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jonas Hort <jonas.hort@posteo.de>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	lorenzo.bianconi83@gmail.com
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Date: Tue, 18 Aug 2026 18:18:24 -0700
Message-ID: <20260819011824.40539-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a3d6db95-7db8-4fa4-808f-46ed43d183ff@posteo.de>
References: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de> <d8e493ef-90ff-4364-ad4e-1709fae97005@leemhuis.info> <20260816204805.46779-1-lucid_duck@justthetip.ca> <b83a5708-b5f4-48e9-85a5-37b3ab34af46@posteo.de> <a3d6db95-7db8-4fa4-808f-46ed43d183ff@posteo.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thank you very much, that answers both things.

The ROC tracing is the more useful of the two even though it came back
negative. Two of the three freezes have no ROC activity in them at all, so a
link switch that never finished cannot be what starts this. The middle one
does have rocabort, mloroc and rocwork in it, but one out of three makes
that look like the exception rather than the pattern. So the area I sent you
looking at is out, and that is worth knowing before you spend nights on
builds.

One other thing worth saying first. There is a five patch mt76 series on the
list at the moment and two of the patches look like they were written for
exactly this bug. I do not think they were, and it is your own numbers that
show it. The failure 4/5 fixes stops mt76_txq_schedule_list from servicing
the queue, and the one 5/5 fixes stops mt76_txq_send_burst once the non-AQL
count reaches its cap. Both of those keep frames from ever reaching the
hardware, so if either were your problem head would be sitting still
alongside tail. Yours does the opposite. Head climbs 390 to 408 while tail
stays at 260, so the frames are getting into the ring and nothing is
finishing them, which is the far end of the same path. 2/5 is a use after
free when an interface goes away, so it does not fit either. I would not
expect that series to change what you see.

On the bisect I would build v7.0 next. There are 32 mt7925 commits between
7.0 and 7.1 and 19 of them are one run of work from Sean Wang, reworking how
the driver tracks the per link mlink and WCID for an MLO station. That is
the kind of change that fits a bug only showing up with two links up. If
v7.0 comes back clean, that series is where I would look. If v7.0 is already
broken then it is off the hook and 6.19 becomes the next split. The mt76
core and mac80211 both moved in the same window, so mt7925 is where I would
look first rather than the only place worth looking.

Devin

Am 17.08.26 um 23:34 schrieb Jonas Hort:

> Quick follow-up: managed to confirm 6.18 as a clean baseline on my
> own hardware now (not just secondhand from others in the forum
> thread) - running Linux 6.18.42-1-cachyos-lts with MLO active
> (5GHz+6GHz, same FritzBox 5690 Pro) for 3 hours straight, no freeze
> at all.

Am 17.08.26 um 16:25 schrieb Jonas Hort:

> One correction to how I described this earlier: the connection does
> NOT reliably self-heal on its own. I have manually intervened every
> single time to restore connectivity [...]
>
> Update on the ROC tracing: three real freezes captured now with the
> kprobes active (all confirmed via the WFDMA0 tail-frozen signature).
>
> - Freeze #1 (15:37): no ROC activity in the trace.
> - Freeze #2 (15:43): [...] The trace shows several ROC events
>   (rocabort, mloroc, rocwork) clustered together.
> - Freeze #3 (16:15): no ROC activity again.
>
> Uploaded all three logs to the bugzilla ticket if useful:
> https://bugzilla.kernel.org/show_bug.cgi?id=221884
