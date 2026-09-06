Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C803D79E9
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788704683; cv=none; b=IFILOeD76UNA1QoNo0H5zvPBdGDmcufoU+fKu9oH5xYUwHWNLrqkYvlGII3X8CvUFYHu5qqZ6TxaLjpnPyA1U1jjsk/8jN5X/lnByuHZDTRg/MIjIeBvIru87uQmQqR4qPHDLbxNRCrRcfzEczUz9OAOocQt6qjgoUTGGLpjc+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788704683; c=relaxed/simple;
	bh=WBl59WxSEqMk+fmWemZEz/cPY8wLXeppd7xpzGrDQgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHobQYvJbUTLTUYls3DND1HKBY8djqUkXTYiTYxDqxkstiwZFRc3DHxJP5E1Do7033vmOH5QaTYxf8U+LA/EqbKleh6H+q1Xoam3Qd12bXYYezpjDJSFXBxdFjDJUpY7PLnuSaxe/yOd4csx1HIL/tkOdyFBXpdiTc8D0Ck+S6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XDNEjrPL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDNEjrPL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b8e527d63so32022545e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 07:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788704681; x=1789309481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XO4ugfOlahiEDAFul+PTsZMKmlT+DcFCIGUmXDcXHfE=;
        b=XDNEjrPLJ8unmNb3iJwZMu+BS1SgsUhO+GjAFX90WOIrSw2sFkg/LIPiK/yVfn4YSM
         iTpoOXfpQnYlkTxZ14+EYOHfwrpEsJXtq9qrdQKYoDnIPODQLCJB6nh0xPlULD8he1/n
         +nsVdkmPTpxv7rCRZeYWuYpW7x1sE8V5D4S7IeHA/XiCQLYquMO1fzy7u8suxsWwLfKn
         icQVBVFmTu1wANa/7nL6XRpMsoU6SmIAL7zOFRl5vZ+Ide07DdJsgiIhicMVu4RTf3P0
         6GlXHW/cqfGlZHimuk3Yw6U7p+QYbBEkM8re8DAFpjFRZ58iJR8FrccY/o4BG/UGUwwk
         3MMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788704681; x=1789309481;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XO4ugfOlahiEDAFul+PTsZMKmlT+DcFCIGUmXDcXHfE=;
        b=mfExuMrNv8aNEVMi/J9EiaKRQCJuGQVqIvp4ozqZIvNS3E+qMYNNA3vvP1vx8efb74
         qi0B3lPuiXwAWCXF36ru04BMN9rgXSuv8oVbwPlKtgBCI220lT6wrku+sEvkDxZP+NCd
         JDekBvL9YAc8c0V37yWhKH66fgU9Ktmn3Tnje6Tx48D+jxtyWCJlvqGnMACdWko7JrQK
         qfKigP5vzBsjRIUAzdEayJdYaaq1pWiVgqumX3UxmcCXmQWfxSe7BFEJ9kDmyq421T3F
         jkYUExN1MOnlsTMQxaj5KlS0gqXuZEmYElwsxFNXeYFeQS2SV0mPPBp+bQX3q2sJ9jnR
         LKwA==
X-Forwarded-Encrypted: i=1; AKwUvBwE8RSQz3IGj6vQtBf6fDrfDGUWa1Z3sylFo7GTC5BEOkEBFRgA0ji0KPjBneVcI7y0oeRZv0Wpc9TW1B0CEw==@vger.kernel.org
X-Gm-Message-State: AFuF++mlZmG/62ljLYljvuphmjLq7JIdq6wNpCouOND3C80BwVeQJy7A
	O181AhOVL/g6HatEfYrC4mUQ4aT0ofQupSXuSh3DjxvJRYpNB7DL2ECs
