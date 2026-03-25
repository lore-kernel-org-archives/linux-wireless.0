Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C920322B7B
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 22:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477315; cv=none; b=OxMxBvetmB1xIYb2VUojvFAo5pFRpF9fWvQCE0JEKpLOicNssG0wFqPMcYNSLdhjf0M99TZNjN3LTXFmcVkmbm3SvJuxhdIKLjteGZlnelIuaBWm0jkoK4ROx5YT5afiJQlZXgqFUAC/Fu1Zb2ngBoCJuEsRGb0WTrsJLpsVjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477315; c=relaxed/simple;
	bh=BDdPCnn0IE15rEWXCQx73zhRjZZhBjnAT1yoLuSJ2e8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=j17UsFW9T1iupkNbdr6HQ0apfgZ6FOIxsmqYU8HingvP4ZZg3fGV2xBK2RVy4u/7Ln5e7lwMUv+Lvuyg32o3606TrboJV00MBKegBMNHKqvyfSCsVmyzDcQKebPQG00cuCqnA/taJSc5aADKoppnyF2WM32iI+4RMyLHlUHp33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PtYd1/gn; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtYd1/gn"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b40003d13so180803f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 15:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774477313; x=1775082113; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppywFODWmyKzlFFL/jB09vjMjtocEPHAg5PiwJOt0tk=;
        b=PtYd1/gn5a1lWX6F91V5tquqYfVlCLD16qjxSVnWLTykvf+nfvurLqc60jXfw6KU76
         /5+rvJ/LSXhkklm0FUxyldtyvbbwHpt84/TyVGkft7DgkfQ/ECZfeVhQ2S+XHvzF249r
         HK5vH5vOmdG1H53W7gtyIBH2dg6V5tbPHSLKRQL4CuE94FqQt/0Xq8Z+mG2B6wXpFrna
         EwDylrTqumRGXa08UJKWwUjRcxpqSPyYoTatHxBoZR+mWXutZUtI4aW01uvA7P+xEL08
         jMv/ssnxeP1QzLCtGPchjaPaj5PG7lvMeNtRC28VDGy+Mnd/xqS/dWWH31B86mtCyBpT
         5yxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774477313; x=1775082113;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppywFODWmyKzlFFL/jB09vjMjtocEPHAg5PiwJOt0tk=;
        b=ral779LeaNhr5C6pNNYRvFkNvZkqqPKO9fLmzQYY2vMARfMTBVAErQZ0C5Ru5ukJFl
         fCoUne9RF9tBkprhaWS/4hb2KI2BpWJc317KJXlY6yfcJO2w4Kf83aauomYsvAAM0JZd
         WcxevhO1I6p0WhPRd1vaOMa7mwVj/Id/tzxdDfnIpeUHypOvxQaXuMf/hFIrES6sHJSm
         XyEY51JZ+02Zpr4aPN/r+swLKmZ+fnigkJLQRdfqG5N5HAEXC33/5SDweH6pnRKQYmSF
         3vn7W7yqa5YQkA+6DMlZDZHa4Fgk+ZpiFimzbZlSzhuNiE1FZbTgFN4o5ulg4zBE8Qjz
         5saA==
X-Gm-Message-State: AOJu0Yw9TyRDJriXyyH9TzZBS/OznQmDnmDPtnvlBgvadU2RdACVQhsR
	yzxBQnLyIoGIAYfQUip89i+ZyBdHuH5MAc0mMoPpBzA3b8EUr0x5TCOsJgeH+Q==
X-Gm-Gg: ATEYQzxaZ2AtxfWG9KdAc4wbaKKL1Zcqoeh5vM+7FhA6mSZ3MTStG701bOtiIuXCZVc
	EbScO/cB+PjKa1TwctHBG7UY9m9SbMh9lVWRlMOnJH2gqIVVVyKNlTNLmudlWcQaTflrEqvCPV4
	jNKRQXq0BSYuHwl7NXcHcL/IBlmHzCA96z5VnlbKGUgPIh9bzx1DWlz6i8jUYfE2RGpIaouCDjI
	Wf/KPP9hW0KnTXzVf1fi0y+RyLlh3MumBgc9RLol+LzHz0tFYnIl+6W4NhJj7Q6hKj4aVjK1iHo
	vtgr++fObFirNF0ZsI0u6xsCDNoFEONs2q/n4kmyzkWH27m/XqzuhdP88RVApJqgqbGClxFOOns
	f6oEARfQwljtEp8T6gOH0uBlWi+0Kj1AAp4X1AXW65g4EGzhy3AW5hbFA6U92pW3LVbTQAAUGWF
	pYXFkIcIY/d6SE+1PiHW+bu3DAvcfvaga/sTpeM/Rz
X-Received: by 2002:a05:6000:18a8:b0:439:b440:b8a2 with SMTP id ffacd0b85a97d-43b88a0d156mr7521851f8f.28.1774477312041;
        Wed, 25 Mar 2026 15:21:52 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.93])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b91942e52sm2893611f8f.9.2026.03.25.15.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 15:21:51 -0700 (PDT)
Message-ID: <60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b@gmail.com>
Date: Thu, 26 Mar 2026 00:21:48 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: Fill fw_version member of struct wiphy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Let userspace tools like lshw show the firmware version by filling the
fw_version member of struct wiphy.

Before:

configuration: broadcast=yes driver=rtw89_8852au
driverversion=6.19.6-arch1-1 firmware=N/A link=no multicast=yes
wireless=IEEE 802.11

After:

configuration: broadcast=yes driver=rtw89_8852au
driverversion=6.19.6-arch1-1 firmware=0.13.36.2 link=no multicast=yes
wireless=IEEE 802.11

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 45d8c5e70084..55aee6eb8478 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -755,6 +755,14 @@ static int rtw89_fw_update_ver(struct rtw89_dev *rtwdev,
 		   fw_suit->major_ver, fw_suit->minor_ver, fw_suit->sub_ver,
 		   fw_suit->sub_idex, fw_suit->commitid, fw_suit->cmd_ver, type);
 
+	if (type == RTW89_FW_NORMAL || type == RTW89_FW_NORMAL_CE ||
+	    type == RTW89_FW_NORMAL_B)
+		snprintf(rtwdev->hw->wiphy->fw_version,
+			 sizeof(rtwdev->hw->wiphy->fw_version),
+			 "%u.%u.%u.%u",
+			 fw_suit->major_ver, fw_suit->minor_ver,
+			 fw_suit->sub_ver, fw_suit->sub_idex);
+
 	return 0;
 }
 
-- 
2.53.0

