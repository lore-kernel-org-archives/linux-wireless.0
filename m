Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB54420E89
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 21:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754285; cv=none; b=pLBIpXW4+08lY1LhmMCMVCEdcVJuePMsWTldA4WkvuSyVVRg9uxmX4uIp4Usc1EiMUHA6h/SZIaBmVXgGaVDw4Um/OPfaIIPkRxXaVdbpGSDeplcHuXbWU+83vOrJox0RTSIfwuM0jD6e5IUb3/WkRU1HjDHMULXlMn+UJrPeNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754285; c=relaxed/simple;
	bh=N0p6PiB8ECqCDHv9h4Sz/99Ar6iRQzrfZUWaqk/VGSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Xm/XnPHs1NrDM0VtmSW37SpGm8r09hq8tfmvr9JCkEeW9jYuL07UFSvE3Jt7p3K09z9604N272knwI+6Sn9i+XhgdueHzBwR1artsYkxglGn/lV2yY7wNm7xDWkSoSahJsWMG5mVuxqVo8iGKbWom1JXx6g+8ZsGkpnqL7CnxKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgXWiA+D; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgXWiA+D"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49548aebcd8so40279655e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 14:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784754282; x=1785359082; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A4D+GZZKGMWGe94z5BXhq9XLymOxqkePetI33cKXtUk=;
        b=kgXWiA+DrvrbJIlXdWxH8j2q5eucH7rAl+z7JTt4UzLV2sgVIXY41Pl7L0KJYF+Zv5
         cedLKhed2BAAizw/QQ7FBGAgjvDsbLFeaWqtmlHKWh0v5AYZ6a3j3WDIDuoA5DMLogtB
         aY+QDwaYNL+Y+Vtwk7h2X9S7MAbzqTY/2IEh+Zou7qaA7uQ8UFH3X0gPFRNvzNHxyKaB
         5GGko0X0ihSQOyFHB/bpzvVBeo00XakPb92jqy799YZbT5ki/nmels6052agxdqCtBVs
         saaoQvJrpxtQxEQmGFa4kYoCeNh1d7c9xA25iu68jAqW6tbSNClR8c+RdoHf/4UVo5O2
         MU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754282; x=1785359082;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A4D+GZZKGMWGe94z5BXhq9XLymOxqkePetI33cKXtUk=;
        b=f9PKwVe1L/susX/MQYNBdwzAmyVNR0hEoxBvgnZjJVlSkF1hYN84rZTOzi0odJL5St
         aBnlEfNT8ts+Y24MsiYs35XuVV1dWL8aHIvWea81R/NYsxEB/sv61EYbsvFsSijmSes5
         uAplNZ923AYQ/zjM7x5L7mZY2fcxZHMHTAuCE8k2keT/+8KnaEU1Ob8tMw/4T+4bLW+I
         eFZG30Uu2FjDZh9iNvrHx8vxYPf5aPfkiQJD4OTsM0xcGf165Y0n4lVdp0mMM9UEWBG7
         z6IIueC+Ef+Adzg/LnEMfHV6GUSd/ZVR/nSzxqiLzAtJD1B3cMb2iaWU2a3u+DP1Hqqu
         l54w==
X-Forwarded-Encrypted: i=1; AHgh+Rp508jC8lTnCHt18xozSD1YuTku0aJ6OVVkjPDJN+zmJVAiY25ZQ8lms8hDXKpmw09S/QkIEmmVHyeJqEMSPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpxNuqtrc172JBpOzIrYyW6Khvmz0VSQObO3+air6BptCoH5Vh
	fgddLcgWOFwOf/OFv7EEIRrLT80skbpoh5KKbbEQlgJJohoulci1bBZtG8rPtQ==
X-Gm-Gg: AR+sD13rGTGqOhyhRmLhXvD093NTxTuOtgonZPrAZhg0xtX7tlK/khTp0HTwgMlzOMj
	nXRuI9BLY3WV3ltS5bzdAzp3DWDiunoFFoe7nGUJ4sKGeE8gN+TaeFKJazjz3FcUqqO1pvFICpm
	YCZxvSMjL3dsZXjZMx/mbr2UximbAV7DuhLTObTLInSTmNwiumIDo3Tcld8iVbQ/LN7PUnugni9
	1wbAoQhxUYr/AJBh8HtaMy6lks+J1QnVD/z8RzF2mWlPTK04L4Zni4m6iDLLRsNWJeAyTKc+aJO
	69QHBzWiKeF/gFdoIX/8fOfOJzMIqlxipUvFJN1CJSPrXwfCXRJ1vsYcU8zgvTL0tlTQZgTumqH
	YiZvK/3i661NXHwGLxfvr/f/+vz36VVEMSZfWNtG6jyU1hKQ+02hOfoGeXuH46wr3fHeNdJTPcX
	OcJnsuiIwxTmAfsuwBpBJw
X-Received: by 2002:a05:600c:6287:b0:495:4e1d:82e6 with SMTP id 5b1f17b1804b1-49573d25f4bmr2492415e9.36.1784754282118;
        Wed, 22 Jul 2026 14:04:42 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a6354a3sm149226045e9.10.2026.07.22.14.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 14:04:41 -0700 (PDT)
Message-ID: <b539fe5b-8a0f-41da-a8ed-e6806588124e@gmail.com>
Date: Thu, 23 Jul 2026 00:04:39 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Related report: https://github.com/lwfinger/rtw89/issues/412
To: Vladimir Popovic <vladazemunac@gmail.com>, linux-wireless@vger.kernel.org
References: <CAA_bARL2E2bOtf+Sontp93-Xk8CZ+k7GfbearRf8WyEMgnue6A@mail.gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <CAA_bARL2E2bOtf+Sontp93-Xk8CZ+k7GfbearRf8WyEMgnue6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/07/2026 19:26, Vladimir Popovic wrote:
> Hello,
> 
> I am reporting an intermittent connectivity problem with the
> rtw89_8852be driver and a Realtek RTL8852BE PCIe wireless adapter.
> 
> During normal network activity, all network traffic occasionally stops.
> The Wi-Fi interface still appears connected to the access point, but no
> data is transmitted or received.
> 
> The connection does not recover automatically. Disabling and enabling
> Wi-Fi manually restores connectivity:
> 
>     nmcli radio wifi off
>     nmcli radio wifi on
> 
> The problem occurs intermittently and may take a long time to reproduce.
> 
> System information:
> 
>     Distribution:
>     Fedora Linux 44
> 
>     Kernel:
>     7.1.3-201.fc44.x86_64
> 

Hi,

Try kernel 7.1.4. It has a fix for this.
