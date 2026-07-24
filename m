Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A087396D36;
	Fri, 24 Jul 2026 09:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784884032; cv=none; b=OSnaerZ9SqA2BL1ij/SK0K6JzF+/jLHpQ2rcYBC/5o29qEO2uNX4+liQn3bzoCKLta/WpKWrxRPTqb92dMKukdJZwJF+B+gGtGi2evuncTT9vYJcH2rtkwPmC1Ry1fMVMNORD229AWx157rKrRsFllqLmg6JKzirVYvNh+KQ9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784884032; c=relaxed/simple;
	bh=sPzxKl5hMFNcSMiVNTwHCzKBaOxLxThbPAwR2OI5Ccw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tv2gpm/5AH/p4Hr8UN3h4swEQadgknkkQCovCiku35ICAYABt6dbBaQ1b0fVzU5Z7CJhvfdhxLv3s0DE8j3CWuz7UKnASFahSHc/iYoWBu0TN5ZQJm0hn1sNLWfFlqG2T3WFFp5loNa4bA8/PqnMz5PgOWnJepQrXb0ZyCMaFpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PPPK5nOQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PPPK5nOQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O972GA01092673, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784884022; bh=sPzxKl5hMFNcSMiVNTwHCzKBaOxLxThbPAwR2OI5Ccw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=PPPK5nOQpi9gpczN9CRSuHbPIz5Kg9TGv0+giHfACKJrceoOOlGTYmpxH1DR5jb+k
	 k5pgOgOhHEdpLXB7iOrXVncJLe62SNtRg5ttwu94wbUH+pJL8Rxyt/htXdt5C17Qkx
	 K1t9WdiPmqpNhb1h0Ijd3aChIPIUVbHG4D2YgY7dnyZuTFeicE/hINLjG9LHt91URx
	 +dB2kv7wVfeA4BGdBDnc6hynt7pi8hJfagQt+f6zrpEYPAOkxO6lJ3vy9guX8H2rt1
	 mhCOG0/iwqUm5uCjMaNquhESEUy/NKCPbGIEuNvUABAl4DistSIonvVTS36Ht+n7az
	 /mZ7OSuhvmFfQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O972GA01092673
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 17:07:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 17:07:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 24 Jul 2026 17:07:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Thread-Topic: [PATCH v2] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Thread-Index: AQHdGpsGc834KpTrGU6WSN6swn9clrZ8YhnA
Date: Fri, 24 Jul 2026 09:07:02 +0000
Message-ID: <db42dabddbff4d0aa791f6cfffe87103@realtek.com>
References: <20260723120118.145383-1-nihaal@cse.iitm.ac.in>
In-Reply-To: <20260723120118.145383-1-nihaal@cse.iitm.ac.in>
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

Abdun Nihaal <nihaal@cse.iitm.ac.in> wrote:
> In the last error path in rtl_pci_probe(), the cleanup functions are
> skipped due to a wrong goto label. Moreover, the successful call to
> rtl_init_rfkill(), ieee80211_register_hw(), rtl_debug_add_one() have to
> be reverted. Fix this issue by updating the labels and adding the
> relevant cleanup functions to the last error path.
>=20
> Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


