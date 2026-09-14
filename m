Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3703EDE60
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416245; cv=none; b=G7SKzz5kfpI+9IxaY1EraaHKjF/jNlV6zNnpQMmkGb3oEsD0C7hbUUy4XhZvA+6OciLxil97k1VZi0xsRSQcrqgSfU1wS2BYa4hJCGJR6TYUbXxOfowVfQJXF3dLOiy4nR/+CUOX2WX4PrjUm6zfc89YqE99luOWtp7gFphONkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416245; c=relaxed/simple;
	bh=6LuHeB2B9gfDtvW//US1kxn9aeemfl97PMPh7pLyaE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmrYtKDGS9YQ91OdiZa8KcCwUBT8fFW6FSfHbWhtD+NmeJHEvkLv+HF4vRo5vTA/4FPtLZUXixNRuCGlX9Jlg/ohEh6I6unQTUI9a3Ui3Gfh/0D3gM8hzoRgJp4/9gV5xzQcQgfMaVezImQfhIp0otybH5D+p83pHuMnlVMXSQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=A6w98gAt; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A6w98gAt"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-806a2a27a4bso985457a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416242; x=1790021042;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Za6WPJocD8FEguqITMQO4/agEkWnsmf3pOAvhAhvrzE=;
        b=w0t4l3Uk7P7Id+SRHfBVFLajzgYqB//Zwq72J36SyrN36TShGwjHplXzzfeob9fH+E
         zfuMule/+giE+TxYZnSuAlwC8FHtvwC5ZlZTyAQkv+i1mRXBHWQyvdqC1qcXHZLGxHHt
         EaIZluL5834+KQaAS93FIE96Wh5hTnW12M2kwjJkUZtJZfDctTOH71qt6gh5NEcbLBNt
         92qWK7Xdt0X8LrhJ5I+u12Kwd6wjQIqJrkbSQMDxAzrHZXh7NU8LlZXKtAL3QgwAYYa1
         VonsheaVuV9tgziFO6Y45Aqz7HK9lGVtWDCNhryS+bFVNY/ILG5ucgtEEhAU+WLrpi9W
         ez7A==
X-Gm-Message-State: AFuF++mjy+PjxYFwHwfYXJD5OWD1lu65VBxo9PCx2lg2M51tnoKyrHzq
	4IAUSpDV3gwFsk7nxer4iI0ilAS9mPDOJwVJOJshHk9mmU/SSzdZSMuCEXeuqhQUrIU/ychzPrl
	1hQrJacncLqMl4QY6H0iJ73JOzI48YNu/CYdbAbJbljZWkdbx4U790pfBVXrTsUTt0NzeZrEhOo
	CNcJYqiTx3g1jhldCyQsXpFb1tyeSybmIAVYHtImQ1mdmnTpGmdiv2YpzMuVegmWQXb4Mei6hde
	Yz/F17Oo6DUP/pJhk6tyeezBmeD
X-Gm-Gg: AYBFou1gbNLZuhKkNgJT5/yOeWQqzajYtFkYYm7/edZZRPzA50U2RVwlz67VLRM7r96
	lfTO9/DHgDRRApe0S/27hmhWlxC13xXC0hQyYNrGibQXFzcB6KobQiXeLEilB/nb5/XWFDEhiHy
	U4dL5iR7NLbBKRyEng90i1+VjYck0Y8QsrQ+2hoOw6irHqBdn9CQmLt45lAZzojtVS726Evhu7r
	eX2h2UmT5B5kn+309Dnt5RkQDy1AxCpp/K7MqDrOn8O4bPMdd0lloVJccsSKnoF4mmrG/IS+0zm
	LIF2rj4lzswwsTfxMax3IoAhISCx4qEhn9XJ0gpLxyu2R0TO0HicDaXQbpXeiUFAogKor4r8ERS
	UB19Twf3tZd2fgyvDoPOMspBoMcnLeRp1sO5nhUM5KoqBlzZKgW6OC7MoXx9GMUJcrUdIXXhmet
	SbaoKAXwrNVdEBTXjyg7xOJS1P9+9manSxv1vxCmc=
X-Received: by 2002:a05:6830:2aa3:b0:7f4:d16e:45f9 with SMTP id 46e09a7af769-8089826f1e3mr5580708a34.7.1789416242074;
        Mon, 14 Sep 2026 13:04:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-8063e01c35csm3921647a34.6.2026.09.14.13.04.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5304f2b5946so76768721cf.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416241; x=1790021041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Za6WPJocD8FEguqITMQO4/agEkWnsmf3pOAvhAhvrzE=;
        b=A6w98gAtEM1imXrKUcJkNdlyHH+4e7Ffv2rxCTeybBGBhaTS0M4rqvtcGvWSthING7
         AtWSlBEjXL57dOZ4v45ucSrK1b6MOX+6xZGALQ2ZGUc86KPRm0CcM1i4uJcmSOi6m7XQ
         AnWIVeZAGNz41J6kot8olZd7hSjDIIB4CEgVU=
X-Received: by 2002:a05:622a:130f:b0:530:cc3c:c62d with SMTP id d75a77b69052e-5310d079411mr57824081cf.44.1789416240897;
        Mon, 14 Sep 2026 13:04:00 -0700 (PDT)
X-Received: by 2002:a05:622a:130f:b0:530:cc3c:c62d with SMTP id d75a77b69052e-5310d079411mr57823351cf.44.1789416240151;
        Mon, 14 Sep 2026 13:04:00 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca4b9c54sm105946511cf.20.2026.09.14.13.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:03:59 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: =?UTF-8?q?Vin=C3=ADcius=20Ramon=20Fontanela?= <vfontanela@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] wifi: brcmfmac: allow ISO3166 fallback for BCM4350
Date: Mon, 14 Sep 2026 22:03:57 +0200
Message-ID: <20260914200357.1743468-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAKuTqBQoU9sSN7AzOQ5kBbBjt0CD=N0KBK8GwocBn1dOEVdVNA@mail.gmail.com>
References: <CAKuTqBQoU9sSN7AzOQ5kBbBjt0CD=N0KBK8GwocBn1dOEVdVNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 1 Sep 2026 11:49:37 -0700, Vinícius Ramon Fontanela wrote:
> BCM4350 devices using brcmfmac on x86/PCIe may have no platform-provided
> country code map. In that case brcmf_translate_country_code() falls back
> to ISO3166 codes only for chips accepted by
> brmcf_use_iso3166_ccode_fallback(). BCM4350 is currently missing from
> that list, despite the adjacent BCM4345 and BCM4356 being present.
> 
> [...]
> 
> Signed-off-by: Vinícius Ramon Fontanela <vfontanela@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
>  1 file changed, 1 insertion(+)

The change itself looks good, but the patch was corrupted by line
wrapping and stray text, so git am fails to apply it:

error: git diff header lacks filename information when removing 1 leading pathname component

Please resubmit a v2 using `git send-email` to avoid line wrapping.

Regards,
Arend
