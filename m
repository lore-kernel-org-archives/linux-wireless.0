Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9A1A680C
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 07:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788593880; cv=none; b=G0ovdHKbi0lgG5MrqQObXtHjbHB7YqxO/UZmMcAyVLferoewZFNGHsdS2r8bOk1p15yBEPjs62zTCgo3Z8IzAlQb8SQLCvKDYz9aeidAOZTiKQfYmhBLpJoPt4OHIoj2JLfw+Sg7jFaxb7IMyjNc40a+Hdgc5P3cAtqSrSC8Zoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788593880; c=relaxed/simple;
	bh=0SkyVKSH31057q08Z6yPO6FAD7RhHFBkie3SGBwL48U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJoqAtngqXOE4/Nt8Yh8cVrlSAyM51RomQkLzxGIcWxqnv2Mm7WJsSdW8auuWfT8GwvCt+5ImgRASf07vajDZxHcloWtNMnwXst0TV2Ml7zv0luTYvTlrWkFiPyhTA7aveFgHeTQmMzMe/yib52R8FVejaGR/2pPdngf83nVklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=Xb6yrs6J; arc=none smtp.client-ip=91.218.175.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="Xb6yrs6J"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0SkyVKSH31057q08Z6yPO6FAD7RhHFBkie3SGBwL48U=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788593874; v=1; x=1789198674;
 b=Xb6yrs6JV34jJVDCPkp/reMWETnAehaNbNMsDOGJS0Jo7h3tuczT6qDEwB1zoXdQc1vIeUto
 QZ5hqKlZ5ioZ4e4RXcPOCdXuDlkb6YlRNQ9eGtvcERNH+jy+R+Kcgna2FUZUYg271hD2CRoWN+S
 ypPnLm/A+aIp+JZVpX/mWFiOCsl0CaW0ACG0C18sbzwCGSDst50PHM/Ba8GGEF3BcgIE9Z/S/rd
 t8HKQ24QcVXAdELhou/qouRDrHOczPfa5Q5z/yRNAIeVcqbuLZrzkuREM0s+zNYWY0K7NZ95thr
 V1y1E8LzIyjjwwyybMkfB+/3/wKggA58WwqJKlR9e6MOA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3b9b8b6c6d283ace;
	Sat, 05 Sep 2026 07:37:54 +0000
X-Mizu-Trace-ID: 3b9b8b6c6d283ace
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sagun Kayastha <sgn.kayastha@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH wireless v2] wifi: mt76: mt792x: pick the SAR table layout from the table itself
Date: Sat,  5 Sep 2026 00:37:51 -0700
Message-ID: <20260905073751.32850-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905013551.24635-1-lucid_duck@justthetip.ca>
References: <20260905013551.24635-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sagun tested v2 on the GA503RM, the machine these tables came from. Both parse
as v2 and the FCC row reads. Transmit power goes from a flat 2 dBm to the 14.5
the table holds. His numbers are on the issue:

https://github.com/morrownr/mt76/issues/62#issuecomment-5550016870

He also notes the 5 GHz CCK row rising, 36 to 56 against an EEPROM 32. It reads
36 here with and without the patch, so the excess is not new. CCK is not sent on
5 GHz and 2.4 GHz is unaffected.

Tested-by: Sagun Kayastha <sgn.kayastha@gmail.com>

Devin
