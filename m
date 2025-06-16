Received: from mail-out.aladdin-rd.ru (mail-out.aladdin-rd.ru [91.199.251.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7027C17E;
	Mon, 16 Jun 2025 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.199.251.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750069595; cv=none; b=aDXA4GENlUPoZgoaR5GEGJUYhlueveYYFCcXB5rpnSMAxids1ORrpIQAxTTaGHDvP1CGFK8NFjN7XLOxzrffmMxagmjYkBFgz6BDbacNaXXwC5FFwcW9pvQD0ALzMdE8uW+hOv7Eo/4PyxxmdE9N9SNkPVK8vr2YFE8nH2m+cdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750069595; c=relaxed/simple;
	bh=p5V3NeMhaVAyrVRK6kJ65TiSi6oSqVC/2CYBI6Ce9hg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RBqygFdGz8ud7y6cXRXS+92VmtKC2lQHNLAzQUnXEDIkn+jKqGCZeaZfgx6SQomyXE9zeh9+OG6NCyKy5KJaS5UPtB/2eyrWjEAUL+ZXbZeN6d8izst8qp66/907r2sIDjyE/cS07cCYHU+ZS1uu33Q6U8ocmzKDnLYYfoh4gyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru; spf=pass smtp.mailfrom=aladdin.ru; dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b=meDCRmI1; arc=none smtp.client-ip=91.199.251.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b="meDCRmI1"
DKIM-Signature: v=1; a=rsa-sha256; d=aladdin.ru; s=mail; c=simple/simple;
	t=1750068662; h=from:subject:to:date:message-id;
	bh=p5V3NeMhaVAyrVRK6kJ65TiSi6oSqVC/2CYBI6Ce9hg=;
	b=meDCRmI1JukQ2ShLiyswV02cW2QKAQOAl3cyNQ0Ft9WgpaCTaG/0ybqVYdjRKMNEdgiHVqN58D9
	Ejd28rbQUh6s3y5OHPrT4jwwn9TO4mn12wRCMXjnTUAm2DxBO6Rkz2yhAQCgI6QL69vM+xlWDKJO9
	RTlpZ5YRGrNI/24PpiR+1gZnwvdbsDL2BuS65G2/4+xlSs4LgDYKnnoEiRVcXN0hEDPX5RnhvUaJR
	9vZqe0rPm3v1DKmp4+qa+DdU2BFizkMrAJDBw99vOUmtPkqfWkcrQz7/bAdygKX7VbOsyWeBeqKsR
	cNv8FkUJK6uYSLr/JGGy2qb/9WwXSm1+tdmw==
From: Daniil Dulov <d.dulov@aladdin.ru>
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Daniil Dulov <d.dulov@aladdin.ru>, Larry Finger
	<Larry.Finger@lwfinger.net>, "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH 0/2] rtl818x: enhance skb/urb management
Date: Mon, 16 Jun 2025 13:10:48 +0300
Message-ID: <20250616101050.6911-1-d.dulov@aladdin.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EXCH-2016-03.aladdin.ru (192.168.1.103) To
 EXCH-2016-01.aladdin.ru (192.168.1.101)

This series of patches is aiming to enhance skb/urb management at rtl818x.

The first patch of the series fixes data race in rtl8187_tx_cb() by acquiring
the queue lock before any work with the queue is done.

The second patch of the series enhances data race protection by killing URBs
before clearing skb queue, thus preventing callbacks from referencing an
already freed skb. 

Daniil Dulov (2):
  rtl818x: Fix potential data race in rtl8187_tx_cb()
  rtl818x: Kill URBs before clearing tx status queue

 .../net/wireless/realtek/rtl818x/rtl8187/dev.c  | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

-- 
2.34.1

