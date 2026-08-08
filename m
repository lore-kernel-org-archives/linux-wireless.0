Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3491119B5B1
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 05:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786166429; cv=none; b=K9k3+g+HETdUsuiuGzTrcMIfvv5hAf4HXUU5MAHOOod+dYfTe/XIGvZx06v7ZnWlQZajcUR8b9GqXe8DGkjXVq/qLfo7pd7AUwU6Lm+XpQhS+f+AGo8rxsyBFrh0iVgb3h7OEFwYrAZOZW45a5cHifgkOy4Paz5ujbmqBtQNB38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786166429; c=relaxed/simple;
	bh=nU/2OOvqLDucf42vJ9zbZVAYbRRlmeeEpprDjXmH3a4=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=iKVVrfRNtL2X7peyDXVjiJzJsGYQarz3/DVZbhJQnXQlo4m8OgBTXZbAuS4njYhgu6WhNbTT1wvYbeyob4kOYbI3TG4o7sUhcXMybJT0o5lstRftF8Wnyfhutm8wsIuzI/LcG7oob8B6NrvKdqt+prLxba9vYG0UAUBSW5fesCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=F/zEfiEY; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F/zEfiEY"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-930f4e5eed1so10314585a.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 22:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786166427; x=1786771227;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aFUU6ozWORWiiM1uNeCkxuEsbC3KYm7Xvn+yMHJJFRY=;
        b=N8Y0vAjdM0NgXwJh3G+x9OJm9hUUuSVQo5anpc0g40FivGQUuakXd0XfUOiNuGf+Xn
         3jj4KJWtm7fRjeRIkLsJHk1ITWApMYBK33mL/c3CrBmCmVwQctNqsPnO6wF9y5PTbZOz
         bZ9H12NFGAxHRI+b/kR5y+ZShCmcIGBGGE1qCJvFnSnvQWdl6yNnzM3ea+ubGk3ZuV7v
         2TMnyQvGcBxVGpBOppB8leoN/X8Sd242t+CPl0bm0nP8lMUPB/+e/dStzGDSs2Vsojv1
         YnKOysZArDGLu9ehDycwH4sZmCbCZM83Vafu5QWbNanUjhA/RjJGl3zjlGLdDP+HjHTX
         Z/kA==
X-Gm-Message-State: AOJu0YxYQyUgZvtGIHr1L8gw8NRDUDiGInzoj7EtbO8vjxpgHQCOIKZz
	AvwP+uOqAh1Q6EdB2v5L2I9vDntRRF8gNag1rxl9tLtSICCulcPsWT+rcXRlXO/ycmJezefvxCR
	H80Gd4fWCDt4efcgENeuPqeYuHDBKQr7TOGOb1I68E1+NhuQf0fhzTQ2AFZfJB0bPu+74br40Q9
	N6EArjn9uiqGhGw8O0vQz0vjJ3wDmbC0IdVjejuleT+v/v2CELaCLBYDoKRwL3u9xdCMKLlaRwn
	AV1NjMLn/UPNjanJp6emTesHTHI
X-Gm-Gg: AR+sD10AVIRf34cjHVdtxWw07TiygLVNI3FrQ0nrJW+X69aHfc/YGXupNMbI3HTUP8X
	VLK2PJRRJEV1+LH1Y7X8XuSA46GObUO4e84yBLyC2CnWfsYcDRSY6Pu94idrOu2mJnT6GIp115x
	TSRdXILEMYRNxNFfo0QLpYNBTlqm03XXLYPb3KbZKLxR8OYAKj71WyyWP7i3jzG4Q1DNimEEXeL
	uXVPQHj3MVOcGC0/y+AwSTEZcC44E3Iq0BfW5F8+HZ0RMYuLaHW/C32gSu7uPkNr2SnlG50lGl3
	O8gT2gwIPDASw/ETuagKiVGH4Y5ck2ye90Rx1E6eUBcww3k9IfFpTk8025j+m8CuN/Bg6wu2oTF
	QRwob4+03bxr+Li1+X5u274B0V/nq7sifEdM1NCDPuH3efEnc/qGmg6z3MuteKq9ikUOtp+ewYd
	MzfDj+zhs+Efj53RwxIz0c4zrcBVdqtLad2CGtspk=
X-Received: by 2002:a05:620a:522c:b0:92e:59b0:df08 with SMTP id af79cd13be357-93649112c65mr2406392885a.3.1786166426870;
        Fri, 07 Aug 2026 22:20:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9366e283c32sm74250685a.6.2026.08.07.22.20.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2026 22:20:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc6dd43737so7511655ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 22:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786166425; x=1786771225; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aFUU6ozWORWiiM1uNeCkxuEsbC3KYm7Xvn+yMHJJFRY=;
        b=F/zEfiEYKdG3A2ARkBb0YOdI2Sql8pBsfRDArPhez6vI0t3yb582IshyfM31d49hBq
         k8f7r4qizGAImLwpK1iPIS42UrTqHk66CSL2jfqEdsIB/SicOJ4fKfvGDbNgPvD1fyn7
         2kOu5NHz8P3zN5YHE7cW3WdzP1aNyZWvXMUJs=
X-Received: by 2002:a17:902:ecc1:b0:2c9:fb11:1bf4 with SMTP id d9443c01a7336-2d0ca7b5436mr286487775ad.7.1786166425369;
        Fri, 07 Aug 2026 22:20:25 -0700 (PDT)
X-Received: by 2002:a17:902:ecc1:b0:2c9:fb11:1bf4 with SMTP id d9443c01a7336-2d0ca7b5436mr286487355ad.7.1786166424861;
        Fri, 07 Aug 2026 22:20:24 -0700 (PDT)
Received: from [10.229.40.14] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde2e6sm13972699eec.21.2026.08.07.22.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 22:20:23 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Date: Sat, 08 Aug 2026 07:20:19 +0200
Message-ID: <19fdfd09e38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <CA+ORkNSS1dOdUK51B0Q1r2Htc5NpP-=EmE4FO6=4rX5CUU_FpA@mail.gmail.com>
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <20260802083905.3819981-8-arend.vanspriel@broadcom.com>
 <CA+ORkNSS1dOdUK51B0Q1r2Htc5NpP-=EmE4FO6=4rX5CUU_FpA@mail.gmail.com>
User-Agent: AquaMail/2.6.0 (build: 200600043)
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 8 augustus 2026 02:00:22 schreef Bogdan Nicolae <bogdan.nicolae@gmail.com>:

> Gokul (representing Infineon) promised he would send a patch a while back.
> This would be a preferred solution as it comes directly from the vendor.
> But it also takes time. I can send a revised patch next week.

Yeah. With Johannes being on vacation I say we can give Infineon bit more 
time to provide their patch.

Regards,
Arend



