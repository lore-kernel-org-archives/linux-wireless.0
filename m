Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A76F3C1D49
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787159713; cv=none; b=oPN5nGArdPKAVg76g2a50WsY3GntFd/89vInzLZPM6i7VLNFkl47NO8809kJ5eBkEEvBp2Pnc6qU3vOOFEqKxpopDJ+0SAWjSw+K1aklKughrv1YbVmnE7H5sLVnTZlLQcy6UtEHBkRFOHT0hlq1s4LcqGEF4+9KEHyuLHSZXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787159713; c=relaxed/simple;
	bh=ZGyWkzttW3nnagzLYFMbHLzIPd7mtY05HDR/82e8DcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9w5Tpb26QPBINYhK7cUCVHzbMQ7OCcFU+xCFri0rU2RTeGyR6TNTohB7xQXdT+vrkFfnmafiUh9DQp3VB4P9rJQgXNL+bq0eKJHlpk6RP/ceLaUZ+NsnS2k/jXxXwAuI6StQVvxTjpMNRH/aGDi+bSGQGAQl2MuLUhgMyV6JGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=SUSkrFnJ; arc=none smtp.client-ip=95.215.58.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="SUSkrFnJ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZGyWkzttW3nnagzLYFMbHLzIPd7mtY05HDR/82e8DcI=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787159702; v=1; x=1787764502;
 b=SUSkrFnJEmbJ2pb6e84rajVNq0XdJ3S34SBtjasq19cAWF8n0Ko83DpdaFglz1wzQs5aK9R3
 K+bZdeCXXCnHLJ7NcKxTYAxwjM9SK81KNAX+f2fPVHI61DqIy5d7GKwJsloTg90lVj1neNO4qqz
 2x667X9jkwku0VL0yDlQXNelcEb/X/cJPw8FJZZAH3NSKVau40ueAwHmJOBopZp7yITjpONjRPj
 dCqex04nGqJLuPpQ30S6uXqw3DlkJwKLwAIM2EwLVYFCPi2U2FRdAJdE8BYyruGKeDQbcoMM3K/
 F0R/JfTxHpZdwT3BYIjM8QvolxO3Uv4Pa1bIv+tVfAxiw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora.lan (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id b01abdb8988f6c9c;
	Wed, 19 Aug 2026 17:15:01 +0000
X-Mizu-Trace-ID: b01abdb8988f6c9c
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: moosager <moosager90@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Wed, 19 Aug 2026 10:14:54 -0700
Message-ID: <20260819171454.21329-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an23_8DALILoGLP6@fedora.fritz.box>
References: <20260809012309.43657-1-lucid_duck@justthetip.ca> <an23_8DALILoGLP6@fedora.fritz.box>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Thanks for testing it, and sorry for the slow reply.

If you're up for it, reply with this line and it'll get picked up:

Tested-by: moosager <moosager90@gmail.com>

Fair point on the 2022 one. The difference is Deren's had to be a goto
because napi was already torn down by then, mine returns before any of that
runs. Still doesn't tell you why the handshake fails though, you're right
there.

On the debugging, I instrumented the same failure on an MT7922 back in July.
Wedged, it read lpctl=0x00000004 and misc=0x00000003, and a scratch write of
0xa5a5a5a5 read back exactly. So on mine the bus is fine and the chip is
alive, it just won't give ownership up.

Yours reads 0xffffffff where mine reads 0x4, and that's the part I'd chase.
The same write test tells you which one you've got, no patch needed, and
nothing on the host side reads that register:

  echo 0x54000120 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
  echo 0xa5a5a5a5 > /sys/kernel/debug/ieee80211/phy0/mt76/regval
  cat /sys/kernel/debug/ieee80211/phy0/mt76/regval

Comes back 0xa5a5a5a5 and it's alive and latched like mine. Comes back
0xffffffff and it's off the bus, which is a different bug.

Your repro wedges an MT7922 here too, for what it's worth, not just your
laptop.

Devin

On 13 Aug 2026, moosager wrote:

> I would like to reiterate, though, that a more complete fix should be
> pursued by anyone who has more knowledge of the driver or firmware.
> Previously, a marginal improvement like this one was applied, but the
> issue persists to this day (see [1]).

On 4 Aug 2026, moosager wrote:

> and it expects to find 0x00000004 (which is PCIE_LPCR_HOST_OWN_SYNC).
> Instead, when the issue happens, it finds 0xffffffff, which does not
> change even after the driver attempts to write to it.
>
> I would like some guidance as to how I could debug the issue further,
> though ultimately the problem is likely in the firmware.
