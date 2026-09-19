Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AC939DBD7
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 11:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789815668; cv=none; b=LVHUqTATLKDyIOTrFcO2uWQfY3LAFRUQ1mU6Md7+1bv6Iglwj714qDrlWGJvbMbFZ2d0k75Ha9aKbOW738kUq4Gxk1GiWL9C7wjBcuDlqHXKBHuu5TM+cJtJX8rwDqZCZg81OH8VXi4r3wSmPwfoUTUtD8TQB2WfvQMvZn7VR9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789815668; c=relaxed/simple;
	bh=dRH2SUVysFt+OMxG1raoxYvz+10pLuKKjAiEDbT/rzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y+fmSV5bZO0+utaQqZ64f/1CuNb2EQvQsmwwmiGGvDQUGPIklNSnyvc7R7t4U3qt4wERMbNIwDf9aUlLI8xI/Ku0UaRZBkA58z+aA6cFQ+lasHoLJNS27vTfBqjBwyhGREE+pZeaO5d9wKsR0z4bPS0GdaeCw/mS0uItLrG624s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D1X/c+VD; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1X/c+VD"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso7607225e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 04:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789815665; x=1790420465; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8iM6fRp0DoD4gIGYJrmGN71XD24NjuZRS5bWF0srW+A=;
        b=D1X/c+VDSvyoCLPqNPo3aF0YeyiclGXfbrY8QiVPEyvawDYGo/ALWkIT7f1C5UbXlJ
         DckVpUB0qaPD5eMTW7+xeNY0qfn8DTWG2MY3ooOKZexSe6RBJZofmqDaMw9PQrYacUDg
         aurlkKJGrwJHEtbMvan3PUBumgGw6t+teySNUpqP+Ldo9PuEuHMJkdjK+NtdDKq3yHbL
         4lLuR0IlGM68MHbs0mOvUpR2ROXBK60T0bTL6mrgb0yGWIJKqzW5oxxE6BsoWRQY/LwA
         FUPhNi45O0k74bDqQb7txhCeYZoBowSVLrTayOJeq/ad4z7nJUsoUqCkIGJG1+O4oSBn
         SaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789815665; x=1790420465;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8iM6fRp0DoD4gIGYJrmGN71XD24NjuZRS5bWF0srW+A=;
        b=nQl1vJl+++8zb2t+jsiscmA5HQK0Sz6MilNfH+Tilivuv3F4k6l3yNHssW47SSFeho
         nAHGeKUQuEkObiA9C4XMEjeiq/PvYUW+OO+9Fhmhixdyu4zkUgfOoD/je/8VZ6vWgQ+J
         kqblUxRuB7bjxZE7ILu+EiT4ZfYqwhKOVUKuGue4Uza0dsyLNEdW4wWL+R7cc5lFvem9
         Q2wTR0xkzXmgb8SYyJ6LpGPmM2aT+PjP/IjCvsUeTpLh6WvEEf/4t0MSnT3hv2Uxp5/9
         mshj6lHB4np8FMMp9bWRwbuT88hjA5DdGL3D2y4M5o4aIc69SRt87to+81BQNsZbi98l
         jJ2w==
X-Forwarded-Encrypted: i=1; AKwUvBxrzddylGMM9vyG5gL/8XoO1NinORgQwvhxPXhVeiVmuWzLctKAvR+O3K4oLfYVVLUnRUREKARp9vkiktK2Tg==@vger.kernel.org
X-Gm-Message-State: AFuF++mm8gogeh/sSHSEBJbq2/1jPGuSA2Ng5nVSJIcU4QpmRjoedMdv
	Vx5KcgYNFZYi/wJBHsQ6eSDPw0xLqJLt6dzZMMuOHqSOr1PhwISK+tyN
X-Gm-Gg: AYBFou0V+giae6i53cxwcw6cPxqF1l+OaKwbFs0icjvKzF94iHZFIKt8pIlAptIudwz
	zTfvfGQAsr2/k9jElL3xZPV1OcmvVWdfomYdZAt5ga643bIfqo0iKoOvL7yoeBjnUBaD+EO/uPq
	z476awXvgW8niuXa0sdJ0blSlR2yZKjAh/KeNXr87zRhinHE634c5tc3I4NXnFAjRWf9eYUkenP
	C84f8r7mQ9cXg1dxdDh1dWDef5y/VVqDqflXHxp2IkEmppm9Drf7oBMRU1+jgroHvz24IJBtwUR
	B33uBZti/5qWewVJY+SLNWBppOB2J0Uxn3LbL25vn1WU7N62IzkZqIPWRs1sXDumRdKgGX8ogWU
	3gH87NOEnF1hM2JWK3ZkiT4Rugt9yarjjPbolg4CevFYO0dtGaVYnnrRrCL83tkDvrzRBzAL4mt
	8AM4wR8n5W3cYl0QHl97QnCpQctigmbGe7E4bf0GP915v0YQkn872He1dTCoSlYBgwjFQGDjXiF
	kLOaAktycQjHfeYzf2ZgpjvbRnXSwp5asN3Fe60/baI0u97n7xQIam0bqlOd3oOQ2wF5SRN834x
	vQ==
