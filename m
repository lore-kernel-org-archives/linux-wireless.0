Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [129.187.255.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A042FCAD;
	Thu, 16 Jul 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784220112; cv=none; b=LA6tYB2AkCILARW3jV+Ooc/+ehdQ7eVyY2q/v1V37VF/yhG8UTQvLNy5wKWTmkMe7Be2wu7sLwdcG39ZOPAwzvdj2FS6+hFmianCFAtqxyOrPGH1gJPyMA5JVFj4LXVRh8kYsRvsOcV56XmpfC2xq/iG5lOrDaiM9OEinyrpC9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784220112; c=relaxed/simple;
	bh=GsjqK00vty3gLiC6+1ggvcMs8Ih99rPRxq6K3Aa/nSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsQvd05Khc85zYaAedZNSKAseFQX4l60Ql3I8WWp6YeEr/HMmcOHtNxplWDyT2Cd8lDWo+XyLNvbTX4I9RkeMu/xhLt4QzkXOlvQ6NrU82K+2d8sjfovtuWSxmfF7p44/bfZ24E7tD+DmyCa5STGMbWVCvIQFqmmJSJYCJU81D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=JPyKgsV2; arc=none smtp.client-ip=129.187.255.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="JPyKgsV2"
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout1.mail.lrz.de (Postfix) with ESMTP id 4h1Jhy0c2kzyV3;
	Thu, 16 Jul 2026 18:41:38 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784220097; bh=GsjqK00vty3
	gLiC6+1ggvcMs8Ih99rPRxq6K3Aa/nSU=; b=JPyKgsV27ZIYlIX4MO26HkXLei1
	SKQl3iPx1+R5utAqLRMjkDRnE9wH1mNm9fq4IP5pjZWCd39HhDSCxjGhnyDdX/nJ
	gImcZ0FzDKlOBXfTxEECFJ8RsnzV3+8nFQ/iOgi5Qp86ShaJT8hVPLK5IDwdR9RQ
	HBFt9lBVZRy1cFHXzK72FaNGrFnNbsQOxGVwJtB08U84tZq/3VjR6cPp+MKqoKlU
	ze8VPrKUWsrZA1vLSaHi+NU8MKjmo4eN8RE8tWl2TJWSTyJnmoQR4AVz2EFpVgCM
	QdYyufJRjN9y2q+vBldVwAh1WdqfNKvDydreR50ZbPzrfEGxleuY2v4+qTg==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.886
X-Spam-Level:
Received: from postout1.mail.lrz.de ([127.0.0.1])
 by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id hyvuV5U-DyrD; Thu, 16 Jul 2026 18:41:37 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4h1Jhx05SyzySF;
	Thu, 16 Jul 2026 18:41:36 +0200 (CEST)
From: Simon Dietz <dietz23838@hs-ansbach.de>
To: simon.dietz@plantwatch.de
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	dietz23838@hs-ansbach.de,
	edumazet@google.com,
	johannes@sipsolutions.net,
	kuniyu@google.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v0 6/6] net: apply RCS to GeoNetworking
Date: Thu, 16 Jul 2026 18:39:55 +0200
Message-ID: <20260716163955.3709443-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716162152.3616762-1-dietz23838@hs-ansbach.de>
References: <20260716162152.3616762-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I am sorry for the now misformatted patch series tree and for the
partial transmission of this patch series. It turned out that because
I used git send-email --dry-run before actually sending the patch
series, which drained the email send limit per hour of my mail/hosting
provider. I now use(d) my university email address, which enforces a
(much higher) daily email send limit, instead and it worked. I hope
not to have caused too much inconvenience.

Simon
