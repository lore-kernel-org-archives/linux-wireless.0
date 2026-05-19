Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EE0318BA7;
	Tue, 19 May 2026 23:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235042; cv=none; b=fwiBwxZI2f4Uk4JC06MRbSOLza1/Wh8EDMgxRj3mVoQRvwxA/U9oAYA5AdbqZ6/P2K+Do65443NREWHJ0tJ+/EW/RxcPeoC4wyz4lxgDTNtQQX/WqsDlZnjxFGHOcEVoFECiUsNSrYSxi7rNanKpU6IirwDmjn2+a8XIR45H1Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235042; c=relaxed/simple;
	bh=2YKnQLvLTnXZy4wPB9Rd35JVzM/zZiTSGaUX4IkD1sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSkaqtQEJsTJdAjgZ3ygFekRjUgblYsDNuh7R0livNZEJBARRfRMROAYpjzoEMIvh3SG7z/BWBs1LSzETKIPYhlYfgaey1u2zyl45z1jAUwNollkGikr7Aat0+/kVnL/8Ym3tisqEszPIe/4L0O9ce5Iy/XOrpVnu4MZnQd6G/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=cvyCDM5R; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="cvyCDM5R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1779235039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=REyrfv14Ul92Z0QoHqcUHp7zy5LrCfLs+D7Qmc6RaAI=;
	b=cvyCDM5RsqaQyQN8y+SheiY1yuQgiQhO8PR07RVtCu88UBwPPNH04dG3NenMwQRWG6PYHF
	C0RAhtid+9OVlJhqcigznQ1L8AX6PcHYy0rxnWTo3k7AetiGY4s6zj/x82hZwcpi0hqpLl
	UVk+BSks/xW8aBgm6lHXhMXp/u6KD1tgUccjOFrXSouX7JjFaN0eri1/yVKovPWYLLjtsE
	oqexurVOUM76w0IOEZjsl9Wgu+ZkfqLnQVb4z2Qx2YOJPFbLQ6/0LguYrbIbaeDDv7zSND
	G/yg2yyZy8jt5M3jHf9B80LIM72txSeRHnR5KelbaDLk+2Xzxbp4RieHYg3PYQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>,
	fjhhz1997@gmail.com
Subject: [PATCH v4 0/1] wifi: mac80211: fix monitor mode frame capture for real chanctx drivers
Date: Tue, 19 May 2026 16:57:12 -0700
Message-ID: <20260519235713.49109-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260518170147.13885-1-lucid_duck@justthetip.ca>
References: <20260518170147.13885-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v3 [1] kept the existing local->emulate_chanctx branch alongside the
new single-chanctx fallback. Johannes pointed out [2] that emulation
always presents zero or one chanctxs in local->chanctx_list, so the
new fallback handles that path as well. v4 drops the branch.

The real-chanctx TX path is unchanged from v3, so my v3 Tested-by
carries: the airgeddon evil-twin flow on mt7921e PCIe + mt7921u USB
+ Kali VM with MT7921U passthrough still applies.

[1] https://lore.kernel.org/linux-wireless/20260518170147.13885-1-lucid_duck@justthetip.ca/
[2] https://lore.kernel.org/linux-wireless/58d6ee4054473af391eb5ae8b4382e6964dc3ab6.camel@sipsolutions.net/

傅继晗 (1):
  wifi: mac80211: fix monitor mode frame capture for real chanctx drivers

 net/mac80211/tx.c | 16 ++++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)
