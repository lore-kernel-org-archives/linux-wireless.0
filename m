Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865BF1C860C
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 00:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310362; cv=none; b=VeDE6X5DXkqg41YDFu+CUiOtSkZRSlOS9vbmz2BedJg59VF0zT/Dnf79g5ZExeYFnwbsMiok9p70NA9kBkC6A1KyGMfd4/sk34sWpDVY2Xd4q4QHmntUHHllb04rMoyDSoScVsM0nwwf1cU/W2/177v62eq7wvvr1CuDMJlL/9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310362; c=relaxed/simple;
	bh=btGZf0zaEtFcs/VlS0deqYjgdc78yzlXvgTvq5mmoI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iPqPGb5VQxZD52ktXBHIPxLeX8hVuXlRTQ8BItjsxoVKoFqGakjRGjzfne35DwCABBkQWVoeEbU4jY7bozxHTTLWqWkvBXW+v5gSAdbgztmRxK8n/dafMeEJew7N9MdqUW7Ky+u3jv5L11DLN5vK+Pokk2+gRUeaKdqSm8bSXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=lWvGRAxj; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="lWvGRAxj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1781310358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F+40+W/SToROBFqH2IoKRWBn15xftg9kvs9vbYQreMI=;
	b=lWvGRAxjrbmf63WX1cPP4YclnLLLqU2y6UOqv++pURZnMGD8+MYFB0Ib2FLExYsh8f1lzb
	bDmM8L3cP+OMpEEASPIgJ/Cik8yqU3d/ZzZacl+mxduvcXz5+RFAvC+dJCrFFVJ3OP2K/k
	kSKoLzRk9fP8L0KC7bzN79P40kba8m0OZ0QMooRNU5xZ9/27VyBr7QnOXU0ZOrkiBU3iI6
	m9TYqTK/OCMrJwxAXQmPZrM5LYgiNDHQJcbwwNz39/HL+q56I6F6tTySxpFsFkkrG86Yak
	u7sq8htGUWFoZAFQ13BCZhv+u8xne+uEymM+05bdUyjQIQTzh8XzKeafjD3hlw==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH 0/2] wifi: mt76: mt76x02: rx fixes for fcsfail monitor mode
Date: Fri, 12 Jun 2026 17:25:42 -0700
Message-ID: <20260613002544.27750-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Two small mt76x02_mac_process_rx() fixes for monitor mode. Patch 2 adds
the bad-FCS reporting requested in morrownr/mt76 #38; patch 1 drops a
WARN that fires on corrupted frames under the fcsfail filter, which I hit
while reproducing that issue on an MT7612U.

Tested on MT7612U and MT7610U (mt76x2 and mt76x0): in fcsfail monitor
captures on a busy channel, corrupted frames get the radiotap bad-FCS
flag, clean frames are unaffected, and the WARN no longer fires.

Devin Wittmayer (2):
  wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
  wifi: mt76: mt76x02: report rx FCS errors to mac80211

 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


base-commit: 972c4dd19cb92e03d75b66c426cfade07582a1ba
-- 
2.54.0

