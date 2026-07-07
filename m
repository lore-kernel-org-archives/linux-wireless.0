Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055FC3F825A
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 11:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424405; cv=none; b=u0F7vGSJ+DHrUHsE0rBpLvYrzVDYFaTf/pIogY/EoNJQfCtpc6ap/BGAdyeXLvRdp2ZlvzmoCS4xrRCR8qe8KBd1eG0t4SBcJujH/ih4T9Z1bFsRJPnvVIohI7UnsTEzB2rpYX1gSA+spfsJUKLYlHgqGqWCgPyBUcNEzjQBHwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424405; c=relaxed/simple;
	bh=cEM5tecoeARkC6LkrA7ISb4Ad7hdtZ1H7DZvO0w1fTY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=W4VzKKmQKNCJ7FhbhD/MU7ru36apFEKNYzrW0X7a+en1+e5io7MzgnvqKVzriN9ntkZN5KX2QO0o0MySCWuV07IkSn14X2Y31FYl8lM7mfJqc7mvt4mXeZbGIcNLWOWHIiZ679bgvLZgjhlRVoKN5RXOENh8WfauRAQs0gFw2M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OM47SgIf; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OM47SgIf"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7e9ecd7216cso1719913a34.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2026 04:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783424403; x=1784029203;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Cq4FMiWOdMJWiEKvzmRDCBxAiaaOxGrHsyfrfUoaaWM=;
        b=ZuOk/tQuRKLx3vLLgZDVoVCYW1iJh+oPYouZ+UzAF9eHpK0lgaAVxSgOELbExf6Fbq
         6hrsnQF0ppvrOHXwCBmzDNAXcq8BqRxFL38q3/ECnXMQLfCqVzv74M0skAsMtwH2rDga
         SGGd2biD5IyXHbUw3JFAsomTOmO2J7eXeScdAzMP57e513pOHuT5/WAlOypVnASSHvWj
         +TMvSLDlvT/+iiHdtZ4n8vP67AV+2mJPbcSKZ//EYxqDUfniImDmpvN5wpq6oZxOaVFc
         fO7OV7oX2E+vB5+9fk2ZhI5pC6j472JRSVVXlFMgitOCR0mNByS4tglyoAW7Pm7R8AFM
         lzcQ==
X-Gm-Message-State: AOJu0Yzz/jGX7sajXsCE20XeI8x3Jjn2lohAK+lpRYKrz4Ja3+pw86Jg
	1xuvDbGFXuBO/b4WEUomrkHi83pMQN+ng3fZgOgf4AIotUQRJRGtsg5lBJDXNsS3j345AdzkRai
	Em4dFHHkuzoBSTbjcNB8zzh/8vNUgkWOfBKogHR5EUPc7Rt2MyGED+/RR2g3HJieYCwe8z6LGTn
	+vogY3BBYgfNNXi+NgMjB18hwMpV/lrT66tRbm/qPR7rdtlv5LQlUVncSs/sykzznXTK1mI9wef
	VMwHePiR+dYusvDElL8yVH2I0th
X-Gm-Gg: AfdE7cnCHQ02dbTDYlZUjpQ3ohSpywN06/Ft41U9jzNCwKQ70XwJIoAcBuoAh2FiJgq
	hX3//cDDS/Ws1T5/Ch7RUmI6XRsbtCxCRHyKaMUksRGNaJ22RsUNnjMyNGxNkAi46N3c2c6e+e8
	2o237a2FOQuXOOOT8ybxguE+C6UyUQ5hmJf/D2A5s7o1KIwMhYzwRlsi2uy/LYKpP1DjI68Uu05
	ED+ic8gwrX1XQFcfD+1fz7/+/3tJf8yGYOXUp/cj/yIdzBJE6dn+niPl3a/Eabc11FBv71euVDf
	F6URjFnv5WU9tDE2YNUfy0NoUcYYE/SleQ6NYkxaiY0enDymh55AIXQFYYK/njcSktfa2TAM55Q
	AE287bQFpH8NXjTocyD1EG3TMISOUNlpeZzHj7Jr3j0WaczoOEEwyt9sEUPdwSyXNrJNko9Jo50
	+lUdU4qvBRHAAcHXnlbPEo9Lq/rKGJpJbhxKmT3Wegoil3FQz6ez0W
