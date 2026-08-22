Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2133AD9B
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787423066; cv=none; b=SHAkA4xluFGJyysYJnvKPl1Bl9Iu/ZHX5fRqy7VD8lQLS0xY6gH/XLNMyglNRDtwpeLH5XvwmEg/uSYhI33nxjx/OpNADlmdHr7ph5dGq+2uyG8V5+2lqcy1pAc5L5killvK2J3E+DcnDjs8OxIDEbljg/XJLtnJu3CKu9HaSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787423066; c=relaxed/simple;
	bh=oY5nYB7gBY6C8eCXHKb+BZy4cqHwJbtML45bzXFEKOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VNR00TNtwcora08Ip671CcwgMzCzfzIt7yP4BvxgTt9emn150B2lPlOZ/fyixpBo2sTkzgC3S90917kmFbwKsCEUQdYaRGs4Oe5CclKS+2Z5GKGoNX4MgIechltRGefbcWikh1kBQXkmhtaes3Cnqk80C+F4Vwek6O1LuVYa8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Z1ezlS2l; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z1ezlS2l"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5bf94664327so1190321e0c.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787423064; x=1788027864;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=r5+8Ud1cCOK+HFvXxozibZFG1qXAcRUxAkWSfbO6NkQ=;
        b=PwM5jcWf7sfG6gL1jIY0lyqxJjoh3JyQhZVHtVqEpibfCb+HYwjdXZkQo0wipJKuTO
         V+Q9clz2UX+T4POcaifivFGTW/y/MaqDVJYC4DkJZmNVyYRkJ6Mqg7LCAkgDQImyzHno
         Z7gOGiqjCsT1ZU8eKVL6zjH6Q18cVIaOJWWDJTkp7rGcOZH+4rdqJU38lrMwIyK6T5hD
         +MVF+H9lbHgy2PULSIrowk8pWb7QIrc2P/y6TvJZDy5H36NM4r8b31RRDnQUjVQgG3H3
         FCqtvpdceSik+KEIZsbBoXxQAaB5WvyrTfUBHEe/u41RfL+Q47XFMAJLUyanKS2/Y3oc
         Bl2Q==
X-Forwarded-Encrypted: i=1; AHgh+RrsNil565Vg402g50l9q736R/L3Zro3kb8xrxGcLTUSAyYHUQTXVtpe/D0N55noQIXpg1MT58DN5TbevGo0GQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mf4rbEyrgyAgmqB8NqcTO3BmUl0kVUlB+a63Qawr7Lay/d9Hsr
	/+DInXHWhhDB3wPW8WP7uypFvrkf1siVLT2FZBfhe7Es9E6Yl0fYrSTCR3rbpuhN8Mp5h+q8Ffw
	kPWal/IF+axSVbyPe5hqA0X6JCP5TP5swyUKgzQNQfE1RU57dRNOZZdmRFDFw3nZURCTfd0vJjO
	npUPrLLYxIp2/wWGlKKwt3wiyAlw2pqbnepA7GQIfWDmlxyuml98/nqmxPDIf18LfB+8HHp0BIy
	fsIK14en/dz1AFBm1jBGK5Npdhr
X-Gm-Gg: AR+sD13+STD3mebYHJ5sJOJg9IejF8FllvWsBC2E3/grbdoxGzKC8HDdiqlAByD395L
	zSB9j/PvYp6tg7Dmd+xigFwgM3JDTWWFbyg4qQjbAfela9dnWS6dBXJvUqqiPX8hKFzt0W73ZLM
	xpYTNyrslbLpE+tm57vWFuZ4FtXERhU8V5/f7zlhIJoUtUsI2S6MJdOCdHi63oLT5x/8KQZnTbO
	aJtF1bi9OKM9jAHCvAxTVRXpK77GQ8IcGnHhoEYsxjUzL1M706wVhcelKEzhZ6tk6KLiEvDzoZ+
	O7P3nbq5xx1BR+Hm4UGBBrR9ZBg8AterxvCfK9nDGMQ/8uL13v+81N10U1haN5TlpUMRUnB30oN
	9ZayTqfB3O5dAez56weE7lV6XRCb0+EfgQyfQn/c2LqSeyJWcg3mXUa/13O5c9BiXdFFgbGoQBK
	z18rGmLhT0dEUdhqcsybUlFEerLsALjigep/M3BWI=
