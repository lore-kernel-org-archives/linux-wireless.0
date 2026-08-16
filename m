Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EF3C7DE8
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 20:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786913302; cv=none; b=ASelzWbg1Bm3CNTHmH32myMdSVfwPtFc9KNZXanQgJBZxDzLPrl7wiCwjEdgh2SbtM6wzZSbKhAK6KZCpTPiZ9GBPdeaEq6pYsXeHJ0tHGmqVe9H7IBkTgnya+yqOdRL+VsFbfWnOENmhb6DMoG9DEgLD3wC5NUVX07Ytb0wguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786913302; c=relaxed/simple;
	bh=TmDfhebM2pU7zHzkAqWq/1LAGM1PO9/tGBn4lrgmboo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARH7Q5UPg+7iK46Bdt8LqyepOUK0sbO/U0TeRbErAZjWfq4XHqeqhHFRmSIIHrV1UPMprVjdtzw642YUK7nx1BBdfZUyRQFyPRxD5RKiJN+55qVNX9fFr2M5LU7E5IqEeMhf8ZwrsksQwCxpEYqZi4AWX8fy+4IfrvQKviSPeQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=G8LF1MlB; arc=none smtp.client-ip=91.218.175.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="G8LF1MlB"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TmDfhebM2pU7zHzkAqWq/1LAGM1PO9/tGBn4lrgmboo=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786913297; v=1; x=1787518097;
 b=G8LF1MlB3My3iRr13YYJlsDn6JIx+x97X40WcfLS3fPAbIrnBPjG8IuUJMxk9xYORzvHwOKi
 Lq84/qCiPm6m3GPG1sKR+uKJKKFZLokeIQ2yqKqhW2NtfIvAGRLCkhVhOmL8wual+mBX1nLB9iT
 EfnzghPERLTRsvYXtFAh1HpJiOC+U08wbk3bCcNkMvs3ozEJcJaPavDAQ1OQ8N5m4PuTFxTdYgw
 sEWDm+cwJQ/ag0Mb3xNwBtpJhoVSCDioiWKJ72CwNs1mk513b8/VgeMTtj4Ut/LO+ExRtIUtq3l
 TpkB99FYJ+HLUBrMEjjkyV+6wBHscGldLKO7Y1+GXouKg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 7d793e5c4c366af0;
	Sun, 16 Aug 2026 20:48:07 +0000
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jonas Hort <jonas.hort@posteo.de>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev
Cc: linux-wireless@vger.kernel.org,
	lorenzo.bianconi83@gmail.com
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz link active
Date: Sun, 16 Aug 2026 13:48:05 -0700
Message-ID: <20260816204805.46779-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <d8e493ef-90ff-4364-ad4e-1709fae97005@leemhuis.info>
References: <066b30cc-a9e6-4aeb-964d-71551e8ea3ef@posteo.de> <d8e493ef-90ff-4364-ad4e-1709fae97005@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 15/08/2026 07:51, Thorsten Leemhuis wrote:
> CCing Devin, who wrote two of the following messages

Those are the mt7921 regd deadlock. mt7925 does not have it, there is no
equivalent of the mt7921_mac_sta_add() call site that creates it.

Worth ruling in or out before you bisect. mt7925 sets
IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS to 0 in mt7925/main.c. It is an N-1
field, mt7996 sets MT7996_MAX_RADIOS - 1, so 0 means one simultaneous link,
and mt7925/mcu.c then requests MT7925_ROC_REQ_MLSR_AG or _AA. MLSR is
multi-link single radio: your two links share one radio, and ROC is what
moves it between them.

If 5 GHz is your deflink, your pair is named on that path in
mt7925_mac_set_links():

	if (band == NL80211_BAND_2GHZ ||
	    (band == NL80211_BAND_5GHZ && secondary_band == NL80211_BAND_6GHZ)) {
		mt7925_abort_roc(...);
		mt7925_set_mlo_roc(...);
	}

That one only runs at association. The path that can run mid-session is
mt7925_change_vif_links(), which calls mt7925_set_mlo_roc() for each added
link. Both reach mt7925_mcu_set_mlo_roc(), and all of this is the same in
7.1 and 7.2-rc7.

Under your existing watchdog:

	cd /sys/kernel/debug/tracing
	echo 'r:mloroc mt7925_mcu_set_mlo_roc ret=$retval:s32' > kprobe_events
	echo 'r:rocabort mt7925_mcu_abort_roc ret=$retval:s32' >> kprobe_events
	echo 'p:rocwork mt7925_roc_work' >> kprobe_events
	echo 1 > events/kprobes/enable

Association will fire mloroc once, so anything later is a mid-session
switch. If the WFDMA0 tail freezes while one of those is in flight, it is a
link switch that did not finish. If they are silent across a stall, the
whole path is ruled out and that is worth as much.

On the bisect itself: your 6.18 good point is second-hand, from different
hardware and a different AP. Worth confirming on your own box before
spending steps against it.

Devin
