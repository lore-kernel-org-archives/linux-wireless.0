Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD2F34CFC5
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787937536; cv=none; b=AlPzPAkMnTc0cmF7/Qt+WSzrojn0Hp82qTBb1Dd+UoR5RSmcuOctSF3WJfYQ+uyKKRaeJdQy6sOt6UyC9Ut0CipEMeDL3p+zaJ3nk9Qg8z1aFznXi8gE9YDxT0SNRLRyuOJ5jGuyFkzqX6WnwpgdvJPeREVo9HJbro4E3CjZEoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787937536; c=relaxed/simple;
	bh=JSBFu5mtYAAxSf1z/Sc5HZpi1iqCxqQNp9ErZEemACM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1VDHBdATdYBmL9loZtpT/wx8xvEvAHRAF6oinQ2NV5yfimd09oUAY8P2OQip6z0RAdrfqvfkkNRNdNkbh0EBw2NcZVTnLc/r38Z3wkFS+TVrUREO7ydDoKKXLm7xUKwNoitd6ULQJS5X5nzHLzVYy+aHtFREO0rEqcUFw4vv3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=KKmmhBM6; arc=none smtp.client-ip=95.215.58.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="KKmmhBM6"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JSBFu5mtYAAxSf1z/Sc5HZpi1iqCxqQNp9ErZEemACM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787937531; v=1; x=1788542331;
 b=KKmmhBM68x9yX1z07xOBrJk7YoG6eEoRl07hBiBVXSeVTOslr21mNeBO77Bb3mX2w8hPjKFU
 l+/BSQVLmz7cjNYc18NAh8frF8MJ9NdQV5aFtF73nBJLMO9fWB/yMFhekKafa58Ly+eYv0ZGUN2
 E89bI+wbgj2SRuJQl3w8VIK3fF/eRkw2iHtvAL2s5wfIjbwB2zmzYabW8RR/t3OST6k1Jb5bjLe
 cX/MrtsVfAlZNzDm3avsJuE0zYhtir/1gflBr5iF5t/mWQ5/AqdnI7xkGafptVMvSwUpmBJSBK2
 r/w12R1CgzvYRQO8aDWMQijZl+DsjCkDccGydAOW5wA+w==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3182c772a689ec26;
	Fri, 28 Aug 2026 17:18:41 +0000
X-Mizu-Trace-ID: 3182c772a689ec26
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Klara Modin <klarasmodin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	regressions@lists.linux.dev
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: fix NULL dereference in ACPI SAR init during probe
Date: Fri, 28 Aug 2026 10:18:38 -0700
Message-ID: <20260828171838.22038-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <apGWXuPOSqZJ_ShO@parmesan.int.kasm.eu>
References: <20260825181712.28548-1-lucid_duck@justthetip.ca> <ao3dyqWJ3nf3rMMW@soda.int.kasm.eu> <20260828011737.22809-1-lucid_duck@justthetip.ca> <apGWXuPOSqZJ_ShO@parmesan.int.kasm.eu>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026-08-28 15:27:10 +0000, Klara Modin wrote:
> Wouldn't the Intel 11th generation have come with the Intel AX201 or
> AX210 originally?

It would, and thanks for the correction. This board's firmware carries
Intel's wireless power methods and none of MediaTek's four. I put an
MT7927 in it recently and the MediaTek ones did not appear, so they do
not come with the card.

> I don't think so (if this is the MTGS table above?), but I don't really
> know how to parse the table contents.

That is the right table, and nothing in it is padded. Yours is fine.

> so the transmit power limits actually look like they are too high for
> some bands, especially 5735-5835, but maybe it will limit to the AP
> transmit power and be fine? However, according to `iw list` the channels
> in 5735-5835 do not have the "no IR" flag, so in AP mode the card could
> potentially transmit ~8 times the allowed power (I would rather not test
> this)?

Every line reads the same because the driver writes the same number into
all of them:

	/* not used by fw */
	rule->power_rule.max_antenna_gain = DBI_TO_MBI(6);
	rule->power_rule.max_eirp = DBM_TO_MBM(22);

It is a placeholder rather than anything the card sent up, which is why
the same twenty-two turns up under every country code and not only
yours. So it is not evidence of what the radio will do in that band, in
either direction. The card has a power table of its own, separate from
this one, and debugfs shows it as txpower_sku.

> The 5710-5735 range is also not covered, which results in 5 GHz channel
> 144 being disabled (visible in `iw list`).

That hole is in what the card replied with. The driver copies the ranges
across untouched, so 144 goes with it.

Devin
