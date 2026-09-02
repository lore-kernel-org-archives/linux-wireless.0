Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0DE331EB8;
	Wed,  2 Sep 2026 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788312793; cv=none; b=c+WVee4jnPlUKj6q17MXRMcTekfLFzg9C1//gS9oGwI2RQ7DM2zHiEvZ0kouhZc+YkTAqEpwdWAclUmn3f43MsDMNWmscNQDb17Nb4ZVcwJmKR+lpoW2AQ+xjsuCRgEZ8kB0ntezyDphWL7mKKv2v8q2Jag2r7TE7B6wzeEDHC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788312793; c=relaxed/simple;
	bh=whYEFg2VKiYg/am87oX42bybUcM5bk0CTWpCfKlCgMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cw7jt1bknyn0ZBg5Lk3v7o94SoBN3nwLkUQNSxzZTHyTZNcAuw//ys31yaOpJY8w7i0d68wfq3RL9f195CWA2rMdRW+/VKA6XBcFJJF11908bC5NO5anf0oPxtC/C6rhKXkfysFvCRt4hQmbs4xADO2wppNWr6+ZMJj9y0pT48U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Of1sJu9A; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Of1sJu9A"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6821WPNv82218820, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788312746; bh=8lbROsWp81a7KtmQ2IA0NK6BwnJjiemk7jEe0aWPHOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Of1sJu9AMuEGQ8QNhPuMEPO9n5856q56cJlW7gtqpOf06An8X1dnAg/USCWiXU+Hk
	 rd5YT1CxreB0uCb3TxHHyP0FuCO/h225CwNNNDeFyWs+5BEoA3uAHBX16cTelITVkf
	 ZHfu0t25yR/rcpU8oyHm+Jcy4SPQWxWDRpf8BHPdlKA/fWfaFAhf1ngF08d2G841GZ
	 KB4rdn0I8lQbcWh1V4hIqdCVl1utY+2dCkRxR7il+jaglzTXEhopUWDxkScnAQnb9y
	 0l7/lvVVobeSnyDOUZdaQGZ174MHXlzQCM5Vpwy38YrsyvefpGOQ0PvI1AdlXZ4Ivt
	 CV9BgoqL3CFbQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6821WPNv82218820
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 09:32:26 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 09:32:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 09:32:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 2 Sep 2026 09:32:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Gongwei Li <13875017792@163.com>
CC: Timlee <timlee@realtek.com>, Kalle Valo <kvalo@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Gongwei Li
	<ligongwei@kylinos.cn>
Subject: RE: [PATCH] wifi: rtw89: fw: propagate real error code in
 rtw89_fw_h2c_add_general_pkt()
Thread-Topic: [PATCH] wifi: rtw89: fw: propagate real error code in
 rtw89_fw_h2c_add_general_pkt()
Thread-Index: AQHdOfUDh73GRdggMEeaaY9gsnCeCra6gW/A
Date: Wed, 2 Sep 2026 01:32:24 +0000
Message-ID: <683c6b7e122f480fb9e53238406376eb@realtek.com>
References: <20260901093331.3441469-1-13875017792@163.com>
In-Reply-To: <20260901093331.3441469-1-13875017792@163.com>
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

Gongwei Li <13875017792@163.com> wrote:
> From: Gongwei Li <ligongwei@kylinos.cn>
>=20
> The error path of rtw89_fw_h2c_add_general_pkt() returns -ENOMEM
> unconditionally, which masks the real reason of a failure. In
> particular:
>=20
> * rtw89_fw_h2c_add_pkt_offload() can fail with -ENOSPC when no more
>   packet offload slot is available, or with the error of H2C TX, but
>   the callers only see -ENOMEM and get misled when debugging.
>=20
> * For an unsupported type, the switch default case returns -ENOMEM,
>   which is misleading and should be -EINVAL.
>=20
> Return a real error code instead of -ENOMEM, and use -EINVAL for
> unsupported types.
>=20
> Fixes: 5c12bb66b79d ("wifi: rtw89: refine packet offload flow")

This patch isn't so serious. I'd not add Fixes.

> Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


