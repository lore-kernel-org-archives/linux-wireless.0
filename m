Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C00439FCE;
	Sat, 10 Oct 2026 04:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791606668; cv=none; b=p/y8B+4b+lItYjCiixbhsfr9MLXAWUEhDuz8mVFy87G3ub9BXqeRznTkvlaU29ZYYV96La4eEtMF3/ZX4BjPi4ThRpyIONtfsa4oOrjqkciw654/5JvPMrD28oK9//ubn+lmX47hGnJMdRDOTFXNVVuktZ0rBfZ9mGgfca3hXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791606668; c=relaxed/simple;
	bh=/xD0aF+oIn+JzrhZxLfyr83YXVZs2BQ8+zqCQphUSP0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mk9uPggE3ud4eWkbmEJ91MHCb9+zdzKRdxeYl2iP19SoJywZvFVxIsnOwdiCTu1qmmVewqmJW4e65mNckBl+AuNlQSZ6ziUjtP/YqmHgM18UbRN9emW+Wfjppxhv5sQywbHOwVnWJYf43ohsWZsawmbRnJY8XDYPdRtXVYSmZ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=NSYamK5p; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="NSYamK5p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791606625;
	bh=/Ncv9zDfZXRbn/+vJNMtlW+RkojuExy2lD60H9iiNRg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=NSYamK5pVGLWQNtUyG3o+/Yotwt/6C1n+/lk3Imc632wTiLWM8Ge7+RFMsI0A5gGI
	 gLVnhi4sO8Kz00OJ2by4q0RU3Bjor3nl8hbhV277QbwPFp1qmPeJd5FeQ6RVSVkwXS
	 TFLn6LTMCHLZAF6AYriqnEJJUohNmID3YG2rBK9o=
X-QQ-mid: esmtpgz13t1791606607tee7297f6
X-QQ-Originating-IP: yBpt3uylGUdnyNtdTZCx4ggd3TXHVUJz6pNpVaOKm2U=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 10 Oct 2026 12:30:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16494117288888038311
EX-QQ-RecipientCnt: 6
From: Wentao Guan <guanwentao@uniontech.com>
To: sashal@kernel.org,
	kartikey406@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6.y] wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()
Date: Sat, 10 Oct 2026 12:30:02 +0800
Message-Id: <20261010043002.2919860-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OBpqy79whgIZPjCztq0EkJBZZ51+9TVIWSDJ+sINL750nl8uHLm1S09f
	2OdrTb93c5RvhFfN/BgZWYwBoFASTzYWkfuF9DE7p7jfuwi2UwdDd5/oxa64tZZYb9Km4aH
	pkbIo3xklL9S8IjEHYCH7HSxq3zjYSF25v/9/AI9IKFraD9qufpFRxJgkwNQIvVuO63FLt+
	euztI/lvk0kt3RZKdgIJA7e/xYui/nmATrAaI9vgO+g1A+5LY1Fe2F2tgR8kx1NM2HIDoo5
	kIKcA8/GW57at8aMOaAMO11XhY2e6VKLE6cEbQf3pZcRBxoc31Eco8CoVVB2fx5KbTBE3bB
	/Nolkd/CIPLY/l9zB5innURk4D+WU/2jSG64x+Kb2A/BgPEe4/KrVrqbYAVBrqnpW8xBfmx
	1IEF+wJ0ecOgI7/zoulmPsRDCWGPJ7NrhfsmoPWUlWRdjjN8oPi6o/zba9zE0JjgWBLj1cm
	iltSLHtRJbpQyMBEbJ3v3zZgEzwKrCETXWIqvtfMaI7P2n/OGWHvJ/TXg2XXHGXvoY5jBtV
	pbpy1U9VNffLvjCkZKqznbgP53xaqSKx23Ev2Lj+YMRt+onQA2xhhMD2dAFHgLBg1cMeDaB
	0c3NLGDYx0mWB044z6j2xAWOUsh1x/VzY37j92Oyoutcat4Pjl64LMceIk0/ya70xEvrY5D
	sctuUmT0qUXR1zGkGJ6ZAogEIr3vgrBrdnnMas20KA7A/l3mITxM+hNB7ajx6WC08yyY9MP
	mxoNuyiYGPb7LVpqF98P7h8Myr4CqHbm8kScR89Qt6tZ4HboknFI4ZpoeHbZjBvE+WnOSZ/
	floL9bLLLRnBKKEE5B2E2PMGr/wmWgVuBQnXR5xQVM/SIpIAq/Zpkh2E/tLWp7SwkePeLFC
	2FSTMXsD07V6131ka1BHbV+ffZ39Ez2UlTo1eQDIlXRv3EuyUSEVMXxlQhFbCAh3zDAxwze
	CdFAxi427EDv8fvgji4aJa1V0s7I5QKkNx1EqZIGnoAd72iGzqomgKgygjChEinvTYW6X6R
	Uxo5nrFsgIcu7amWuO2vaa0GzrAafKJ//QUu1y576OvgBp3PxZUHyvyvcN2Ek=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

This error path returns while both wiphy_lock() and wdev_lock() are still
held, so one malformed IE request can permanently block later operations
on this wiphy. Route the error through out to release both locks.

Fixes: d01f1600e8b0 ("wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 net/wireless/wext-sme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index cfa903eb0e82f..0e7c314bdeef0 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -354,8 +354,10 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			/* nothing */
 		}
 
-		if (!for_each_element_completed(elem, extra, ie_len))
-			return -EINVAL;
+		if (!for_each_element_completed(elem, extra, ie_len)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie) {
-- 
2.39.5

