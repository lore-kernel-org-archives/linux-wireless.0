Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1668330DD22
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469738; cv=none; b=auot8ibBAWFyPNjRi7lzjR+s2u1sJ7AkrxwfEfb9ltcYR9nj/DhdsaHYzldcEOztQ5rR5ePWI4tHfRFmz3ZeT7yzihrIKWIIgkfApxbq3QW0muTwjxn6Gk/rlFpN2R237yr8N1XQ+04GXoBGs8QiWsXIf/VXGhCTM+f2V4VgQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469738; c=relaxed/simple;
	bh=yoQIN1pVS/nNX/pfn9KRUl0NbCP5MEtzwzgUxPtMgeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF3/Xl2gA7qjeu5m2Xvt/jYzoU/XkPUC20i0pMCd1VmJxieQ5+UoF/8U5bEAZ0G/cmqy5eEU233KfiVhSHnGilp7kO7cusOR4pRDOoY8YoCAJ0vTE4WDPVMIRPAvR1KUEKhdwjgRZHwKWdmEUcNykkn+Nj2it9FIcAh5LVcY82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nI33hc84; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nI33hc84"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4994d41ceb9so18125e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786469735; x=1787074535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yoQIN1pVS/nNX/pfn9KRUl0NbCP5MEtzwzgUxPtMgeY=;
        b=nI33hc84CPjyrh5X900COoaNN/Gjk4yA7NsmY2zagG+nm7Ln0RTjEgPHwE0+jwmMuR
         n4TO0PTXVHWrkP8ilKq37FRJ5t2wBlgfweCczk/qfEEB/hrNT4d6ncp+WK9w4GO0Ee5e
         8WvfptyYB5bAsrV6kLA1MsjZIhISvIKO7ks9W5lCjZdSJhpq7DQxnsWk0rFMh2UDX1+a
         8ExRMRu+O93fyR84fwgAKFuVWm0/xqR81Q93IAvv87UDZuZtR5GYLDF2ty2qN1FAGrM4
         C+JeDnLGpG9p+y1Amd2xLHpoSz+HaVH31l1om4wKMpDLyRARLmurp099ujdkTX/K+Osj
         GKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786469735; x=1787074535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yoQIN1pVS/nNX/pfn9KRUl0NbCP5MEtzwzgUxPtMgeY=;
        b=IrMj24FF6D15NnD+zOZxmxb7CLfptAdPVTsy4reo4VaByzHbQ+RfCcy3/8tG1iDJkn
         Vo4t/16BtHcrOxiqSAfeVEsPOok4AE/2qyE56oBFiZODWt401qWzSivcLjGjlLOCGctf
         oUQwKbSS2+Y/t1H42vRDJ8CBjJ0UewG0OXjoLfyacs5AeIpGPG3AHStx6EL1gErgXKzP
         R9SYeeKIfcOK2sMDEM8EkyqN6NMxD7P5xf7hxi/ZfN/GvS5ZsAiZqejh7CewIVaD6JR6
         BTaHWIUNBC/Oqg5AJWZ6BTOIJN9YTxD/M1NwUfsZG5wT5YI+uHcyHSesNNp5Rkqa1nUx
         Spow==
X-Forwarded-Encrypted: i=1; AHgh+RoPTd7xPaPZZGRI0E9Q2g08EpZ5VlXWD7bjm36+m558xG5jso1AJ3Q4V20lsU0HN5Z+UL2mnuZC4UQUf7C/1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmcf25udMb8/mqME53TSn3gv5whgEcw27umZp3ZzDGhmkx3Zw0
	+reYqbY39Lv07j9KWbrfLXQs6t/p1VBm1JM08J8Tde/CwGrvA3JzKu3B
