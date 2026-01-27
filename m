Received: from mail97.out.titan.email (mail97.out.titan.email [3.219.11.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C083E3093DE
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 20:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.219.11.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769544732; cv=none; b=drXZ8XuOIR8qq/c7KD5HqRdQv3CGmDtAox5LFsfkoxIK2HioWPQl7rddGM+dNdlMPecNgCsA/td7k1lc2opsBdWIuLJ2cftiXQQG9oyyWWPzCz8ZQ01dHyhRQSKb6l2faHxZfyKVI6EcTXdFIin5mHXhraAhF7vLrWObTmF+BLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769544732; c=relaxed/simple;
	bh=B7ocO1iwCY7BL3zpUyytFWtuifDou33abpyRpmPr1mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW6XF2Htfu2myMP2JS29aN0gGlGT4iZDM+O29QiP7ang4t3AkrQj80uJ8O4Hd2hU4N5W731sdf65d7S9Gb3zzAFj/l1P/dCzICMV35gjaLYcnFQ6QPfkTjPxssTf+Bc+6eSBOKC85ZUDkbqdskUx99gqAchNj9s31sjyBTTyKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (1024-bit key) header.d=t32smtp-sign002.email header.i=@t32smtp-sign002.email header.b=P28oBLyI; arc=none smtp.client-ip=3.219.11.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t32smtp-sign002.email header.i=@t32smtp-sign002.email header.b="P28oBLyI"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 4f0xDP0TQYz9ryl;
	Tue, 27 Jan 2026 20:03:33 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=B7ocO1iwCY7BL3zpUyytFWtuifDou33abpyRpmPr1mo=;
	c=relaxed/relaxed; d=t32smtp-sign002.email;
	h=references:cc:subject:in-reply-to:from:message-id:mime-version:to:date:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1769544212; v=1;
	b=P28oBLyIPM/iWJgG0vVf/r0jjMbnhA2iB4KVp7OVix+CGfUOCwUl5Jx2otZOYRv+B82o2gm0
	m7FZrErOJzjvmyBrLw8uDbtXSsZ1FuRuU5tyPFReL+r+MhpN73banzI+77JdIfLxjxmCK1Ex2PJ
	GCnF5iN0C8QgiXwvfVVukRR8=
Received: from fedora (unknown [37.19.212.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp-out.flockmail.com (Postfix) with ESMTPSA id 4f0xDN1vpvz9rwm;
	Tue, 27 Jan 2026 20:03:32 +0000 (UTC)
Feedback-ID: :lucid_duck@justthetip.ca:justthetip.ca:flockmailId
From: Lucid Duck <lucid_duck@justthetip.ca>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Mh_chen <mh_chen@realtek.com>
Subject: Re: [PATCH] wifi: rtw89: usb: fix TX flow control by tracking in-flight URBs
Date: Tue, 27 Jan 2026 12:01:04 -0800
Message-ID: <20260127200104.24048-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <471ce67a-8633-46f3-882e-6051ab022a7e@gmail.com>
References: <471ce67a-8633-46f3-882e-6051ab022a7e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1769544212888180727.13754.1576376218115582375@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=a8/K9VSF c=1 sm=1 tr=0 ts=69791a14
	a=e/lPLjqIkJJOfGtOMneIMA==:117 a=e/lPLjqIkJJOfGtOMneIMA==:17
	a=CEWIc4RMnpUA:10 a=495fNkP5YetcU8nULlYA:9 a=zgiPjhLxNE0A:10

On Mon, 26 Jan 2026, Bitterblue Smith wrote:
> The CH12 checks in the completion handler are unnecessary since there
> is one in the resource checking function.

You're right. I'll remove the redundant check in v2.

> Is there a reason to add a new counter instead of just using the
> length of each tx_queue?

Good question. The tx_queue length tracks SKBs queued for submission,
but doesn't account for URBs that have been submitted to USB core and
are in-flight (between submit and completion callback). An SKB is
dequeued before usb_submit_urb(), so skb_queue_len() would undercount
actual resource usage.

The atomic counter tracks the full lifecycle: incremented at submit,
decremented at completion. This gives mac80211 accurate backpressure
even when URBs are pending in the USB subsystem.

Happy to hear if I'm missing something that would make skb_queue_len()
work here.

--
Lucid Duck
