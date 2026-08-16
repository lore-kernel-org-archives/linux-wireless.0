Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7E63C7DEB
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786908717; cv=none; b=qO9DVv3/Sm7qGmI1r2H75T97ZtVmnjFuX9BKFBCjx30tNBTPK8zIOl0KZF2l/Am5TPlHKRMSOMa4GEbGE6uCWxAj1ZoLASnKCpC7lRSw2ORH8ICe3BM5OHEaPm+8S/zsZ1YiZU4otxd+/cHGt7IP7hh3CAKi0RVGgKDVda1dIjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786908717; c=relaxed/simple;
	bh=6gne+073qWhcuW31PN8scpNLgfEWk2VGYyijfik3frI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ILLok6ev5MXYwUn8/fz99VjnYmaIsWgYcSsczbAfPOpQl9TGjaVx5dW8wpPNMoCT1vlinoxU2CmLduP3mDpXdyKdNRe6Y0X7rcCrLtLYGJjEQiX3fXMNozwS6NQPIRlMFbzKUD285ZkZt7f1PZz9qS/Lwb9u5Z5uL12ctKZwTT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxMo18G3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxMo18G3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49802c418b5so28553945e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 12:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786908714; x=1787513514; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ctc7yGhmE1wIarRuRFDAcLRG5ueONdHm9nTbL6RaHdg=;
        b=JxMo18G3pPK9f1aT/hhq0CxWsSN+Q+iCkX2cZx5irG3V7dFf6SB7GfednHjICve6De
         IqiABk8VIBoTJ+KxJmSvJZBd1pJZRcy/LCsEye4K9qBByQkpRyaxYOZBSps92L77cGDm
         6+KzCpmikyatSdzPJVPYoBGRQ21d0fVPTFvqyQzJwt/Ywm/OTCJ8lYQbWlTAf8XRJPM0
         waHwY4CbHiAsmoqxZjM5sfY66rD7LTthHj6x2/Aas38Zld+Ugd+IpCA7hRtMEX8fJL0k
         rDh+f30DYUSWl3noLA1QwFXzv7iSuM+6G1MI5/veZopJK8mmyfV2DQnuvdXM7yDMrOoV
         JjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786908714; x=1787513514;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ctc7yGhmE1wIarRuRFDAcLRG5ueONdHm9nTbL6RaHdg=;
        b=rLU8tkNlFPwrr3vJhxgUX3Yi00SwU2pRkVCubAjWRfiwBKKL8fxt+sQZRDRDJB0TCB
         V7FdEoTpVoypafjF89E1q8mJ7kfs2UiaeijU8bPTQlF2fKye1hf66UK4Fvjv8f0Iv6cq
         bfDUlADEbnMhmBQYEUlYLS51brJ8IAsOvGgNwqCmtEsHlX4HAJ9NLrXQLHOxGfls7lrH
         5qJqhTfDQ7EspzlTsq2i0aNkgKYAZVBlLbOS0noDUe4wgQ8TAbW0jWWyGBv7MeKHHPJM
         18s+b/TXDuhi5MlwMeILcmhr3L9V34qX+tgT3WeNUb+wdmBywwmEWRVgUkjVRIlP5PiH
         FMNA==
X-Gm-Message-State: AOJu0Yx1ortdq237c5nMd7LAYabQ5q6iVYW9caV/WSoZYsXZFfmPwHWZ
	sqy72o9/Fcu723okn9djPgmtQdM+Q8kKT6WrFMuhZTEwdg5FH0sSo+aM
