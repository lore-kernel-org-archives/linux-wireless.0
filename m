Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA0A3C197F;
	Mon, 17 Aug 2026 08:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786955470; cv=none; b=aM3G48wtdyt9q8HYwMLOya3jXILibOGLs2Dr51loF5T4dvLLqnpTl/nc8nsT3B17JQuEE14nJINv/kWH8cmJOfkPGqzBqdEgUuHq+Yf4JmV84zlKBG7sxRfZ/rmmkbMgcq43v3C243cAJxZrmiRHOVHC4O/s9xLqe/iPiUiKKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786955470; c=relaxed/simple;
	bh=bsxmf+flHKTtETmhBPKVw2z/SSxwlPsROzr76GICe24=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ItzzaYniiaoyg45zii3wQCYk2hItG+F/Vp72y9zMKJszxqYokcmNckTWA7Dgvs4C9ukioruDDxzruHVijIP95pnpdAGw+Hl1OQulM76a2XFWB5KCdU3GFSQb/l7kr2Wm41cQjcFooM3mHxRExrjw5YYbF1PdA2g+0QZp9m5Hfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=V7c6fygT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="V7c6fygT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H8V3Ru83790556, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786955464; bh=bsxmf+flHKTtETmhBPKVw2z/SSxwlPsROzr76GICe24=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=V7c6fygTwEl/58QV1LEKk+Ncsz57bU+m2p4v/irCdE2o1wHEOYW6kYv734aeCiUmt
	 Mm+8/XcBw63J30DG4b5s6Fz3Wv5GfBPc818FhJsDSKfJDDMv/8OYXy3BpkS3ZtTykP
	 SDFJra66eWWi+rWcI7RhUqbeFZrvK1w0rh08gQP4wcgRy2NhNkC2U4yEo7ECmINxnz
	 ycPUwqCCdpjFkkCQ1cOW7P7E5SGN5o8CE7a0pftmL3JZ+CSbVngiMoORDrquOA7cJs
	 TBurffuXG3FZE9qwLvmcZXZghPgZlSJAySQdbG73mx2LQxgiVxhV/PvBj33TPPvvto
	 UKhk/XGjX+GlQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H8V3Ru83790556
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 16:31:04 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 16:31:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 16:31:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 16:31:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: rafad900 <rafad900@gmail.com>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH v2] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdLgiHVkEs16CGAkyT0LtmQvZ3HLah6Mhg
Date: Mon, 17 Aug 2026 08:31:02 +0000
Message-ID: <f6efe2a8bf464a3cb4e53fdac161f6e7@realtek.com>
References: <20260817052250.358796-1-rafad900@gmail.com>
In-Reply-To: <20260817052250.358796-1-rafad900@gmail.com>
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

rafad900 <rafad900@gmail.com> wrote:
> To ensure consistent patterns, the device struct was
> defined and used when dev_warn() is called.
> This follows the logging pattern used in most of
> rtl8xxxu files.
>=20
> Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>

NIPA reported many fail and warning items [1].

The tree selection should be rtw-next. e.g. [PATCH rtw-next v3]

[1] https://patchwork.kernel.org/project/linux-wireless/patch/2026081705225=
0.358796-1-rafad900@gmail.com/



