Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675854;
	b=KEB9N7TqHJcEXZmkSJZBij2PIuxFhUurshIOxH2eNTCoVt+Jf/WVY+I6VZE2+elbCfTk
	 EuxdkwrrjdZZXEGidYOjK8YvnMCQ7rh8EIzap6ShTQ2Kz9P/dMRkWjS0bpTX4zpqpRnDi
	 99MWJang0zVmGtfnKKgddzSMPpy6tarv6n5uh4d+mhYqArbzDBRiL1WqItyj6G/i/rLYJ
	 K3hGieR1J6zkLJP8KzP3vpqWuMSD4OZxjRgTNJ7NggrtutZpDPVbKegiCgWv3M5D10QtZ
	 4PO2Z1nJ72GYa54OaVA5ZsySBIlGYRHLmNq24HeQqOimoeQVbL/63MIsFAPR1rmgjww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675854;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=+z3p0ZNQEhOcbBLb62/7tk/ijBQq5JgLUIGwux4hS24=;
	b=rUnq2aK8GTpfqcjw9WuOtZDPZRdYDgVaoZrXPB/CGtOnpEJlUeSUz1f2pCu5pVRVwJEd
	 /3yJ/jre4k7p3A0QEcijM2DikI7l8X/9fIhK36Pr6bGhYjXSbnriVH/gCshyJP2pwnflm
	 Jyyw7vp6YLe8SEV6xTyyUVkRjaY+LzgsC+t/SvhPgCCd9NO/42uwIFXelKGMuqO3mxaPW
	 XJSL4YcaatZaDVL3Y1rIkz7C0tTgZq/C95E6+PL2UPx1MOUd2VCU78saKn1ucVw9xg1SY
	 jxq2b25sRpvlsgwAMaMy+7pxhtyo2mNl3cgH800R6UEQasco4fg28fWt7TPq0hCPNkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Rx3NgeWQ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C8606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF0C8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Rx3NgeWQ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33HT0x82695723, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675849; bh=+z3p0ZNQEhOcbBLb62/7tk/ijBQq5JgLUIGwux4hS24=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Rx3NgeWQiNwX1eZDbcYbfUzvTfZPkq1+pYiPVxXj32RrVOB1KbwIw9zkP7vhdU3EJ
	 sHQliEiNAgciZ9HCRj7Yq2ajxqsKD0+w2VZRM7TH8ocJN7SnW44Wwb0DuaDJrxfl0P
	 N+JQhPtmh9zhABc3llg+hWOR3F1Dc8r0ILMOvcPHJmfMaVt3oE4OP3Z0+b91ptP1Su
	 d5EbW5igy7ZRF4bO8dRXRbNs65L9tnHhuzXLke70OoR1eMItrQD5LUq5XSCAPvVXpO
	 ls5iQrS9H+1BEO2IO+OfLwGeIhnhad2yyK5NMemStCUA6ojIoNdV5ydDsdDrhaZQVx
	 DN9rjhtm5HB3Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33HT0x82695723
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:17:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:17:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:17:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:17:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8822b: Relax ETSI EDCCA threshold on 2.4 GHz
In-Reply-To: <20261011204509.46062-1-pepe.schlehofer@gmail.com>
References: <20261011204509.46062-1-pepe.schlehofer@gmail.com>
Message-ID: <f19ef470-8df1-4a2a-a7c0-3312e532bc1c@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:17:29 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:

> The RTL8822B has no firmware-managed adaptivity, so rtw88 sets
> the EDCCA thresholds in the driver. Under ETSI, the current rule
> uses L2H = min(IGI, 36), at most about -74 dBm.
> 
> On a TP-Link Archer T4U v3 (RTL8812BU) operating as a 2.4 GHz AP,
> in-band energy, mostly from the adapter's own USB 3 link, kept IGI
> at 0x2a and L2H at 36. The AP was not seen in any of 5 scans, and
> the driver reported "failed to get tx report from firmware".
> 
> With min(max(IGI + 8, 48), 50), the AP was seen in 4/5 scans on the
> same port and boot (16/19 across repeated runs), with no TX report
> failures and no change in the false alarm rate.
> 
> EN 300 328 V2.2.2 tests detection at -70 dBm/MHz for a 20 dBm EIRP
> transmitter, about -57 dBm over 20 MHz.
> 
> Use the normal threshold, max(IGI + 8, 48), on 2.4 GHz under ETSI,
> capped at 50 (nominally -60 dBm). Keep the existing rule on 5 GHz
> and in JP.
> 
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

b0435910e47d wifi: rtw88: 8822b: Relax ETSI EDCCA threshold on 2.4 GHz

---
https://github.com/pkshih/rtw.git

