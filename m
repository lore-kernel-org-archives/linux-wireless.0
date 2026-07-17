Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A9B1E511;
	Fri, 17 Jul 2026 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784251439; cv=none; b=rrXrcc/uIbJJcFu7v1O1n0fRFOTCBWqtlnJWgZNNeVW1DguCBQLf8X3lWAqMTyR1DK/Wnu1gP7OEsXDy8JRqicpuOjkx3J5ZmXHSM4EDgcgKLFw/LZ/wqILlUrKQwbJFdlGVFfH78aE57B+++xXOZGWL0m9b5sYkKxlKTpYUamk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784251439; c=relaxed/simple;
	bh=Y1rwyudTopHEsuuUJ8qlzz3q263qhRB6UWGjlEGcZRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RWATWI8ufsYJHLBe6qOuTRp5AbmgrhzfHJffR39bwZd6U9Hz56/9flHEUHhF+wBF5cCeh2SjNR4DpmcSI1XOG/kamNtup1nwiy7N0+G1lkn03z0ewAgkgbB7iG1CRBC9uvpjqLaVOR3d25vyk0dM+r//PTyCGVnQ/l1pCASLlzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OvZwfedA; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OvZwfedA"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H1NqFT24037274, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784251432; bh=Y1rwyudTopHEsuuUJ8qlzz3q263qhRB6UWGjlEGcZRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OvZwfedAGW4Xt1FXwZm0HXHlXsFa8xJA7HrT/q2AIUS85yR81+4vRB2k8K1aaCql2
	 58pv6+jCruuTBNfl0vq3E84wEa32l8n7Kl2pOqKXG1xD0xsiYbkoYc74LSOyFD9c5l
	 hywO2nifGJs6l7HXfxO3qa604+DbwLxmjOnXptLnLsnpCFHnztdVIhIscd5OfHl/YF
	 d2swYQPTBR0ffh1lyHmGVhxD1KOggg7Bseijl9eYYe2+RJ1FbFBBvc59oi72YxWJ2v
	 zxEqXWyTjP0Iokoletx++5rfSwIq8z+VVUQd4UP+xvak2Es/grrgfnWBmLE51KVqqX
	 UdK7wMHjQL6IQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H1NqFT24037274
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 09:23:52 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 09:23:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 09:23:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 17 Jul 2026 09:23:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Louis Kotze <loukot@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] wifi: rtw89: advertise WFA-certified EHT capabilities
 for 8922a
Thread-Topic: [PATCH 0/4] wifi: rtw89: advertise WFA-certified EHT
 capabilities for 8922a
Thread-Index: AQHc24E+LCWBeDxCEkyQ4AMls4NF7bYAs9gggGQrSACADHRN0A==
Date: Fri, 17 Jul 2026 01:23:52 +0000
Message-ID: <b998ea41f3c8493faea09203be3275c6@realtek.com>
References: <cover.1777832019.git.loukot@gmail.com>
 <7e092f6cf82c4bb18b59ba5eca40dbb5@realtek.com>
 <20260709103138.1269594-1-loukot@gmail.com>
In-Reply-To: <20260709103138.1269594-1-loukot@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Louis Kotze <loukot@gmail.com> wrote:
> Only the EML capabilities patch has an explicit improvement: in A/B
> testing on my RTL8922AU against a TP-Link Deco BE63, ML association
> without it came up with a single link, and with it both the 5 GHz
> and 6 GHz links are set up (debugfs link-1/link-2, active_links
> behaving as expected for EMLSR), stable across 60+ hour soaks. The
> other three were no-regression only, which is part of why v2 drops
> them.

It is also like other features.=20

With this declaration, it will handshake two links in protocol point
of view, so you can see two links in debugfs, but actually it operates
on one of the links since driver isn't implemented to configure
hardware and firmware.=20

> v2 is therefore that single patch, and follows.

So, I'd defer this patch. Internally, we are still cooking to enable
this feature.

Ping-Ke

