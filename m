Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4108F328B5E
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778529865; cv=none; b=SCqEMCpKOsZMwRTyfuyK72d6ltYishBwQT0NdahlSDH4nQTLw3Ir7gseNW6VYep7d/QiWz61m/dQ4/vQmX+HRz3mcq3b6E0h+Vx7t/WO/hi642+3I7dUHVg1/FnqDxBdfE6DAOUrC8pDQbBNbbtvi5Wd2rXBpz9Ja8bnqWQbGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778529865; c=relaxed/simple;
	bh=dA6hLylhlWosG7c58rSUqa8iEFQ5WzADGJf5YNAzqsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ8OgqmZq8TXOg3k89hruuTln5XPhhLEbCtghjwB28MfNf4JgD8Cb6ZQnls2sHy2pCRALJrhUPtANVP5u/jQT6M5Xp1z0qx23I3kWY6WosB4tdf5t/Z+6GaDh8Y80GJ6CPWWERLS5PxDaAy+s46CCyNsh6ZBv8DqZmu68FcEAUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=qVYKb7L+; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="qVYKb7L+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1778529860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dA6hLylhlWosG7c58rSUqa8iEFQ5WzADGJf5YNAzqsQ=;
	b=qVYKb7L+oXZowLz+oOsDu9EETXd2eTWNi6ryCVe9XEWlWJZPM/4nNsWW1Ejlxs0goRmVVT
	D8W6OVFO1KXDoYS2xHq5Zo71a+QlhPsOuMrF3HcENUn/an3ylxCHXsbewkKrsWPPkJPtn7
	R7H2CM/BAz37XUmgzE20v4+0mctb6vG4CBdhh+D2UhEzWW/zkEhapnohVKF/7cE0waj6pw
	ZGTw17XmaK7KIk3LWGKlevHa6Vx8tEyc4H8QIbBmZC9OS3n1LD361307EPdfWvqZmsHs81
	NmMXxU0HcILtLbHhKGGqU5GjUoaRqzTlyC7C4fdNxS7MgWY7i8Ag2pkNavl93g==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: rtl8821cerfe2@gmail.com,
	linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: Re: [PATCH rtw-next v2 1/1] wifi: rtw89: usb: Support switching to USB 3 mode
Date: Mon, 11 May 2026 13:03:39 -0700
Message-ID: <20260511200339.33682-1-lucid_duck@justthetip.ca>
In-Reply-To: <639b2f23-bff3-400f-b5ef-e7d0c39196bc@gmail.com>
References: <639b2f23-bff3-400f-b5ef-e7d0c39196bc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 2026-05-11 at 21:14 +0300, Bitterblue Smith wrote:
> Are you quite sure you tested this?

Yes. Full test matrix is in the v2 cover letter (PATCH 0/1) of
this series:

- DWA-X1850 A1 / B1 (RTL8852AU)
- BrosTrend AX1L / AX4L (RTL8852BU)
- BrosTrend AX8L / EDUP AXE5400 (RTL8852CU)

Six adapters, x86_64 Tiger Lake xHCI + aarch64 BCM2712 / RP1 hosts.
60 plug-cycles + 30+ throughput cells captured 2026-04-11 to
2026-05-07. USB enumeration verified at SuperSpeed (5000 Mbps) on
every patched cell.

Per-cell raw evidence for the May 2026 expanded matrix (40 iperf3
JSON files per cell, byte-counter deltas, pre/post link state,
pre/post USB enumeration speeds, per-iteration timestamps) at:

https://github.com/Lucid-Duck/rtw89-usb3-gap/tree/main/evidence/may-2026-laptop

Per-adapter summaries:

https://github.com/Lucid-Duck/rtw89-usb3-gap/tree/main/adapters

If the Tested-by trailer should be annotated with the specific chip
list, I will add that when, and if, a v3 is needed.

Devin