X-Received: by 2002:a05:600c:34d2:b0:49e:6838:c813 with SMTP id 5b1f17b1804b1-49fc5865314mr60598875e9.33.1789815663496;
        Sat, 19 Sep 2026 04:01:03 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487244229e0sm5563055f8f.4.2026.09.19.04.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 04:01:02 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x7smz-00000001WKt-2fDz;
	Sat, 19 Sep 2026 13:01:01 +0200
Message-ID: <848fa27d-acf3-421c-a4cf-02bf7898723a@gmail.com>
Date: Sat, 19 Sep 2026 13:01:01 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] p54: validate firmware record lengths
To: Heyang Tan <thy15333007817@163.com>, linux-wireless@vger.kernel.org
References: <20260918083349.891-1-thy15333007817@163.com>
Content-Language: de-DE, en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260918083349.891-1-thy15333007817@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 10:33 AM, Heyang Tan wrote:
> The p54 firmware parser accesses component ID and component version
> records without checking that their lengths cover the fields being read.
> A malformed record can therefore make the parser read past the record.
> 
> Validate the component ID and component version record lengths before
> accessing their data. The descriptor record is also checked against the
> shortest descriptor length found in the supported firmware images.
> 
> Reject descriptor values that underflow the RX offset or produce an empty
> RX range before updating the driver state.
> 
> Assisted-by: LLM Codex
> Signed-off-by: Heyang Tan <thy15333007817@163.com>

yeah, both p54's pci and usb devices work.

| usb 3-1: reset high-speed USB device number 7 using xhci_hcd
| usb 3-1: Loading firmware file isl3887usb
| ieee80211 phy2: p54 detected a LM87 firmware
| p54: rx_mtu reduced from 3240 to 2384
| ieee80211 phy2: FW rev 2.13.25.0 - Softmac protocol 5.9
| ieee80211 phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
| usbcore: registered new interface driver p54usb
| ieee80211 phy2: hwaddr 00:14:a5:35:e9:89, MAC:isl3892 RF:Xbow
| ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
| p54usb 3-1:1.0 wlx0014a535e989: renamed from wlan0
| usb 3-1: is registered as 'phy2'
| ieee80211 phy3: p54 detected a LM86 firmware
| p54: rx_mtu reduced from 3240 to 2376
| ieee80211 phy3: FW rev 2.13.25.0 - Softmac protocol 5.9
| ieee80211 phy3: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
| ieee80211 phy3: hwaddr 00:01:36:0d:d2:39, MAC:isl3880 RF:Frisbee
| ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
| p54pci 0000:06:02.0 wlp6s2: renamed from wlan0
| p54pci 0000:06:02.0: is registered as 'phy3'
(also tested down to the 2.5.2.0 firmwares)

Tested-by: Christian Lamparter <chunkeey@gmail.com>


> ---
>   drivers/net/wireless/intersil/p54/fwio.c | 42 +++++++++++++++++++++---
>   1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index a3d9053f043c..f028a7bfa734 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -52,6 +52,13 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   		u32 code = le32_to_cpu(bootrec->code);
>   		switch (code) {
>   		case BR_CODE_COMPONENT_ID:
> +			if (len < sizeof(struct bootrec_comp_id) /
> +				sizeof(*bootrec->data)) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware component ID is too short\n");
> +				return -EINVAL;
> +			}
> +
>   			priv->fw_interface = be32_to_cpup((__be32 *)
>   					     bootrec->data);
>   			switch (priv->fw_interface) {

Ok? So, from what I know 100 characters per line is now "fine". But can you ask the AI why it
went for
+			if (len < sizeof(struct bootrec_comp_id) / sizeof(*bootrec->data)) {

yes, this is technically correct. That said, only an AI would take the effort to do this in a
such round about way. A "if (len != 1)" check would suffice (with an adjusted error message),
since all this descriptor can ever hold is a __le32 fw_variant according to p54.h (hex for
LM86/LM87/LM88/LM20). It's was very likely that __le32 chosen here because its "easier" to do
a case / switch / if on that. No idea if the type of the fw_variant should be changed to
__be32. I guess future AIs will/can tell us.

Maybe this all happens because unit of the len variable is a u32 / 4 bytes. If this is
cumbersome to deal with, I have no problem with refactoring this whole function to use u8/char
as len's unit. It would also be possible to initialize a struct for bootrec_comp_id *desc in
a similar fashion that BR_CODE_DESCR does.

> @@ -72,16 +79,41 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   			}
>   			break;
>   		case BR_CODE_COMPONENT_VERSION:
> +			if (len < DIV_ROUND_UP(sizeof(struct bootrec_comp_ver),
> +					       sizeof(*bootrec->data))) {

same as above. Looking up what stuctures are involved and how big they are gets confusing fast.

> +
>   			/* 24 bytes should be enough for all firmwares */
> -			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
> -				fw_version = (unsigned char *) bootrec->data;
> +			if (strnlen((unsigned char *)bootrec->data,
> +				    sizeof(struct bootrec_comp_ver)) <
> +				    sizeof(struct bootrec_comp_ver))
> +				fw_version = (unsigned char *)bootrec->data;
Hmm, for readability. couldn't you just define a struct bootrec_comp_ver* desc = bootrec->data;
(similar to what BR_CODE_DESCR) does and use that for everything in the function?

Any other thoughts?

