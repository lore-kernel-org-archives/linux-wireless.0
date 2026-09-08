Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99B582B97
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788885394; cv=none; b=LEBvqMcMP9lM2fWsTfibckH3ohvfw4ciBbEKEzJYXUSoFw9hzsdCW+koZGc7sgxl4Ot4ck0OFEIQu/uasWn6Da6IhVnOIkGczQwol4iVbOdSNOT9P1l2wLTqs9UEDmHwNjpCqIdhTM7EVmQsXOccuZnQ7PgeQDB794BRBh2cYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788885394; c=relaxed/simple;
	bh=dP/cjZy8ldnqq1PjpLbkEAGsTOME3zjuGeluM6xHCm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIOyNRDGpbgeZ0QxjwJeUoefTW60LxJ67QRhEWEMI2S/Mev6c5YjlBvuYcf+xBVlinNQSFFzet4cCSKCXHhI/UvkbHk5PXsez41CXe3gmpNQKpBkjPnoilruPuftXK8iFIcF9XWtftJmohQcKZICOD/KNAhwuKsRkhXvuJlwY98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=HFXzYZvh; arc=none smtp.client-ip=95.215.58.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="HFXzYZvh"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dP/cjZy8ldnqq1PjpLbkEAGsTOME3zjuGeluM6xHCm4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788885388; v=1; x=1789490188;
 b=HFXzYZvh6WXQ6mYwxrfrLLdBLSz/9PtXDx3j6sJ6ryZq+YZ6QYIcVXsdxzk4t2R3IRWqKbXA
 PQI+ZrhKDiYudQ7nYBlzyofQg8vwWT6VFGhxdM5eYpbnR+cdBiBBINXMarpelkNKPu1tBX3NnRW
 LKvTEbzCbFspV5QdzLVGBPjaPswIhtHWF1ayi6FLhnu9qQN63M4W9yzpujzLViBXZ9+ar3M1E4B
 s22vcE4U38hkANICS83rbuS4cBNfP8BV9D5bI1aDGTIt39vvl7ZIQ5K73PYlVAzmzO1Nd/al6+Q
 VT68p+X9dDXSq5fgt1CSjdINzlIQzqWkm55hNCJ/BbEcw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ba30160a00438295;
	Tue, 08 Sep 2026 16:36:18 +0000
X-Mizu-Trace-ID: ba30160a00438295
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	kun.wu@mediatek.com,
	deren.wu@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>,
	quan.zhou@mediatek.com,
	Ryder Lee <ryder.lee@mediatek.com>,
	leon.yen@mediatek.com,
	litien.chang@mediatek.com,
	jb.tsai@mediatek.com,
	Sergei Melnichenko <sergei.melnichenko@gmail.com>,
	Hans Buchheim <hbuchheim@gmail.com>
Subject: Re: [PATCH v4 2/2] wifi: mt76: fix memory leak in USB TX path
Date: Tue,  8 Sep 2026 09:36:14 -0700
Message-ID: <20260908163614.7138-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827083526.1621600-3-eason.lai@mediatek.com>
References: <20260827083526.1621600-3-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 27 Aug 2026 01:35:26 -0700, Eason Lai wrote:
> Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> Closes: https://github.com/morrownr/mt76/issues/83
> Signed-off-by: Eason Lai <eason.lai@mediatek.com>

Eason,

Thank you for carrying this through four revisions.

The issue in the Closes line was reported by Sergei Melnichenko, with the
stack capture that narrowed it to the USB TX path. He asked to be credited:

Reported-by: Sergei Melnichenko <sergei.melnichenko@gmail.com>

Hans Buchheim's Tested-by from 1 September is on this thread as well.

Devin