X-Received: by 2002:a05:6820:150d:b0:6a1:50eb:2122 with SMTP id 006d021491bc7-6a3556c965bmr3084444eaf.70.1783424402860;
        Tue, 07 Jul 2026 04:40:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-44cfb6c4f2fsm1399751fac.8.2026.07.07.04.40.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jul 2026 04:40:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8f08560ea44so48280026d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2026 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783424402; x=1784029202; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cq4FMiWOdMJWiEKvzmRDCBxAiaaOxGrHsyfrfUoaaWM=;
        b=OM47SgIfzwwco7WLjQ3RI8nJSX4eurLKUXsELTBC0icC9zJfA1NJBAzNpd7PITcfXW
         eqr1mpM3L7cctiGqJhu47lKzKMP60a+r/V8pUxtATYmJ26sWLWT/Y888kkvxz0wEglxA
         8d81lmd68hY06sqAPnJm5CfdksL4WD/qmTAEw=
X-Received: by 2002:a0c:f114:0:b0:8fd:6df3:b378 with SMTP id 6a1803df08f44-8fd6df3b76bmr14436746d6.60.1783424401690;
        Tue, 07 Jul 2026 04:40:01 -0700 (PDT)
X-Received: by 2002:a0c:f114:0:b0:8fd:6df3:b378 with SMTP id 6a1803df08f44-8fd6df3b76bmr14436076d6.60.1783424401077;
        Tue, 07 Jul 2026 04:40:01 -0700 (PDT)
Received: from [10.176.2.33] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f471815818sm159826646d6.31.2026.07.07.04.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 04:40:00 -0700 (PDT)
Message-ID: <996adbdb-9531-49e1-8cae-5fcb7b914d19@broadcom.com>
Date: Tue, 7 Jul 2026 13:40:01 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: fix heap overflow on a short auth
 frame
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260707063155.3099999-1-maoyixie.tju@gmail.com>
 <77dfa2f3-296f-470b-8d21-0f10a56a2a4a@broadcom.com>
Content-Language: en-US
In-Reply-To: <77dfa2f3-296f-470b-8d21-0f10a56a2a4a@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 07/07/2026 13:32, Arend van Spriel wrote:
> On 07/07/2026 08:31, Maoyi Xie wrote:
>> brcmf_notify_auth_frame_rx() takes the frame length from the firmware
>> event and copies the frame body with the management header offset
>> subtracted:
>>
>>     u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
>>     ...
>>     memcpy(&mgmt_frame->u, frame,
>>            mgmt_frame_len - offsetof(struct ieee80211_mgmt, u));
>>
>> The only length check is e->datalen >= sizeof(*rxframe), so 
>> mgmt_frame_len
>> can be anything from 0 up. offsetof(struct ieee80211_mgmt, u) is 24. When
>> mgmt_frame_len is below that, the subtraction wraps as an unsigned 
>> value to
>> a huge length. The memcpy then runs far past the kzalloc'd buffer. A
>> malicious or malfunctioning AP can make the frame short during the
>> external SAE auth exchange, so this is a remotely triggered heap 
>> overflow.
>>
>> Reject frames shorter than the management header offset before the copy.
>>
>> Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE 
>> authentication in station mode")
>> Cc: stable@vger.kernel.org
>> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
>> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
>> Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Thanks. Nothing to add here.

Actually v1 was already applied to the wireless tree.

>> ---
>> v2: drop the Link: tag (Arend), add Arend's Acked-by.
>>
>> v1: https://lore.kernel.org/r/20260627131313.3878893-1- 
>> maoyixie.tju@gmail.com
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 6 ++++++
>>   1 file changed, 6 insertions(+)

