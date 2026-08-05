Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B4523D7F4
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785909685; cv=none; b=K1EFuKbDpyMe+QNL+TMvKuLS0RXxEzJPtbWyqnQ0xfberkChYpY8dqAGC1S6nu4LZU39YBwpkoqbskPVNYMU75UwKCf28r0j8XGTHxup5Oh0kgUqhJOeOx6EoVu2z7RNowfkbkq1xjGXt4KBr57d7nsWSnAqiKh6wLsfETkplbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785909685; c=relaxed/simple;
	bh=l8bc8ytrxXEXmbcQbNdzYjz3gf5Gms+qc80pzWcDjNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSvgeKoXduOfIGBTEG3D/7n7R4WSMUl+5R79ZxJ5gsYUdDVBLasoPZr0GzggiWimH/XXUNViexOf84NekxZcb7+tvseoBmZlmQtx3PPSllC/631xtWtryB1ND8q3zunAheBapPlPbjYM6Gl/KgTQKDG8gQtbbzdri/waEMhFhRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Kc99ZuNB; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Kc99ZuNB"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-664ce3000e6so551764d50.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 23:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785909682; x=1786514482;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zQ/9RIR1VNN0hukmG5NlD01qt4vqhJek43rGR5IpLsY=;
        b=AybUefIB3VVQ4OBcKnaq05CdT/ldoXFR7vUzJJV/7Qrp0ElkmYFim2kxB29FxQ70Go
         Mc/VxJneHNm7rVpEgCSqIUfGfhiMPeFtkbTjY6OWaCmmR0pfpfxEUFSrC3Rsq1Kjjt9P
         eG+z8xJh14j02CBEN7PEX88Rt0j2e30rnGZI1epcosLqsAUKAx5KdYj4lK9aP63kvuxb
         WiTNX473Ebu9VoSR1CgZZEIyedWqqUk7Nu0U1SF9F7ExOVyxEM0i9/Y8WlodVg/MUxqh
         3jR+sltVv2qjlO0rJoUTKFjTGRQYi/nMx6rFJJSY/PVt3DxqtH2dHaI8pQqbrf2rL0dH
         4uCw==
X-Gm-Message-State: AOJu0Yze65LHZiNQfp9DsLBoR2ntFEw1rf4NtATwrM0PFFYyryv+NOjm
	/Hc8MP8lyXJkciXM6NASivgXF1fYyMcXX4O1gj+69fJ1j7x7ze1phyQLCRioXc2QyHP/5dhwlfR
	TWOAyFA5uPtVMt2/aTe3cVShRdqTtUoWOvKCFfwCp15gI/vUCtOaHDe8sHXiu9kdSLVxGzg7nxX
	Tw2g2v1Ebe+9lunFQfTj1S5LaXyckQzwzJNw2nocy/GMNfGmLLIdX0mIKmQyHfViY+ALWmt+aKH
	6UiY3Qzvo/JYIEGkrgxaOwzVAjQ
X-Gm-Gg: AR+sD11QeW6ojCIWgqnhYPP3lcJYZ9uAlwp1BWGvBStpqULpGjVV0xxBmZOL9eVHh/x
	H87+hjgSzoaBBIYMKr+f30XHhdjAy3ZFg9h5tnfpC27kyOnN1AoWE8c+mFUdRhSTSmo6XvvmfFJ
	7MPZmhUTFmoalC+hic7rSyUe2YwwynEKPgzlexauGUWCjM/KRVupWiEULVCcB370oRl4ODJY0EB
	fAX7/ZZOERzB1fAz3x202H8e61vRgetozZwhiI2i3Xu97V6u8jiVRoiuCmU0GgGne5gZKfeAFmi
	ivIBvT4tTh6sRUkueAgmzREIS/giiRXKAS7gVU/h68laBL35gi4EZTytY9EhoxL2mQyzc1qYYzP
	xX0WRoehUCBuzcAn+cLykva6OJ7Uw/YlISt7ZppwWnZxKQ49mXbR2BkIhlIkzmGhw6Vh+bShSld
	RbmQc7EELkshOWqBRa5d4mTqZY30GFbYlZk9M140Q=
X-Received: by 2002:a05:690e:4509:10b0:664:cf03:cf5 with SMTP id 956f58d0204a3-6699acb0caemr1848060d50.48.1785909682011;
        Tue, 04 Aug 2026 23:01:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-669915ca1f7sm197148d50.16.2026.08.04.23.01.21
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2026 23:01:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c01ff996dso5993151cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 23:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785909681; x=1786514481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zQ/9RIR1VNN0hukmG5NlD01qt4vqhJek43rGR5IpLsY=;
        b=Kc99ZuNBjYkQ7CIJYkqTRRK0G+Yj2N1T/O1uWkAUO9HLyDOX7PGXo9d+uGS6FDurU9
         gpb0QbkznswBnc7rKxNXdfTaqkHE/l7uJDRKK5KmOV72huhkKU3ILhOckxrXmwcfxU2T
         vnxaUDltp8sb5uekf+45pNqQMSIS7cm98eDWU=
X-Received: by 2002:a05:622a:355:b0:519:8998:661b with SMTP id d75a77b69052e-52ce60c07c6mr43080051cf.20.1785909681048;
        Tue, 04 Aug 2026 23:01:21 -0700 (PDT)
X-Received: by 2002:a05:622a:355:b0:519:8998:661b with SMTP id d75a77b69052e-52ce60c07c6mr43075121cf.20.1785909674142;
        Tue, 04 Aug 2026 23:01:14 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d720sm18740276d6.4.2026.08.04.23.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 23:01:13 -0700 (PDT)
Message-ID: <8338ad7e-8707-473c-b677-be3594f7a7f5@broadcom.com>
Date: Wed, 5 Aug 2026 08:01:11 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: brcmfmac: remove extra blank lines in msgbuf.c
To: Can Peng <pengcan@kylinos.cn>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260803080912.553948-1-pengcan@kylinos.cn>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260803080912.553948-1-pengcan@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 03/08/2026 10:09, Can Peng wrote:
> msgbuf.c uses two blank lines in many places, including between
> top-level declarations and functions.
> 
> Keep a single blank line instead to match common kernel coding style.

Yeah. It has been like that since this source file was added so maybe 
just leave it like it is and forget I ever mentioned it.

Regards,
Arend

> Reviewed-by: johannes@sipsolutions.net
> Reviewed-by: arend.vanspriel@broadcom.com
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
