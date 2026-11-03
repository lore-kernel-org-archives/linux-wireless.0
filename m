Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793683933;
	b=XJpl0d6QLBgbJL0XuY+ytsshbFG17VAXtMR6Zh1Cj0ZoT9vkLRziV83xkN9HJ5ylto+p
	 kmbZC0cXuoMYwCnlSsfVYOBXuITt3/OE1cvLsYTkSSDekodq3XtZ7T7zW7DJcT4AfTRdo
	 u7k9QEHjA51KVWVnxn/K4f++Ikjii3czuRPQn2K5idp1x2j1p8EVNbsKwfoZvuqO48zxk
	 +AC9ncuf7DgOlz+Yu2OH5c/acua45FlA8WhsUfkK1QsuePRv3n6rVIsNNtrW/3S4Hzsao
	 JkT9hNVY7dDEM6Ydpd6ei0UzvYDO3vPobZ7LRf1GqQeemGd3+KhQicQSWdod6l/wWpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793683933;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:In-Reply-To:References:Message-ID:
	 Date:MIME-Version:Content-Type;
	bh=NxbR1YByc8xSvFcvBkhH3PmcqGkJBuN5ocnZQurdMPc=;
	b=XjtyAj+xhYGzbD31MBOFUOShYR7M5XGnLSDfKQUU7/JrL7M1mgswpefumo8xXv4QiNSb
	 036edGQbnaQ6zjN/tiGtS5NMJB42O/TVM3N4qnC3fEw6Nd1gXyyMnINcpZp6EUIxJ3MQ7
	 w/sdyhEOdX0Ela7osQAzN0t11R7j+XGPvuIK2Fii/U1PIfDzcDtY2HMPCiowalqZcCvIT
	 arXCOFxE1Mnv2oW5XPxF0R8sFZ3B4dorPqr4XG5kzPeRKowlkYFsF9cKULQCzCz81lrkg
	 L+LbkSdefU33ENbI3HRi5lNr+axL78PdTTPBWmp04aAPUUjacle9GRYSOTYrWJGYTaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=n885vK82;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130FC606A329
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 05:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 130FC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=n885vK82
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A35W3CK02767181, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793683923; bh=NxbR1YByc8xSvFcvBkhH3PmcqGkJBuN5ocnZQurdMPc=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=n885vK82ygGZtwblwmq0oscnsdXBBiU4YYWTtws6flkSJ6h4eACd1M7pBahRfGqOo
	 zAa9hhJ7mhtwE9FecaptmaQM3PwIAxARAqNkbtOyOZRKTwJrIoWEmT7XAzdt8OqtTK
	 8Hq4Lsfq2+uWez3mBOKvNsLRuYQgpfcFJmLO/3v4yjnNsR3mWYIFmQI/HlTRianEO8
	 1MkywjjLCIHfG59IReWpbhgS7PBWzF0r7Vwq348Wb7f/ORtcKXdN8unm35qOExTWcL
	 X/o4IcgSyn0Fps6RsLBnwVUSR45tKOey92pQanUU2FhiA8T/N6zffyKahqUmSPKHq5
	 3H/h6lf/jaTXg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A35W3CK02767181
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 13:32:03 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:32:04 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:32:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 13:32:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jiaxin Li <18135327133@163.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
In-Reply-To: <20261021135906.1493-2-18135327133@163.com>
References: <20261021135906.1493-1-18135327133@163.com> <20261021135906.1493-2-18135327133@163.com>
Message-ID: <9c3b8eac-19ec-466e-b09c-c9ae180e078e@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 3 Nov 2026 13:32:03 +0800
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

Jiaxin Li <18135327133@163.com> wrote:

> rtl8180_handle_rx() passes the 12-bit length field from the RX
> descriptor to skb_put() without clamping it to MAX_RX_SIZE.  The skb was
> allocated with dev_alloc_skb(MAX_RX_SIZE), so a descriptor length above
> MAX_RX_SIZE extends the skb past its allocated tailroom.
> 
> Store the reported length in a local variable and drop the frame before
> allocating the replacement RX skb when it exceeds MAX_RX_SIZE.
> 
> Signed-off-by: Jiaxin Li <18135327133@163.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

19dfe646d18f wifi: rtl818x: rtl8180: reject RX frames longer than MAX_RX_SIZE

---
https://github.com/pkshih/rtw.git

