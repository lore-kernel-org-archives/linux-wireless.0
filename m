Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805A93AE18D
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2026 23:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235034; cv=none; b=l8i3AHR58R8+uyqXlJjDqwv2xcHELSB+ZNyJSfqzNl22xtNEI9nTL1mD6P7GRSx2Qz/jCLRCcmw9RkBOMmnmB1EKDoc9aNZdMyK66/2nXykS8fbNxVdGv8Zhu0zQGs4Dp2Fva2Sf3NwVHsvj+c6f8hDWiaRAutKzrP7arUlbjp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235034; c=relaxed/simple;
	bh=jEJkEfzpBy9lifKdSxGyGunNvOCakM3NHg+jG84/xf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he8IJVMvqopBoerpUa0du5uZioLRkM7Gft0LZUgaABtW27HXXTVD7i6NDxgEDp1Oz0ENbOR5LDaaI2oprBEbb95L+bBC+2f3/BW7yXhYGv5MBunockX+TFNZQpv2LYmFH4pa2Q32DvBEgslEXh+hnw/6z8oLkRk2KhIeMzHthvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=AQVv+R6K; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="AQVv+R6K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1779235020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jEJkEfzpBy9lifKdSxGyGunNvOCakM3NHg+jG84/xf0=;
	b=AQVv+R6K8uJ+e0jUzrVfyF5ETUdNEw2K9udtrb43kPqQTb5ei9/nYch3dpPRyWsYfzXqIf
	9cNMNDqznoxcYSv45blU/XWzJxlGu/1rNL3U/BpkFaeEZYJy37rICQAyl8RCdEMm4ip0hf
	fkaunYNBZWXOXgIcYQYPDT6fnpEa5O6knGumCWdVpL2vph8f3RLYU+gY5VNSKJwua3iqgp
	9X+wzJTL5unGZd4u2vC86B7/K16rvujKjxhmmyDpi/Q+N7hKrN3UaxDXspqrN1nEd1YiZs
	AnZHXcKyDWwdQnxcprD0FeQCRGIk2X/UcgBIXrjxutFlYXxWbq4dzxeUgGiT6g==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>,
	fjhhz1997@gmail.com
Subject: Re: [PATCH v3] wifi: mac80211: fix monitor mode frame capture for real chanctx drivers
Date: Tue, 19 May 2026 16:56:55 -0700
Message-ID: <20260519235655.49034-1-lucid_duck@justthetip.ca>
In-Reply-To: <58d6ee4054473af391eb5ae8b4382e6964dc3ab6.camel@sipsolutions.net>
References: <20260518170147.13885-1-lucid_duck@justthetip.ca> <58d6ee4054473af391eb5ae8b4382e6964dc3ab6.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Johannes,

Apologies for the nesting -- I'll keep replies top-level from here.

On 19 May 2026 00:02 (CEST), Johannes Berg wrote:
> I'm sure we can basically get rid of the "emulate" check now

Agreed. v4 will drop it.

> So what changed? Could you do some investigation if mt76 got bugfixes
> in this area perhaps? Or are you just using slightly different devices
> than Oscar?

Same chip family. Oscar's MT7921U/MT7921AUN (0e8d:7961) matches my v3
rigs (mt7921e PCIe, mt7921u USB, Kali VM with MT7921U passthrough).

mt76 has had three chanctx-touching commits since 2025-12-16 (de62b24224ac
"abort ROC on chanctx changes", f0fb9afb74ec "check chanctx before
restoring channel after ROC", 381733b3a14a "nullfunc PS on offchannel
transitions"). None touches ieee80211_monitor_start_xmit or the
chanctx_list lookup v3 does.

I think it's the reproducer environment. Back in March I matched Oscar's
stack -- Kali 6.18.12, fjh1997 v2 applied, MT7921U passthrough, airgeddon
evil twin, aireplay-ng deauth into the monitor VIF. No crash. The one
variable I couldn't match was the hypervisor: I used QEMU/KVM, Oscar
hasn't said. The symptoms (instant VM freeze on deauth start) read more
like a hypervisor USB-proxy stall than a kernel hang.

I'll send v4 with the collapse.

Devin
