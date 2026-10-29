Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793284115;
	b=nrf2TrE3674GTDFppPxjSklexw0nH6qshOi/DiTPyh2K6V+ntRnIEvBA7Hm78gR7hnnd
	 6mWI0kjBCxjS4aqH5L3iPe9D/vZlJk6Umz0rs7auTBCmVxFnBDvXjBc7l0irdYsBcqGt3
	 BV5Z+hClz7EP72BUPQGpDZQTkCMhb/0UAN0X1wklKFZhHIw7BYtFZR7x81odFhRfzNWFN
	 0UYPX5oSFWUqcPQ+X5x0WNmWLtwz12GqhVf6MwUOhvMiMWZ3o/w2sVnDthy6fNXAgr3tE
	 uWSqvLcq+fsu3LYti3UzrktxStDgxMrMUq9acSUCCOmEVTY4sNAU+UQ73KDO2rviD0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793284115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SUVJiWFuV9nRigB9+EEf42wF+WmO87P2YUfV4P42z4c=;
	b=hDvms5OI1hyP8J7buDaPFS/9eZSa/WZjqQE3tTGgK2FlIANwIRvA1Kbl+8pbdwUm5kUN
	 er5HwC75oG1sUbxz+AS5gD0QPQsuyt1YKgOoJNjXR1u/zvU4kuC6CxxXmXS4INBtVs8GK
	 bbYpUNAdRnAbpgZh5KlOUwiHB5IbxV+gNYiX6/l8eUaj9o/DYw4ZT/bMWJHaFaMMnxZ/O
	 cq7GVzrgvGsb2/7lmOWQRk7uzZJMLygoaGo8ib6tU6WWcl3dG6EDFPE2t11BRf1NGF5/r
	 qUNqHb6vM5OFT5/ZrFsfI8XOCbDUtkb1WoPdUpFWKErwVTZ/weRlaA0WFqHeYR2mjDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TeYaKmis;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45F606A320
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 14:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C45F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TeYaKmis
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e8da6ef7ddso13014195ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 07:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793284109; x=1793888909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SUVJiWFuV9nRigB9+EEf42wF+WmO87P2YUfV4P42z4c=;
        b=TeYaKmisRPbKXFviaN62wb9myOJuK55U9PBx9SZ3dFFrl2/WJRXs7IZKcqjqdf+J5r
         Z/eBHNMRehb86Qtu4I9xv+5pAg1Z4aOOGqXhmer9nHaCZ7V2GVxzBMVen1PkO/dceU47
         /XNFJj/4T8xUYWjCjh19UCwOnqpjc6M5wReNiqAEoT3Mr25yCCKjWZlzZHEAJYGNFC9l
         O95qdYNL1PoZ3k2+1ALY92Z2xSxve0Z40POPez3KTkAnydTbYtl5NWoRQYOM3xsn+kbK
         3GBtqamdFdlPETL6uNHU2Id4i2yYWYvbBNHqE32wgwqurrKPiDArQje9sdr1OZ7vKxVY
         AOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793284109; x=1793888909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SUVJiWFuV9nRigB9+EEf42wF+WmO87P2YUfV4P42z4c=;
        b=P+1mrNEiQTpSk0lvnOpHLwM1uQLGPxcuSSI17ZkeBaMyV1PJbgIHK0147JVRDpLzRC
         l/RK2S4Nhc2EZufGd7Oq4NShUK9cyZVtgBvs8ljRIp1w7DASUio2OFa7keBiF5TBte5e
         QCGUY8Rs7yHPV9g1lJjkXMHirjLLz4RNGzIJcuDj32kkXex9MI6j1T0npG2rnMhhKlyq
         pTFSoH9pKvWIMVz5YwadoK1sUw9mZ7bF+BXWnci426RPLn4vrmTFkn+fSfrmg1udvHt+
         vbpFUxYIZOadKwJ3PeaKR0o5SZbHYtdNa+5eoiBSmIalfM0xOIiVAg0agMfMYNjzyIlv
         o5Gw==
X-Gm-Message-State: AFq9FYK+sNw5EA8xZ9//mJSH4EScQ/QRmYjWCcDEN1ux1uK+I/FK7jU5
	hCLliyXu/8nNpdPIiOFB72kzsHbVLbWiaaPGetdxhSuty6AjE0U7p32W7CyRbmMh
