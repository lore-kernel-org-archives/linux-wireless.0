Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C8533B6D1
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 05:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019426; cv=none; b=k6qJLYefuev/WJeJvq6Dl58q7o9vhRQjDjL0upXbWck1rbdjf+06siKDC8jP0gAJ3WZh/UTtIvV29FZDTq8hSuVJgkQazM+j2TU/SMlLrzkBrynsd/WJwn1fcfpVL9jEAXzyIeP53oXskYD7HKypXH0Xa1ML4bO9V9g9sl7AGBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019426; c=relaxed/simple;
	bh=I60LEn5/Mzazp2b2S6DVaA+RZTEyiJBJ4d6HIGTlKOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaZSfxI/ntsm99GYtA0SQ24G+fmbBd5Hc8Kg8tOKvBl9wWv8JB/IuWz4op+/4swOWgt7FrPuofN1YUtG483G87R1DzWSokfyrZb8sF6AhjeVAHfOlguDeDnEhYJJcM6anXitmjdKMzvSPPTiwDtRU4YPzhFezlS8WN78mPUU3DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=CAAVZ0mE; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="CAAVZ0mE"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=I60LEn5/Mzazp2b2S6DVaA+RZTEyiJBJ4d6HIGTlKOY=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789019421; v=1; x=1789624221;
 b=CAAVZ0mEhvJwyGqXw8UAGDCt77R35/lIERLviaMoS7+X353uXX4svf1rFvRqnGo2a/4fnt2g
 SPKFTDh/D3g3/ujqumEy2UlzQuuILa3nUqy+ZZkoUDERTdAYih8UUlT31xBG9U01Wd+th+R0XMm
 3ZXo/qNqUqnOEqgY9vPvPxE8nzLxlBR+L4DbQeoRg5krrW/Pa0te/OeMdn8BlHbhIlVxGDYowpC
 hK2uSPURyAImOmMqjCU1P6VajLaxFAsPEDh7RAk12OeD79ZiNaEjiJ9rZd8VY4PQzntWaLGVMDC
 LTePnVQzrK8WVE96TRGEXn/MxMOTXZD/Qiv1WKalnpBoA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a7c6833e348f136f;
	Thu, 10 Sep 2026 05:50:21 +0000
X-Mizu-Trace-ID: a7c6833e348f136f
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: moosager <moosager90@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: mt7921e: failure to reset causes network drop
Date: Wed,  9 Sep 2026 22:50:18 -0700
Message-ID: <20260910055018.29328-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anG46qbvCqCHGF-f@fedora.fritz.box>
References: <anG46qbvCqCHGF-f@fedora.fritz.box>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

moosager,

Sorry this sat so long. You were right about the unchecked return. There
is a patch for it that the maintainer has taken, though it has not reached
a release yet:

    14739102  mt7921: check drv_pmctrl return in the PCIe reset path
    14739848  mt7925, same

It sits downstream of your bad read though, so it will not stop the
register going wrong in the first place.

On debugging further, I had the same ownership handshake fail on a mini
PC here. What that ruled out, so you can skip them: in-tree against
out-of-tree builds, a PCI bus reset, remove and rescan, and a cold boot.
The Bluetooth half of the same chip kept working throughout, so the
silicon was alive and only the WiFi side was stuck.

Devin
