Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8B21A6807
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 02:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045676; cv=none; b=Y9coDm4gShLebIaKZfMBKqSenM13MLR+ZW12NdStmXLlxuD9k5RTR4zyO83lLCsMTa7Oxj+7c6vU3a5NVc+MmL3mQYDT+H+54I0iIBQk+/IEvY2pEb/HbjIGI2ROH05lfipMpS2Pre7Li+x7rkGxlb+EY6pIfD8PxP3N49XHjjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045676; c=relaxed/simple;
	bh=MboCeR+oVV5enI9xjhgKa+VY42OkuuJaNIvDvg53Nz8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=mkzKeNNm4vP8J0uuLbnEEN4eXu+jdqR0QwrVq/x3qrsoGY4KwHf787BhLrZGa8gy356PhQcOzd5FWkmjEb8S4i0NYmieMroq+3oxVY6sxu1ZKKZdJu5CMvqxK1K1dAMT0Y1Ry+9pH48Bsbt1LtBJDBDhqItzBoI2eMrKHQaAvTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BVYoZ6nw; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BVYoZ6nw"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6632Rp2gA2387193, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783045671; bh=8CU+WIdQ1yX3UDOTLmVPriondNCtBcEEuXfOcbmV2+s=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=BVYoZ6nwvu6/rZrHZautrOBJ7PjjpZ7W7M+MJziEk8JA208xnKyPYvW2aLtIKO79z
	 DYjanfQGxdsV53CaKbHoEhidA7Ui2kWjDANw/JWKDYZDg9HtmYd7uHLi5FoJWATiHl
	 flsdk1LXhtqDKJ3LNrHFs1BJUVSxARlA5kA3TDYLF/qRBRkjITFMIWO6I4Zyh6CUyX
	 do67kDT+74LfkMbI93X5xB8sqXw0WM9w/ZLeEpbNFom4DZEpD5xpA8tEohwWTtcqRC
	 kdNml2m3Jw2t03pCJbP953aETDbBysFOEpbjxbal5NC++FLiQXtofWFuJhvaVufTSo
	 i9uDIF2wj/uxA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6632Rp2gA2387193
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 3 Jul 2026 10:27:51 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:27:50 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 10:27:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: 8822c: Don't process RF path C in query_phy_status_page{0,1}
In-Reply-To: <ee30b95f-bc68-4711-9b15-cf5fd23c3c48@gmail.com>
References: <ee30b95f-bc68-4711-9b15-cf5fd23c3c48@gmail.com>
Message-ID: <a5ad3471-ad8f-40c3-85aa-92efb06ff090@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 3 Jul 2026 10:27:50 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> Replace <= with < in the loops in query_phy_status_page{0,1}(). They
> were processing data related to RF path C, which this chip doesn't have.
> The only bad effect seems to be that the phy_info file in debugfs was
> printing unexpected values for RF path C.
> 
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

a4a2c1a1032f wifi: rtw88: 8822c: Don't process RF path C in query_phy_status_page{0,1}
617b1d97617b wifi: rtw88: 8822b: Don't process RF path C in query_phy_status_page1

---
https://github.com/pkshih/rtw.git

