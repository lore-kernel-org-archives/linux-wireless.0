Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D5137CD2E;
	Tue,  3 Mar 2026 03:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507244; cv=none; b=KTC/2tVKoUp63pTK6H/zWYcwnBBAXUq1sQzGUP5/QdsxNaQw0u46K2q6NB1DQuix8PFV+vUXiadH7EwUsg3/YGxKZMbVhRJfY12pc2JxZTi69mFTzqxTBxTDAhp6osCm5l0m3+7xnEp2BI2y6Jc55QiazgNXb4wdPweg1QZ+8yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507244; c=relaxed/simple;
	bh=QhAuZmTAsgAftxJERYGt22Bv/Mfl5Gjb14yKWf0P1EU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=p1pJlruqz6fhbV9eVfXDxHRNGpOYyjf9Hqo8JinqhUWxAddYlXbUgi/PCLI9AFrYyBteFVumZ35uOl1j0go0hoqlPHj2NIweUaGpO2ZX1KqAlpQ/tWYOgXFXRRXmUS5btSdecCJIWVxAS9/8KHRyOO2r6kgbI8NHK25jSpPkD2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XAcmopJY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XAcmopJY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62337D150295841, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1772507233; bh=3im6PlGPUbugVp2wwzPGwPcJaVLwXdSP6awTDJ3GZF4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=XAcmopJYsOpMPDAXexfcXfUURvS2pRPIQ+/0nWGex1GRf8UJq+2032DZi/eapykv2
	 tI3h0RdJ4bn41MqRVzIq/FaLkdKoK40brDkA3/gm3ZpVuEEDDq3qzXEo3AZFB+ADgq
	 OhBMqcAFqsmDnzr4HeOUNe4vAM39uWBIJ+I6VYGhlvAhUysgmny7bJazo+24lK3DY7
	 5D3ZXkurWkhyawJs598tn1LV2o/kRfrkRWyYux52GYsHMg0B5DDW4+X+JDnJLRlBcP
	 9bLmrOPpX+S6jWAPEBMQmcAUU4iV7TLVXbABRoxHxYsRHA5+CF2rUFqP7fccsW4lcX
	 LJU+g3a0TUK8A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62337D150295841
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 11:07:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 3 Mar 2026 11:07:13 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 3 Mar 2026 11:07:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 3 Mar 2026 11:07:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Ping-Ke Shih <pkshih@realtek.com>, stable
	<stable@kernel.org>
Subject: Re: [PATCH net] wifi: rtw88: properly drop usb interface reference on error
In-Reply-To: <2026022333-periscope-unusual-f0a0@gregkh>
References: <2026022333-periscope-unusual-f0a0@gregkh>
Message-ID: <8f573000-97db-4b6c-83ff-a759ac3175cd@RTKEXHMBS05.realtek.com.tw>
Date: Tue, 3 Mar 2026 11:07:07 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> If an error happens in the usb probe path, in rtw_usb_intf_init(), the
> usb interface reference needs to be properly dropped, otherwise is is
> incorrectly increased when returning to the USB core.
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: stable <stable@kernel.org>
> Assisted-by: gkh_clanker_2000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c413737effd6 wifi: rtw88: properly drop usb interface reference on error

---
https://github.com/pkshih/rtw.git

