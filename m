Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A13B443F
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 03:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788491907; cv=none; b=nytJNUHYckybsxQHSawXVXjYn2YQB81Kl1PUZLrESX18xZ3dZTdA45wxnAnP45woUKM0Yy48eiMOnTS46Z+PKkD5qTxr4MTINWDdR5C012aaDDJhArZrKau8HzhmE2egJbAhHVIcP6Hs1c4TtlOivW4WHMFx6P3WpQhYdF52HdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788491907; c=relaxed/simple;
	bh=BL3B4T82/efkjC6zGEvMDESDZ5EgHGgoG1FS7HzSxEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEv8PUtmjx356mf18vy4uVZlXsDfuzKSBtmGbjxAHVEfh1SkqOla2NIX5FXF8+Eqn/mlxr5tsTqZyOVKbx8Ewu/6r8hKp9PaG9QkL9ML2wAkDN5iZmh+IgnQL/14AyLEw3xPCjg56M+sN+Jv0Z3p5HonjaLIhidZf3jxTWs3XGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=COureHem; arc=none smtp.client-ip=95.215.58.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="COureHem"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BL3B4T82/efkjC6zGEvMDESDZ5EgHGgoG1FS7HzSxEs=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788491901; v=1; x=1789096701;
 b=COureHemhRTKgc5sSr+6lN2D+Bijx467D6ZfAK3qUiOZ1FDwLwOD3LgtU9+qA90azzQCJ5xT
 rp/Ki/uQKEj8ccSsUqUcuWIjS9kcBRBedmhTd3zI3WVk3JnOOAZwswLwaJVsvjmD/BE7jZwUpgY
 goyCTkiuLHm9+RwSGopLayHBnSSwfezLH1bw/4u69VbCyQwTtYVsnVjS8ezLYqcozcDI73ka+SP
 O5SCd6dhk3YWGhaxS1SIX4o7PT7lW+SxzMWfSeOn7nF5F35+ttEcLfPdZlqZzJba97z3mobP3cd
 +UST/EaIw37E8IOdlR45G1YjbdWTEUzlpz0okUEYuMOuQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c0f2672226896a05;
	Fri, 04 Sep 2026 03:18:11 +0000
X-Mizu-Trace-ID: c0f2672226896a05
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sagun Kayastha <sgn.kayastha@gmail.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: validate ACPI SAR table length before parsing
Date: Thu,  3 Sep 2026 20:18:04 -0700
Message-ID: <20260904031804.45272-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811232839.515463-1-lucid_duck@justthetip.ca>
References: <20260811232839.515463-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've been back through the GA503RM's bytes since sending this, and
calling those tables malformed isn't right. Both are version 2, and MTCL
is what declares version 1 for all three, so they get read as v1 and
every field shifts a byte:

  MTGS  28 bytes   as v1: (28-6) % 5 = 2, nr_tbl 0, count 4
                   as v2: (28-7) % 7 = 0, nr_tbl 3, count 3
  MTDS  19 bytes   as v1: (19-6) % 6 = 1, nr_tbl 0, count 2
                   as v2: (19-7) % 12 = 0, nr_tbl 1, count 1

Read as version 2 they're an ordinary SAR table:

  MTGS, FCC   2.4 GHz 14 dBm    5 GHz 14.5 dBm    6 GHz 8.5 dBm
  MTDS        8 to 14.5 dBm across the range

So this patch rejects two good tables and leaves the machine with no SAR
limit at all. The reporter measured 23 dBm afterwards, on a laptop whose
own tables ask for 14.5.

The layouts are 6 + 5n and 7 + 7n bytes with the count declared inside,
so they never collide at any accepted size and the right one falls out
of the shape. I have that written: it applies 14.5 dBm where this patch
applies nothing.

I think parsing them is the better answer, since it gives the machine
what it asks for. Rejecting is safer if you'd sooner not have the driver
guess at a layout.

Devin
