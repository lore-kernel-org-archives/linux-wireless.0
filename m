Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55E14908AD
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 19:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788290595; cv=none; b=dHMRHwex6fzFrHcMifiVefVFoZnwsdOqYQtSqnhxByvsOENJ8vZYU5+ev7f0fba9hAR4XLgynJBVvA4zNsghsXi97sTOWqUeeaF7UTY16mDttQeoVbrN0H3azkDcFJydmAag/ZEn8SeBfjDTt6N9W2cta6eWWRI+Cj/ZT/o4S34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788290595; c=relaxed/simple;
	bh=1wQlB39M9V1BYchU/8sz6ViFjGe0DgV2eyVYFBpOrAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpfLxi2PjSLI5jjCAdrfDQeChGy0jYftoEp1+MLWzEBuWWoFinnwjRVoi2qnVr1tOJiVsTkpKPUZ7BjBFepcGHfz849Tc1JNknLlExpmA24k25lwiAcaCGDHZq3iIbH6sL5iCdqi5xLFK4AAS+yViwsrN3fmIb0EnQgV2F5WlIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=HZnpEvzP; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="HZnpEvzP"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1wQlB39M9V1BYchU/8sz6ViFjGe0DgV2eyVYFBpOrAM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788290590; v=1; x=1788895390;
 b=HZnpEvzPOkdzyVMazIosJo9odJjFfrXrQzmnGC1UCZ8Jb82yG5CrmvSNUyyiJzTbgyAYU8Ay
 OojBWA0IGkEXoSGg8lzADf7G8GnKU/bAyeJzyvpzUofZBW5RVO6Vy59xxa7hKljYgIkvPeeZfo6
 dzRHdZYswcQWEAt34nO+Gt+BmYe34VdX+PV3aFHAcHPX1PyOZ5EzBjaLT1fnQSSGVDZqNU4C9vI
 I7PVrpOVRDItuxldUWMrZLGJ6t8lEjBh9tgOyz/Iz3MspUU1EMPS/ATtSypUPcof8SS7g2qRpV7
 q3lsb41KuLHUjGw1rOaK9NYmKKpspzQ7FIPNX1Bz30CBQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 63220c7e2fbc9a39;
	Tue, 01 Sep 2026 19:23:00 +0000
X-Mizu-Trace-ID: 63220c7e2fbc9a39
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mac80211: fix channel changes for active monitors
Date: Tue,  1 Sep 2026 12:22:58 -0700
Message-ID: <20260901192258.6603-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
References: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nice catch. This has been sitting there since early 2024 and it is good
to see it on the list.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>

Two MediaTek USB adapters on the same chip, before and after on each.
One on 7.2.2, where it applies clean and I tested it as posted. One on
a Pi 5 on 6.18.34, which needs two small edits, since that tree has not
had the chan.c refactor and calls the iterator link instead of iter.

Before, the monitor sits on one frequency and every channel request is
accepted and thrown away. Eight cells across the two machines, hundreds
of frames, not one on the channel I asked for, and nothing in the log to
say so. After, it goes where it is told, every time, on both.

I went through this in March on the same chip and wrote it up with diffs
and results, three defects in all:

  https://github.com/morrownr/USB-WiFi/issues/682#issuecomment-4115109552

Yours is the third, and the SMPS hunk is a piece I did not have. Still
open is that an active monitor gets no channel at all when it is
created, only when something later asks for one. Your patch covers that
in practice for anything that sets a channel.

The iface.c hunk there gives it one at creation, but do not take it
alone. On mt76 the sniffer is armed only when the channel changes,
never when it is first assigned. So once the interface starts life on
the right channel, asking for that channel changes nothing and it hears
nothing: four runs, zero frames every time, with a passive monitor on
the same channel hearing traffic in all four. Ask for a different
channel and it works. The driver half is mine.

Good to have another pair of eyes on the monitor paths, they do not get
many.

Devin

On Mon, Sep 1, 2026 at 2:55 AM Matheus Alves de Almeida
<matheus.aalmeida@inf.ufrgs.br> wrote:

> Active monitor interfaces are added to the driver as real VIFs so that
> frames addressed to their MAC address can be acknowledged. However,
> ieee80211_set_monitor_channel() redirects monitor channel changes to the
> hidden monitor_sdata whenever the driver does not set
> NO_VIRTUAL_MONITOR.
>
> An active-only monitor does not create monitor_sdata, so the function can
> return success after only updating monitor_chanreq. The active monitor
> itself never gets a channel context, making channel changes ineffective.
>
> Use the active monitor VIF directly when changing channels, while keeping
> monitor_chanreq private to the hidden virtual monitor. Also treat active
> monitors as valid directly channel-bound monitor interfaces in channel
> width and SMPS accounting.
>
> This fixes active monitor channel switching with mac80211_hwsim. Before
> this change, an active monitor failed to discover any APs while scanning.
> With the fix applied, scanning works across channels 1, 6 and 11 with both
> channels=1 and channels=2, and authentication and association on channel 6
> succeed without mac80211 or hwsim warnings.
>
> Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
