Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675521;
	b=a2Byq+QhuTTLuI89j0N+CxfYVCBKvn13pyU3rN/jrchX/O7AA+WvAWciHi343aHMEUsN
	 MBuHrzkA2/g85biT62jt80cA9s7CVvKOj3JPhQ2zfoWBqZTaF+1kLORY5wzPqvaITGBot
	 koMGX931OA54ECRwyibwlf5utRmybcuXgHnu9OLvTVgpI77uo+LMcuoJbezXFFeqMrH+y
	 S24jxZgK7TOxjObpH4/UF+eUdEXOpzU7FRBtFk2bY4S3iN0tmW7PcFsuiKKrNDHMWR0qy
	 oWIbxu9pdtziDA4LUrgms+IKsCuLFYlmTvPbUuidyKQvRo+oa4bGewFdsHRa6hQ0F9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675521;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=CSbGSlqEf6ygYbmORjZ4UpcxZyC3SiJ7rI22NgW9WDs=;
	b=2e8l09RKkwHvWUaQtbdnuFq+QZthlnkAjbRRNEot2R9fopAkClMmw6GCA0rEAWtwhPlQ
	 +m4o1AiCZdJx5lP2Y1gOF9q0iY2NYsxyhhWxD1FrLICi06RCD/mR/qobPFUkupHFa311W
	 szcY6Uz5ZgTLTlPrTnrjh0MnCGdIPpR2/a01KiAGWLYU4I1+PY5QObxYi+AxNLgVT+I9u
	 31IKpYlPcF/8NHtXciZZpi/JJQkPzl3Oam7wFXYB9QuYnrhXE9dMm19TtGC7hhCdnV8ln
	 gbsAD8X4deAGbBJaoSzoJO5XZrgHQtR9pMPV1Rv6eyUHVs2f1nURs/T9vdpXudTW6jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QApT3DGj;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76821606A32C;
	Tue,  3 Nov 2026 03:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76821606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QApT3DGj
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33BkCH22692901, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675506; bh=CSbGSlqEf6ygYbmORjZ4UpcxZyC3SiJ7rI22NgW9WDs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=QApT3DGjNz111DYNry95CsVcVDeX2RCUWRr7k13Y24TFQIeyZqM4Dq0AO/qQ9BXK0
	 79rRwchBwuV7O9aRO9UT+uhCdQ1akdS1eted7EMPJoW7WmxWBqMACmsphQYtU2JZbT
	 E1Io0KFm4J7D52tt+c8hotxyYZT8w+W8n4hRTbWIoZhXfJ4OoowWMzXJWzlyAiUu1B
	 zFBlT2Wx7uwK/wZRTXzRVlpBpW8q4NPN+aWQVdyRw9XjQQlrV8zMubIdEJmflBOXNF
	 pNfqlYGeWYu2QqmAUUeiytcmDIB3KWiwfTRad/VFTxUEx48RfuVCPeT443vHr8cT1c
	 NIiod/NCd+psQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33BkCH22692901
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:11:46 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:11:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:11:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:11:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<luka.gejak@linux.dev>, <rtl8821cerfe2@gmail.com>, <straube.linux@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: Re: [PATCH v2] wifi: rtw88: 8723b: avoid converting RX SNR twice
In-Reply-To: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>
References: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>
Message-ID: <3832ebc9-d379-4852-ba09-85eb06213321@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:11:40 +0800
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

Hungyu Lin <dennylin0707@gmail.com> wrote:

> rtw8723b_query_phy_status_ofdm() divides the SNR report by two when
> filling pkt_stat->rx_snr, then shifts it again when updating
> dm_info->rx_snr. This halves the SNR used for diagnostics and average
> statistics.
> 
> Store the raw report in pkt_stat->rx_snr and convert it only when
> updating dm_info->rx_snr, as the other chip drivers do.
> 
> Fixes: d726c70ce082 ("wifi: rtw88: 8723b: add the RTL8723B chip driver")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

1d72d0db9111 wifi: rtw88: 8723b: avoid converting RX SNR twice

---
https://github.com/pkshih/rtw.git

