Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B876C23D295;
	Fri,  2 Oct 2026 02:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790907383; cv=none; b=Q+m+RymqzEky4/PkFIExbhaNa6rtF9HS4dgYq03BgYa7FyxyxudapFcqKapwRHRMqGDU52oNoy3TzG2YoCzDED2RHka+RQJ0k7sOannMC1YMqmLGpevEf295XejLfg56CuAYAMMoVtKGeRug+WYjSok+pyp2udWMpa5DWp0WHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790907383; c=relaxed/simple;
	bh=1cD3uJgV3hvRUz3WYfEQHtwU3dseAjZXWoh1fsC9qiI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DiuDL3OijiFprAvLdeIXFtU4iiVHrLS9Np1UYoKfy5Kv76NFj1hQwAMdAxqLcy2Zt7Hr89o23aDu+5xFsB7j2ABWZMLNlPljWCq/2RULHOTseczKXklvH93AXHDtOwsyDleZF080vuzekGg2Brm84fUU18T7s5gBm/jRlKPodkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=WBfjWV8B; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="WBfjWV8B"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6922FpDC23464515, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790907351; bh=1cD3uJgV3hvRUz3WYfEQHtwU3dseAjZXWoh1fsC9qiI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=WBfjWV8BKTxwQ+aR901O/sLG3nRDfBUwPuU5JB3WUMIGeYdWBLy0BssV4KQ8+2y9j
	 0jCgypu6UPxZp4JPTlamiXc4EU0NYVkblkZGvItE8u69+cIP2XScOp6ZWMF69uw9bi
	 d7LW4gtjoMMZA1ZuZw6Fu3u8/FCQQMAOg6EIb2q/jqNoxqPtEcjIvKIqm+f3w41IoF
	 8vwU7Vd9aKTbdruxh1uBJANpzQk4qGSBc+XRR61q4Wcrrta8bNJicHXszLz9T2OtkQ
	 ZgbopLUmJtIpEssPSobfPiMUBh9K5PynYXfn5AZF/POsbNWOvY2YTL9+o+kB8SGozB
	 Ouh7ez+I1HFDg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6922FpDC23464515
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 Oct 2026 10:15:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 10:15:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 2 Oct 2026 10:15:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Alastair D'Silva <alastair@d-silva.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: Martin Blumenstingl <martin.blumenstingl@googlemail.com>, Ulf Hansson
	<ulfh@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, Kalle Valo
	<kvalo@kernel.org>, Luka Gejak <luka.gejak@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] wifi: rtw88: sdio: Fix interrupt storm on 3081
 chips and split RX handling
Thread-Topic: [PATCH v3 0/2] wifi: rtw88: sdio: Fix interrupt storm on 3081
 chips and split RX handling
Thread-Index: AQHdUThfnJ54QfLK8kC0cS+58qqYYLbphQLg
Date: Fri, 2 Oct 2026 02:15:51 +0000
Message-ID: <05e5031d3c1a40989cdb82ed5b99b188@realtek.com>
References: <20261001000303.3505264-1-alastair@d-silva.org>
In-Reply-To: <20261001000303.3505264-1-alastair@d-silva.org>
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

Alastair D'Silva <alastair@d-silva.org> wrote:
> v3:
> - Rebased on rtw-next.

I have not reviewed this patchset yet, but please send v4 with rtw-next tag
in subject. i.e. [PATCH rtw-next v4]. NIPA can test this patchset then.

Ping-Ke