X-Received: by 2002:a05:6122:2216:b0:5ab:26f:49e3 with SMTP id 71dfb90a1353d-5c60de34cb7mr3061792e0c.3.1787423063716;
        Sat, 22 Aug 2026 11:24:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c5e27c3cb4sm2734434e0c.5.2026.08.22.11.24.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:24:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cee894b3d8so40029045ad.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787423062; x=1788027862; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r5+8Ud1cCOK+HFvXxozibZFG1qXAcRUxAkWSfbO6NkQ=;
        b=Z1ezlS2l6dSJNKOCtEJZUhzye2ye5kD72toyoLeGvIjsD9xNNSvq7sZB2btiXRD78f
         cqimIoEWw6/vA5c82kivjBkJ0BZf/9Ir8931FdDfW8cBHzTmpUJaTbll5lEIyYOxDaLz
         J4zUw0araaItVEQq+ClaZE0BarIWCPMRxkDy4=
X-Forwarded-Encrypted: i=1; AHgh+Rq+8af7RynHW6nl7nu3+IIXH7892EM8wMgRHUxNrvugiCvq+zt6YD85AmGZRndT0WRGXSlwis9ROvuVZjkzPg==@vger.kernel.org
X-Received: by 2002:a17:903:b8c:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d670bb70d2mr140827545ad.7.1787423062464;
        Sat, 22 Aug 2026 11:24:22 -0700 (PDT)
X-Received: by 2002:a17:903:b8c:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d670bb70d2mr140826885ad.7.1787423062030;
        Sat, 22 Aug 2026 11:24:22 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f923f2c0sm13512614eec.30.2026.08.22.11.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:24:21 -0700 (PDT)
Message-ID: <71261493-e974-4f5c-a453-b4c2e449baf5@broadcom.com>
Date: Sat, 22 Aug 2026 20:24:17 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] brcmfmac: add FT/OKC roaming offload support
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, johannes@sipsolutions.net,
 hsin-hung.li@cypress.com, linux-kernel@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 wlan-kernel-dev-list@infineon.com, jeff.johnson@oss.qualcomm.com,
 Carella Chen <carella.chen@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 21/08/2026 09:56, Jason Huang wrote:
> From: Carella Chen <carella.chen@infineon.com>
> 
> This series adds the cfg80211/nl80211 and brcmfmac pieces needed to
> support firmware-assisted FT/OKC roaming offload.
> 
> Patch 1 adds an nl80211 extended feature bit so drivers can advertise
> roaming PMK programming support without claiming full 802.1X 4-way
> handshake offload. The brcmfmac patches then detect firmware FBT/OKC
> capabilities, keep roaming-offload connections in a firmware-supplicant
> profile state, program PMK material for FT/OKC roaming, report port
> authorization after offloaded roaming, and advertise the new capability
> when firmware support is present.
> 
> Changes in v5:
> - Reworked nl80211_set_pmk() to avoid the 80-column checkpatch warning
>    on the 4-way handshake extended-feature check.
> - Added kernel-doc for the brcmfmac OKC profile state added by the PMK
>    programming patch.
> - Normalized Assisted-by trailers to the checkpatch-accepted
>    AGENT_NAME:MODEL_VERSION format.
> - Added Johannes and the wireless/brcm80211 lists to the cover letter
>    Cc list for the nl80211 and brcmfmac changes.

Hi Jason,

Thanks for the follow-up, but looks like it happened again. Missing 
patch 5/5 as happened with v3 series.

Regards,
Arend