X-Gm-Gg: AR+sD13TLaqzaZZ9tamSWBv1jyIZk21fOkQLtekpfOrgeYFONShknBpe1Rq6dXCpryJ
	r9qCQdGNqAhyFfYDlLPsdaNjaoiRLHgfECQtl0eEu5QXBKc5UWh6ABwW3gm+UJ96Xkp30RA+o+g
	odAyPgCYcgbnZt11NmNGpNKP2TB8mSxhD5+gcR0Tt5Q+tzyMPXoBKB9xUT8w3H4jtNporVLY9q2
	te5UhS/d7EILz5YQf9099AA4UJfATs9nCdhY98REMt58HLXwzNwIpjRHuz7N4I1IeqNLBAPgsCD
	oKbKZ9876qYfG2SRguZeB/pwYB4+ygitKG40rEHE9ERSv4pfkyWAC9lvU7pPudambzvmQBoIKc2
	/PvgrKNz5vb9Ut3UQF1SoRBifKy1/U6w/HOWebTLES0s7s18HNFoAHczxJC8DqH7+gn/pGFTMSc
	EabfyIynJ0ue2Y57nkj7skp+r3FCenulWSJ74ZXnUUup64o4LDqnyqdhlJ9oLwyFkrNmY8yg==
X-Received: by 2002:a7b:c5ce:0:b0:499:726c:d658 with SMTP id 5b1f17b1804b1-499879bb9e5mr222290885e9.19.1786908713565;
        Sun, 16 Aug 2026 12:31:53 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f219d3dsm26411187f8f.14.2026.08.16.12.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 12:31:53 -0700 (PDT)
Message-ID: <9367d61a-bdc7-4d11-a424-428950d74f60@gmail.com>
Date: Sun, 16 Aug 2026 22:31:51 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via
 the AC queues
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mehmet Fide <mehmet.fide@screeningeagle.com>
References: <20260813131845.1330003-1-mehmet.fide@gmail.com>
 <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
Content-Language: en-US
In-Reply-To: <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/08/2026 18:07, Bitterblue Smith wrote:
> On 13/08/2026 16:18, Mehmet Fide wrote:
>> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>>
>> In AP mode every broadcast and multicast data frame is routed to
>> TX_DESC_QSEL_HIGH, the after-DTIM queue. The firmware drains that
>> queue at beacon pace, roughly a dozen frames per second, while a
>> single associated client's mDNS/SSDP chatter alone exceeds that.
>> The excess accumulates inside the chip until the shared TX page
>> pool is exhausted; measured on RTL8822BU, 14 of 1803 pages were
>> left. From that point every host-sourced frame queues behind the
>> backlog: authentication responses reach the air seconds after the
>> client has given up, so no station can associate anymore, and the
>> beacon reserved-page download fails the BCN_VALID poll ("error
>> beacon valid") because it needs pages from the same exhausted pool.
>> The AP keeps beaconing throughout, so from the outside this looks
>> like a silent receive stall, and only a reboot recovers.
>>
>> On USB the HIGH, MGMT, BEACON and H2C queues additionally share one
>> bulk-out endpoint, so the jam also head-of-line blocks firmware
>> commands.
>>
>> Route broadcast/multicast data through the regular AC queues
>> instead. They then leave at line rate and the page pool never
>> fills. The trade-off is that stations in power save may miss
>> multicast that the after-DTIM queue would have buffered for them;
>> at the chatter rates that trigger the jam those frames were being
>> dropped anyway.
>>
>> On a bench AP (RTL8822BU, USB2, 20 MHz, WPA2, hostapd, a Windows
>> client driven through disconnect/reconnect cycles): reconnects fail
>> 0/5 before this change and pass 5/5 with it, with the page pool
>> staying healthy and no beacon errors logged.
>>
>> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> I wonder if you can reproduce this problem with kernel 6.5? It looks
> like commit 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM
> behavior") from 6.5 was supposed to fix the exact same problem.
> This is also the commit which introduced the code you are now removing.
> 

By the way, do you know an easy way to generate mDNS/SSDP chatter,
to reproduce this bug?

>> ---
>>  drivers/net/wireless/realtek/rtw88/usb.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
>> index 64e1c3420..f528fe0f2 100644
>> --- a/drivers/net/wireless/realtek/rtw88/usb.c
>> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
>> @@ -565,9 +565,6 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
>>  
>>  	if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
>>  		qsel = TX_DESC_QSEL_MGMT;
>> -	else if (is_broadcast_ether_addr(hdr->addr1) ||
>> -		 is_multicast_ether_addr(hdr->addr1))
>> -		qsel = TX_DESC_QSEL_HIGH;
>>  	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
>>  		qsel = skb->priority;
>>  	else
> 