X-Gm-Gg: AYBFou2f3Us8IDx5bWB7k+hy8xrUiUfLjIJQx6UKF7AVBkeGegFWbfr5cLKcZcyJncQ
	cINMawrUUd2Honhzg9de5zX3t9aZFIEUP9DzxpoG4zwrGg6B+5NfSz9F35wXOPEtFhNJQNx3DJi
	ZbIjAocQCbjWwcMoyh8715Y+vQZ/BoKJjh/M3yg4cQ5BSLKIwZ5fz2AGo65diZ8vPk3WsfOG6lv
	v4G933x8TxJCxQ2mIZH+GGiT6A4LSb75y9JPQFtg7TqGkdnz4eEu0+Mbogn+U/xiCflRN14qmYI
	0YS0miTEpJWLJtHN57ifhmiVwl75APLplxR4Cf5+c1NjU7/EB027wluwKP91oPj9i57Dz2X027g
	l4ZJP06m1tFUd1DTw+RXHKNCoiuRSCJb9BD7mLdWSJaSO7FM26/VeLIyu4woQKFb4gTnIkE9df/
	DqvKqb2EqvlvShGh4OkVfjM4u/QKnh/CTdt6plUlRgI/jupTCpyBckvbtuRxR3tw6LYNfN6CVWU
	kBMye98DcxJuhZMYSpQfJglmLcxvV1rK2W7dlZcNSbfNWcjghccvWjKPVCVbVseEwk=
X-Received: by 2002:a05:600c:1da8:b0:49c:cf18:494e with SMTP id 5b1f17b1804b1-49cf825a530mr207782615e9.12.1788704680451;
        Sun, 06 Sep 2026 07:24:40 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d07a23e85sm116193005e9.5.2026.09.06.07.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:24:39 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x3DnT-00000000Em0-0A2I;
	Sun, 06 Sep 2026 16:24:39 +0200
Message-ID: <5a29065b-87ae-4c63-873d-fa22b0899199@gmail.com>
Date: Sun, 6 Sep 2026 16:24:38 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: p54: fix incorrect frame length check in
 p54_find_ie()
To: Johannes Berg <johannes@sipsolutions.net>, Wang Yan <wangyan01@kylinos.cn>
Cc: zilin@seu.edu.cn, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260903081200.267514-1-wangyan01@kylinos.cn>
 <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
 <087d18429b448d5b63f922fd6779925f827134c7.camel@sipsolutions.net>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <087d18429b448d5b63f922fd6779925f827134c7.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 1:49 PM, Johannes Berg wrote:
> On Sun, 2026-09-06 at 13:06 +0200, Christian Lamparter wrote:
>>
>>>         pos = (u8 *)mgmt->u.beacon.variable;
>>>         end = skb->data + skb->len;
>>>         while (pos < end) {
>>>                 if (pos + 2 + pos[1] > end)
>>>                         return NULL;
>>>
>>>                 if (pos[0] == ie)
>>>                         return pos;
>>>
>>>                 pos += 2 + pos[1];
>>>         }
>>>         return NULL;
>>
>> The check in the while loop and the checks within the while loop make sure that
>> no "pos" is returned unless the IE is still within skb->len.
>>
>> But true, it should have been *mgmt and not mgmt.
> 
> FWIW, I dropped it because it really shouldn't have been there this way
> since 'mgmt' can be far bigger than needed since it contains the union
> for all kinds of action frames etc.
> 
> I'm not even sure it's needed regardless of the next check since the
> beacon is built by mac80211.
> 
> Just blindly patching one mistake for another doesn't help anyone.

Ok, alright? I just looked in both:
https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/
https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/

Was there a patch already? Or did I missread the first sentence that hinted this was "dropped"?

Or do you want that Mr/Ms Yan (Sorry, but from what I was told, the name can be used for
both male and female) just post a new patch that removes the superfluous check.

About *mgmt vs mgmt: Yes, you are right. That said, that check came from sometime between
~2006-2008 ;). I don't think the struct back then already contained action frames with
sounding/beamforming/timing feedback. Still, I'm totally fine with it being "dropped" too.
If there was such a patch posted, please feel free to add a
"Acked-by: Christian Lamparter <chunkeey@gmail.com>" if you merge it.

Cheers,
Christian


