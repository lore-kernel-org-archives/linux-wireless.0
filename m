Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861495;
	b=Ndyzg1fx1n4GMKD7bSmGTGUgWyaJa3xTfUNJyzWa2TdEh9B5VbBG9mExenQcYtmE/ebJ
	 Z236BJ3eFszXie0o/9WM3XzTThVFuxTv/1Ib8em66L3//9EmoczTWeoivHM1qecwvPDqW
	 pv/5++gsl4IXAWr+mTnPOZzuEdBQtGa4oFz9DL+N1SEz03RwAc3gF7hjPZYC0r7GVhIi/
	 CZvBmAgJYcl0MGyXSmAR5tJ2etjefx9Pi+axkocbL14DbDraX077uYnDyFhxnZoDO29mW
	 Sy87wMSaKce2ROfnKj0z/M/QkYmOHMnXTcQy5mk5el2dkLvAPqiUhRLt2JEHqeIsg5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861495;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iXZRs5L0BEPW07OJnE4hXrMgoGB6nXyoylaVSM8yvEI=;
	b=V5T6rZHDL4d349/nfEBeexcnGgp6mgSwo0/aA4ORWCq+43pXjtpILc6jx35WV9KWVR7a
	 qhadttRVsMssiD/rpiGOLvHci8jqm0Rie54vENAMwmDJw4usK59z1qvKCcg5NyyoIAF32
	 Zy0VvmCeufC5yK6ucsacDT5lgnSvf8KESWZmyJZyuUudieGW79WoT+38YKZQTZkAqlTT/
	 7lcVtGZ5QD0PM/RptM/znhZcur0p8BUm0tE4g9mMaBjBN5WyeYAcnJ22HD9nJ4sSMHLEq
	 IaQylJ3BF5zaZWrr+owPpebGDcsmzl4LXWGUa0IDZcJR4sbVNUSmuuxJ5bTYvEjD5eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=sh7N1C24;
	arc=none smtp.remote-ip=91.218.175.35
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC86606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 06:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AC86606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=sh7N1C24
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cW+1Fu8aETnGoEi3UV7T3MY47dOgL+uKiztr+hDrDjg=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861492; v=1; x=1794466292;
 b=sh7N1C24tU/8ysQc45ganF0pzLfV6X25rVW7+gw8T5TzwSOiV1Wwixvuzy/nJzGD5zj5ABPW
 zrpK66/rtRTkUtpXuRe6p7y0s/li8swSn7GHe4I/m9y6Y93785lZZYP/LO//q3dV20W4QrjNvPi
 lHuskFCz+acRncTqbPHLPmn8TlwQsPJfozuENN6MVZvsxpun0CFQfuLnT1DoIwlRZxSfMa7BJxD
 Meu10JZ1FvE7A6+0IGEgpWu2eKSbv4Cmdz5H/9W1cNxdOJi8ZsPTEbZyJlJaVitMNG4ZO5InXCv
 /Bf4EuJYxTG3r7P90cycICbFXcl1Vy8eWAVPDWpjzFkXg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id a027a634dc82f0a4;
	Thu, 05 Nov 2026 06:51:31 +0000
X-Mizu-Trace-ID: a027a634dc82f0a4
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Aaron Beckendorf <albecken@mtu.edu>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2] wifi: mt76: connac: honour injected HT/VHT rate and bandwidth
Date: Wed,  4 Nov 2026 23:51:26 -0700
Message-ID: <20261105065126.1041-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.50.0.windows.2
In-Reply-To: <20261104142737.186484-1-albecken@mtu.edu>
References: <20261104142737.186484-1-albecken@mtu.edu>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 09:26:22AM -0500, Aaron Beckendorf wrote:
> This makes 20/40/80 MHz HT/VHT injection work on mt7921u. mt7925 and
> mt7996 build their own TX descriptor and are not affected.

Ran v2 through the same test, MT7921AU injecting and MT7922 capturing,
100 frames per case, two runs:

  requested                    stock      v2
  HT MCS 0 (20), 7 (20/40)     6 Mbit/s   as requested
  HT MCS 8 (20), 15 (20/40)    6 Mbit/s   as requested
  VHT MCS 0 (80), 9 (40/80)    6 Mbit/s   as requested
  VHT MCS 7 x 2 (80)           6 Mbit/s   as requested

An MT7925U still injects at 6 Mbit/s with v2, as you say. 160 MHz
isn't covered.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # MT7921AU

Thanks for the quick v2 :)
