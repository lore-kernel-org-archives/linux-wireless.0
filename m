Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793678010;
	b=L2V82Wh9l/gz34Lzjdgruz28UDqPI6ehzQXMFt/R3QhmbCvKqe088jwjOYRloAgq66T3
	 sVAi/Z8X9Sfu6y19Jq+L7xN6cpCvNY7v5CavkmouFiS0gKNzimW/cCyLNj0ObXIaqBqwj
	 9C7+c76E5kXwuVVS4N/LwbC/r4PnQTSj51zfvDXYZwgCQPom8U0gUhe4JuHmnlQix1b+L
	 d4MJQwctlk+7KlhmQ0K58ZdjivfdyX83DSRfY27af6dJWsmdJd8F7y7cJMr8qkSIrhV9I
	 cylXuZfhcwSwJ7FoeVuBK8O1fyz+Yo2dMbiPI5wgJ9NydQ0I6ZGcmR0ktUy4h5MMwIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793678010;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=J+xyLi7/5TC0JEZklndyNpnXqxxKYJvv67ep7B3/Udk=;
	b=IIju0ySby9Kdj+7UfhKj1I4qK4XC/ZmAOjaCiZ6WhO/cBNjsiP46NVwtFlA/iSLaprn0
	 ADetFUIzTN0bYidS2NivlgDiv77Jc2eXbq9owqVXfEWpEc36X4DN5gq6RAVSnOAkPEHbA
	 REredYnE01wT7xVxwmOF0X7AItCCQTTHNMbYfXz5EcAV/28VhdfRf0JzSMvJXRGKMmynE
	 DksV724Ogi7O8WN9tFODFy68QRaS2IRr+v6VCj+2iM8BIqO0LvKZ/He9Nrobw8AkIbaZo
	 R+kHlfN8V1bippNgAMay4C7P3xmjUpzoC3ZAN/OSxdXfmEkidExuqsOmP/AI6mRCTeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=pVGw+pwZ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171BC606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 171BC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=pVGw+pwZ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33rLVn92711490, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793678001; bh=J+xyLi7/5TC0JEZklndyNpnXqxxKYJvv67ep7B3/Udk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=pVGw+pwZ4uRLQAiyg5R4FQrluNIKiYbF9cWltrOMHOI7dHIt6CQqrOXuqE4jqonSN
	 qS7OZMPlrMjRFe4oyb8TA07bz3oaYoX0I+dgwrvuhP6sHF+eWa3sv7t49mdh86aY2R
	 mnPgJ4r2gEQCWC/iBULy2fQM+KVMPLtKDCS9A8NztMbb2ZbyXSKWSSmfOr9uxSKrTa
	 mTM909HMp0mDtEMbDi9nO/f9BLhO6vR5IHDrBmex3RygMQNumDOejFOzS9Ve/UEIjU
	 2XlBg+JD4GznwP33KkrwQ89WYMJlTaK5mUd2saq/kbLLKDUxuJJgP4V3hoF+vHcWlJ
	 HVmpjkxxlaKBQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33rLVn92711490
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:53:21 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:53:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:53:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:53:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: always report a single spatial stream
In-Reply-To: <20261020222009.9116-1-luka.gejak@linux.dev>
References: <20261020222009.9116-1-luka.gejak@linux.dev>
Message-ID: <cbe0d2fc-8883-437f-ac32-86c9d5d3654b@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:53:16 +0800
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

Luka Gejak <luka.gejak@linux.dev> wrote:

> RTL8723B only ever has one spatial stream. Set nss and ant_num to 1
> directly instead of deriving them from rf_path_num, which just happens
> to be 1 on this chip.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

b490cf696ff7 wifi: rtw88: 8723b: always report a single spatial stream

---
https://github.com/pkshih/rtw.git

