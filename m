Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD68C30D40A
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093665; cv=none; b=n4tAtFM0jEB2k+rDxoKabs/WuAWRltd0wAdkwcRYYkCdO8JgYdLoftKA9xyGEay7L5/yKpnLQmNO3ncaD5TnHF6RAc6W3A35PGzmqwnKCjxtNuI+GgPn/QVowlF2kkVpbGz1kG8qSH9Bg37cpl87eCDomIS+Ecst61WpWdZ32TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093665; c=relaxed/simple;
	bh=fyLOzs4S/leSr8Df5qHayjyTwwiwPthIuUyGjrAo7uI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h8mcUmvdHwEJB+JcDgzCLkfFqWjYgVT6EluV5T8hGx7L1BLQAtZx239JYjUrNF42V65plceuZOn31jTIsHrrl9KGC/H+nOVfDFhXhORSx0VuXIjhZC+o7zfM/Dl2BCeI8lJ3aG0IH2vlpXPTrmWXmRx2V7kqBxqbeM8dhyg37dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iJGOK+AG; arc=none smtp.client-ip=209.85.161.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iJGOK+AG"
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6aaee9a5084so1190757eaf.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093662; x=1785698462;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=f/GC7/JY8dkQF9VYMmOxneNdfen5EFzs8r5WpvRe5Po=;
        b=l6Egr2clmActlDTroXJXl6yydayTwoHHa86l4yx30lKWDt2YbCvii0vM5ITsp4zmLA
         5M7VnT98Yd6VPU8wqmi3/jBaKFkGYyzIkyNmC9jzsbwfrzQSApdZJc6TqyGClySDgjdH
         ZdbrXZdf8BAmDTKhb1SQ7EnOc2Qvgn5egNTFiQyCMY0pO91KXfM8QaOVyxeFzYBQ0gDx
         PqzaaNe/21VDa/cKLxedWGXbVwzr3nUIl4dkbTZPLD7WmNNqxGJ3Jr3p7RZxLq1Bhfdj
         s/mzKZQKaDmX/EY7jgsrN8DhXL900qBtuf6telMDlYNT+TmdtqwOLylPk1KS0JjS6NtM
         6TaQ==
X-Gm-Message-State: AOJu0Yxx5QcAnR9Ga1qhX1Rd1TqQRzNfGDpRReTl3zwJfGAbqsKgcM2B
	WPrhHbMF++swu3OisAdegETg0mMIvhhV23d45P0YS3CBu89FBfTUfKEoXdJHLMjdG/R6qx8/+go
	5IiCpiRNZMtdk4loXVtCw0qM4qdSZt/+3HVHm/9OaNaYQ4is3GZzNm+CtIkahIAtXxxI9Z7/Mzs
	GODY5TgjX/etlYK23cX+O/i0KwMg0rxqxrHnbFN0+vnJ7R5umepJiZ+60ExAXYWUQ3dBWwB7m3L
	3fsCPSTziDUVrQ2CoLAjuCFtMMh
X-Gm-Gg: AR+sD12idg4Sfoz119wzCk4hSOhKObcNRzNCI9cqXHKhqBkHI5UCQuojWZAzLKunc6m
	0dlbQ9Sl+XkHuL1o9Uy2xrIFrrR4Z0XWzIFTVu9s6vB94egO+mF25VDEp/kqmJkNO/WfxcTvsRK
	h0aWmA9e/zcDRP/VqGOvMHuPDroBZnoKO/DDqu0lQmbV/nkyAZHtoEv/Nmq7rlddtNwvnIWdg6R
	ptiLr3LUiVyNEC1uY/pwm2X3bh2jyP1pxueS8qFeKSDtqiSeKWYWwROGS87nPcHOzQWdvUBV3GE
	s+yYYczRHF1y3aO/OLqn7/kUywRBp4wdG1DM+pQPoC/1TElS6ra77b3vm9pSf+J/POq47MdO1zh
	jtMTZWJuw3gUQGVy79xdWj1IpCjS3fbRkUvhUznBL7eB2bjLvBDCZ0eKQsnF9t9ca29MoTjvVPu
	s32cD66CjERBNAfuphwuV6ZzxVLHFdErSx6WOgkmQ=
X-Received: by 2002:a05:6820:4d09:b0:6aa:a1b5:34c9 with SMTP id 006d021491bc7-6aaff7ff169mr5340070eaf.14.1785093662495;
        Sun, 26 Jul 2026 12:21:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-457673a7ffcsm1190768fac.11.2026.07.26.12.21.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:21:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so2604407a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093660; x=1785698460; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f/GC7/JY8dkQF9VYMmOxneNdfen5EFzs8r5WpvRe5Po=;
        b=iJGOK+AGpw2CkEbnj50wcebYkiwi6YAdYtW9uy6mi/MfJR3/sZbkcjBaX63QKIPGsx
         YsuKL0MY4qmRgNpcct6/N4B8ReBFlErLiIrvQvPKKI6+NAFDzh1muAdtz6AQMBQFq2Jh
         cCytyiJPwD7azc6SUGVKyg91HXLTl3/aaGS9M=
X-Received: by 2002:a05:6a21:6da8:b0:3bf:7c02:c46f with SMTP id adf61e73a8af0-3c67dae4388mr6673905637.14.1785093660106;
        Sun, 26 Jul 2026 12:21:00 -0700 (PDT)
X-Received: by 2002:a05:6a21:6da8:b0:3bf:7c02:c46f with SMTP id adf61e73a8af0-3c67dae4388mr6673881637.14.1785093659625;
        Sun, 26 Jul 2026 12:20:59 -0700 (PDT)
Received: from [10.229.42.29] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13015052sm43706517c88.5.2026.07.26.12.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:20:59 -0700 (PDT)
Message-ID: <9ca181db-7bec-4f6c-9f42-4a66068af354@broadcom.com>
Date: Sun, 26 Jul 2026 21:20:52 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: set a unique cookie for mgmt tx
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260725014411.170340-1-bogdan.nicolae@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260725014411.170340-1-bogdan.nicolae@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 25/07/2026 03:44, Bogdan Nicolae wrote:
> Set cookie using an increasing atomic counter. Avoids mismatches of completion
> events later in brcmf_notify_mgmt_tx_status, where packet_id != vif->mgmt_tx_id
> is checked.

Thanks for the split. I increased the scope and been looking in the 
cookie usage in the wireless subsystem. So I have a series lined up to 
change the cookie to an input parameter and have cfg80211 hand out the 
cookie value (it already has cfg80211_assign_cookie() function). This
will also cover zero cookie fix here. So I would suggest to drop this 
patch and only let the PMKID patch go in.

Regards,
Arend