X-Gm-Gg: AR+sD12SQeuKj4azoMbsbmwH6AAMroruSyQPzI9QZNEyoAk+uyE0Hsg5l/HtMcbHSX7
	wQL+Pn2t32UjYeMGBhtiagpvo5WQ03bDP2MVtCIq6RE6Y87SIulF+MdeoZcIDUbEJdFERYg4Ruk
	Ze9sWMeUvM4paZRsYhcORc0nm5US7r7wSCVE1xCa8aUwaWgslkRLhia+DcWHvU6fbPsAxfCSNVz
	6G4HEqaFGiW+a00EZTP82c+K/K62Z08OVFaUWm85fzpnMTvhlHI9Ku4jyamyt3UtC4NBhutZoZ5
	urXOaiFQEAgPfoPMfie6Y0Iv434dewYagNGHobOdg4CoHYc1JIidodiXYTBUBPiEbqAC+j7rXWn
	pgwv1JP5FdCWKGO6AT0hRbgxY5Kp0H0Z1TDHlDTvXrf8AtWV4rKkHy9cfSqUHG8/B4bSefE+S94
	b4QIjkUouYGMmfFB1XC3rVCVfQrI6A93ijhKe79+oCxs5LO3Lapa50koBtawH65yfRefrchmkF3
	9P+Hsmu6xII3j07HrZuTuxN9CfQuhPRYt4LRX0/qXF1R++Tz28DbgM=
X-Received: by 2002:a05:600c:5254:b0:499:4d41:cd13 with SMTP id 5b1f17b1804b1-499783af3ecmr42889745e9.0.1786469734931;
        Tue, 11 Aug 2026 10:35:34 -0700 (PDT)
Received: from m715q (host-79-35-51-177.retail.telecomitalia.it. [79.35.51.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997aac48f7sm7335875e9.8.2026.08.11.10.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:35:34 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: James Prestwood <prestwoj@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
Date: Tue, 11 Aug 2026 19:35:05 +0200
Message-ID: <20260811173509.179926-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com>
References: <20260730161531.3535100-1-andcov23@gmail.com> <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi James,

> How does this present itself on the station when this happens? I'm
> curious because over the years I've seen strange behavior from basically
> all vendors of access points like:
>
> - Mysterious association timeouts despite good RSSI/utilization.
> - Denied FT associations with reason code 53
> - Successful FT roams immediately followed by a deauth with reason code
> 6, 7, or 9.
>
> I know the above could be from any host of issues, but I'm mostly
> curious what the client sees with this specific FT key upload failure.

The common case appears to be that the station sees a successful FT roam. In
hostapd, wpa_ft_install_ptk() simply returns if its pre-association
wpa_auth_set_key() call fails. Since wpa_ft_install_ptk() returns void, that
failure is not converted into an association status code. On the subsequent
WPA_ASSOC_FT event, hostapd calls wpa_ft_install_ptk(sm, 1) and retries after
association. If that retry succeeds, the only visible symptom is the AP-side
nl80211 error.

The OpenWrt field reports reflect both outcomes. Most occurrences were
described as log-only, consistent with the retry succeeding. Post-patch tests
recorded successful FT associations without the AP-side error. I did not,
however, collect a station-side debug log or packet capture for the unpatched
case.

There is one more severe report from a three-AP mt7981 deployment. The
reporter correlated clusters of this error with Android and iPhone connectivity
loss. One AP log showed 14 key-addition failures, about three minutes without
the client, and then an eventual successful association with auth_alg=ft:

https://github.com/openwrt/mt76/issues/1098

After applying the OpenWrt patch, the same reporter observed several days
with no key-addition errors and normal roaming. This is useful operational
evidence, but it still lacks a synchronized station trace, so I cannot tie
this path to a specific status or reason code. The initial pre-association
set_key() failure alone should not produce an association timeout or status
53. Of the cases you listed, a successful FT roam followed by connectivity
loss is structurally the closest match if the post-association retry also
fails and leaves the AP without the PTK. I cannot currently connect that to
reason 6, 7, or 9, though; the station-visible sequence needs a capture to
determine.

A synchronized station debug log or packet capture and AP log around one of
the cases you have seen would be very useful for determining whether it is
this race.

Thanks,
Andrea
