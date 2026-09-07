Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAEA39183B;
	Mon,  7 Sep 2026 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761982; cv=none; b=nwpb3FJZr4VvYdP9osUoJV+2mfNfLcohxZQ2douH5tbm5N0VjW5aQd2OWiKOBLsrWm1FiEHDgfWkCNDyxP2X9XA/L536AXrcvfsOXUJscBRq3Pivf1zoCavJ+ziQ6BzFLw/HfFuVLknD+ZC9qRSgqmC9fFNEFj8pxjfKO/BGSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761982; c=relaxed/simple;
	bh=U/nBxxzvApUdW+sQN1iVf0FEueV+RUIMWduQo0x11UM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYF+qqnlkvQgopaVDj+YmdYF/IIZzleD8U3cUZW10mtq9+JpNrXvASf44IVXqCmEsQ07ghKhq77ve8iKUT8faNDvEd8VKWYBkvvHzHUwCkiUb3edpvMzRcMVJLQXdwXOBffUOVvumcHWEo/KvN3ccuuOQYuR6FuuCAWCYR58srs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 145b64beaa8411f19a56ed5b684f684d-20260907
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:93d47119-7567-42cb-8d4c-6b728e45afde,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.19,REQID:93d47119-7567-42cb-8d4c-6b728e45afde,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:7db8b62,CLOUDID:6799dd3a689711ba69620eaa6ca1ae47,BulkI
	D:260907141932HVZ9W9R2,BulkQuantity:0,SF:17|19|66|78|81|82|83|102|127|841|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 145b64beaa8411f19a56ed5b684f684d-20260907
X-User: wangyan01@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <wangyan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2032706827; Mon, 07 Sep 2026 14:19:27 +0800
From: Wang Yan <wangyan01@kylinos.cn>
To: chunkeey@gmail.com
Cc: johannes.berg@intel.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linville@tuxdriver.com,
	wangyan01@kylinos.cn,
	zilin@seu.edu.cn
Subject: Re: [PATCH] wifi: p54: fix incorrect length check in p54_find_ie()
Date: Mon,  7 Sep 2026 14:19:01 +0800
Message-Id: <20260907061901.659866-1-wangyan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
References: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Christian,

Thank you for the thorough review and for tracing the issue back to the original commit.

I agree with your analysis. The while loop together with the bounds check inside the loop body already ensures that no IE pointer is returned unless it lies within skb->len, making the initial length check redundant. As you also pointed out, the check itself is incorrect because sizeof(mgmt) evaluates to the pointer size rather than the size of struct ieee80211_mgmt.

I have posted a new patch that removes the superfluous check and updates the Fixes tag to e5ea92a7528d ("p54: AP & Ad‑hoc testing") as you suggested.

Thanks again for the review.

Regards,
Wang Yan