X-Gm-Gg: AYBFou1+MqPN0b+nRJ3WWOhd+7Ss9C2GZ0vA/qW3be4+uM5UnBuPwqyzrLK1mN4Ynew
	zjK49Kh4G82OZ7TuE+SPWVJyTTzLlNgb2V/hGU5yUiCZl5JuLdH+mDrEK7CEfKP35MdiZpHoGTY
	f3Bwc7BFcN5FLumhxz5KljhA1TbfSFLcTL0WuRQxN0EcRkLsvt46dea8Zg/PxACe6ck9AXaHp43
	Jik1BVgcsuqQ0qs8p9g0HH6NF/M08W3ojnV0r+l3oMNyRn98TAAn9/eBSLmutxGSfN1Vz/AxiPQ
	4XJTQwF/eAfVx87RBayH8OFIknrvRnyoZpoxKeNVFwB8gIp/uyGCrai+eN4eLSTKjCdeQ4ODZlC
	K7CYYRmiGoyyLXlDDiN8xN/Y3oyTRquPPoZaFDL43YlXEtOH5YJQJ8nZkpB/j8WgPT8a++RrTfC
	LsXcX5XtyU6fkDzTTf71WlmbYJpBaKIeSCaHOs3oEzOWxZuJNmQLwTA3mnNBBCEQpkvSxWkwewG
	5XHS7628mPiSkiuQjkYLSgERh6pj4kz3nzJNiRaktxj5ZbYvZCDUvYT1M8sa54T47lM/xxva3/t
	qhU3OJ08km0isdMvR8IfrZ5/4cyobAeIhtqySSQTOPu6qpiDkq+7sITmoybBn47/9xqaizjFDV5
	b6w0t
X-Received: by 2002:a17:902:fd84:b0:2e9:84f2:3738 with SMTP id d9443c01a7336-2eb00158878mr52627755ad.6.1793284109298;
        Thu, 29 Oct 2026 07:28:29 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2eae64549dfsm35706495ad.4.2026.10.29.07.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:28:28 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 1/2] wifi: rtw88: allow driver-owned TX buffers to bypass mac80211 TX status
Date: Thu, 29 Oct 2026 22:28:18 +0800
Message-ID: <20261029142818.155753-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f74e2efb-561a-4327-9942-e6f014c99264@gmail.com>
References: <20261029060859.90002-1-hjf3108@gmail.com> <20261029060859.90002-2-hjf3108@gmail.com> <f74e2efb-561a-4327-9942-e6f014c99264@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 29/10/2026 14:05, Bitterblue Smith wrote:
> On 29/10/2026 08:08, Ho Jie Feng wrote:
>> Add a flag so that the driver can flag certain frames that
>> skip reporting back to mac80211. This is used for driver
>> generated frames that aren't a TX from mac80211.
>>
>> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtw88/main.h | 1 +
>>  drivers/net/wireless/realtek/rtw88/pci.c  | 6 ++++++
>>  drivers/net/wireless/realtek/rtw88/pci.h  | 1 +
>>  drivers/net/wireless/realtek/rtw88/sdio.c | 6 ++++++
>>  drivers/net/wireless/realtek/rtw88/sdio.h | 1 +
>>  drivers/net/wireless/realtek/rtw88/usb.c  | 6 ++++++
>>  drivers/net/wireless/realtek/rtw88/usb.h  | 1 +
>>  7 files changed, 22 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
>> index d59f6e323adf0..7bd2e224e845b 100644
>> --- a/drivers/net/wireless/realtek/rtw88/main.h
>> +++ b/drivers/net/wireless/realtek/rtw88/main.h
>> @@ -637,6 +637,7 @@ struct rtw_tx_pkt_info {
>>  	u8 hw_ssn_sel;
>>  	bool nav_use_hdr;
>>  	bool bt_null;
>> +	bool drv_frame;
>
> This is always false. Why add it?

This was accidentally left in, since I extracted it from
the patch series for adding beamformer support. It is
used by the code to send beamforming frames without reporting
TX status back.

Will remove it in v2.
