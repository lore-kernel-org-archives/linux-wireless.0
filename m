Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677868;
	b=wGLQ7LOUKTyMonoKxDurB5BfijxPEBGsG3yyjQT2lhuLLsM5cwfBmM1lj06xooUflUqy
	 NGtOd7QdQAhMBMiD3r5i7pCbBbPKM7Z7bw15frFZfKueyhbfQR/UDLHW3wBIIICItlbop
	 S78nKlBU0rzQAUpmfsP+t5z8VF0ZLHwTbXqLqw04qN5yB+t3p+c6hX8c9PF+GAGzj/a4s
	 ugAT2Cx/b6rGStr3HUXnsk1mi6JzVpKRflRjHUzpsxKuh6mI5GD/up3cu0q4U3adKy2oV
	 +sV7U4sh/WiWloulwNbeewTnxYQjLnh9jNyZRt4y+GkWNe2AojdkM1BXwD6U/C+7P7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677868;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=27NUWQie28kWPbs4BbzP/zJapeupdBvBsJ8hBpGty/8=;
	b=3kK82/ELlXWUVSEerwYyXnq0VpW3xfdUjsMRQWzdQQ7dUjqY7WwVOOPnLwcWIGoXDOZ1
	 x1DgSYyWxeVpmbkY/oDq8+lQnOLoFfANEOBh/EgFkKvFBxgfZGlSuyAhBQ8NXhXf0yHN2
	 Iifo4TMlR5afvbr0fBonVOvZA/an28UhfxW7+WoJ4xVfMVAiRWtgffzGNYcdY1weBwhii
	 yGNvWkBcjU+FYSVOffuu8jxZqmZTIVKFmnw/Qgt71jMgA+sBlPnxEjpgdC7Fnk/ypVqTA
	 zaQgm/+VAodO2Dab1jkOrygeFrFf8Gr5g6SfwghoCwwWmsBYV0UVuk8JZWY4pr3+z8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=JvhSAi17;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E3606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E4E3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=JvhSAi17
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33ouKvB2710099, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793677856; bh=27NUWQie28kWPbs4BbzP/zJapeupdBvBsJ8hBpGty/8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=JvhSAi17G8jRfwr17yM7/0var68MFjKr0LobOV2BbHqG9IONo4Vg9Epy0u4SkoUtx
	 g8+DqtEptxY5O3RZregTquKDEFtoU8vLAIEQd1iCYuBBKAEJx87/1eL4AsJsuiZC2b
	 BsrC2SCh0qDwmlpNB+bGGjJdDe4u6IOO9QQWDZ/vgPXGwmrYpiGVEZK8K97ojakTrF
	 m8nXRZJ30JrpAk9t2W7pCLr/EFPQcdSB/lxcGmmxz27ycuHqka5NgMKoOb3AwA1DsR
	 jxiBZQM7FkJdhY1RXeVSaa6SYo9FaGrRfGqYRJAMEg0GT4VByETMnKvnYScaC0GzZ5
	 8qgtQC8EJOVMQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33ouKvB2710099
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:50:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:50:56 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:50:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next v2 1/3] wifi: rtw88: Pass the physical map to the read_efuse chip op
In-Reply-To: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Message-ID: <0538121f-9528-4b49-8230-50ebc476e252@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:50:56 +0800
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

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> rtw8723b_read_efuse() will need to read a byte from the physical efuse
> map, so pass the map to the read_efuse chip op.
> 
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Tested-by: Luka Gejak <luka.gejak@linux.dev>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

ec2baa4c9317 wifi: rtw88: Pass the physical map to the read_efuse chip op
51abe866522f wifi: rtw88: 8723b: Read the package type from efuse
10d1312f2f19 wifi: rtw88: 8723b: Read the chip variant from efuse

---
https://github.com/pkshih/rtw.git

