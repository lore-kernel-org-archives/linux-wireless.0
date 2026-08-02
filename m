Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059C439099C
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659964; cv=none; b=EE6moPDZJRZfZZAgXRmGKJ8vjBhc1jr87QD9FChn64aKLYnmKibFkvXJGU0DlkJhCN/aaaMp4UxtD8IkyouXsB7fYPN8FUnGlbUfW/LvMZeZ8kDpmcAtnTd6MUHcfLMVDo56N1gpMCFVv0QYmKWRbGXrI9kW+akI3ds7j9isIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659964; c=relaxed/simple;
	bh=paEteDYu+VpkpJUu3TA3jGp19kJt8vUY/SRmIaxxzXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ekoc8PQc+rSTAdAcAO1p8wPjD4SxWNQacxJPJz8StxKqL5tP8esMLG3dOzzBdtxMD9JwWD0lxMDkgWgEwyh1xjeulvA+a3x1d1BIbn5dI4CE1r/dgmz9EqIFDngHypHmfy/Ruv3g8gxvA4OoV1pIAPJ/3PLHDN6PFXRzdqXhUyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HQCw9lIO; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HQCw9lIO"
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-6aae384221fso1264471eaf.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659961; x=1786264761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l0BprMNy/y+4QZvQsdZngDdHnMLVEPPrcOP8U8U2Ffw=;
        b=JNkAHcdSrc6ZCMTjcri5wkdOaIAelUak4crd6N4cfZ/2Qme3rJ6mzFwN4SQqLC0Joi
         onJKsSbrw5RgXAD179Te11rirq2biZmylkz1laQQldR95BtuaL0LS18lGjAxLcGk5qkJ
         wQgd5tBAhkWOJRTiCxCoxRNjFLpk5Ds8/fMyzQ97/6JEwZNYLqjqA0GXJ9lwxKG4l1pE
         bMgAaP7MDNwu/SKMmoi5dai13x/Rgo54R86GtzGKpgfWnkvk5/wuydCnhz2MAeurYkrU
         80MzhV9sx5SKWccTHXvwsrMuXNyc41X93Srt2admAIQ6temdzcv7ASJg/dE1CyIM67y6
         0ZQg==
X-Gm-Message-State: AOJu0YwHHJLoJNXpBiw5QQsFfS2eXhyA/AZgS6jNk4LfrifNEUaM9GXJ
	EL5tS3f9bwhg1oC4Vapk300OhkdQTMrcmikOZZYQ69TZU6Vsdgfsjl+SvoOTNacqQp0eGLkQfIc
	GZZilLj9rchm7plvQTm4Ih83CIigyH+F+ONnSxE3eqx7N3GcH76so7AsPhSrcNV3n8C6e7Sb2o8
	MHcqxuFEttAkah7XD1hIw5zZUOoAEAOrRb1vcnBWKH2IYvMWFKnSO9kUyWwXgyJ70uYOOCHSA2h
	Ra9fKRvzIQxYNANlQCWGX1RkSG/
X-Gm-Gg: AR+sD11YFy7UKiUT2bx0TfYjjFQkpH7XKyT+cOX1um9qfluICAIVy66gfrwBHQJfQ6e
	JXGr5nWF+0c2mPmdmfpzCb/ayYUK0GCBqCzW48GAcurOJoyMoKPjvItvm10O8GbGJvS+9kkSwSP
	IkrNNNeqnB5xZ+wQh8qhBtZzjamWVZ4HeRWLw7sqPfhGsL3aEBGVGYZ7tZWHzbsCefhq1qub0Ff
	BeDa02Xen05HB4OjSCeBiaQvLiS9MCdlqtNWY9k6tGtAZlMIjx+Xfqd5x6SB7o0nX9FicyOPZTD
	SX984WzUQqh88QGlD1nc3LMvUcW7Tpg+PXPvXzfG0UnaK812YcNDhB7U08sf6SexoD3lS+26IVi
	X5iSBzW5mD57iWRw6pumt7CR3Yq/t/lxCbte5tU6SAgN48DBg61qRfFIlq/7XbD3n67vA4UbAjf
	rF/qthUnnOs9V4jUaO0IoVrAykjVmYlJeJHn2qNEI=
X-Received: by 2002:a05:6820:4508:b0:6ab:13:b207 with SMTP id 006d021491bc7-6ae4358a92fmr8109741eaf.27.1785659960656;
        Sun, 02 Aug 2026 01:39:20 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6ae39d5e344sm463333eaf.1.2026.08.02.01.39.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:20 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e53b8a302so228353485a.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659959; x=1786264759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l0BprMNy/y+4QZvQsdZngDdHnMLVEPPrcOP8U8U2Ffw=;
        b=HQCw9lIOFaAuU41r+HXMD10ZE1QSUn1yz+NgyCr3DYmnu746HcBbIdTC7eYVeu45z0
         KK0C/ntXVTxyT+sbtdM/1dtQqMzFPzkFmPVu1o5G4ktlZsVbH1/Fnpe2ngIcqnjW2PYi
         WcmMKmKSuQSvfoamDKNIRJPLk94laxSwnC4bU=
X-Received: by 2002:a05:620a:a405:10b0:930:e48f:47c1 with SMTP id af79cd13be357-934a0a8b208mr890886585a.35.1785659958775;
        Sun, 02 Aug 2026 01:39:18 -0700 (PDT)
X-Received: by 2002:a05:620a:a405:10b0:930:e48f:47c1 with SMTP id af79cd13be357-934a0a8b208mr890885385a.35.1785659958263;
        Sun, 02 Aug 2026 01:39:18 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:17 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Sun,  2 Aug 2026 10:39:02 +0200
Message-ID: <20260802083905.3819981-5-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725013528.169218-1-bogdan.nicolae@gmail.com>
References: <20260725013528.169218-1-bogdan.nicolae@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 24 Jul 2026 20:35:28 -0500, Bogdan Nicolae <bogdan.nicolae@gmail.com> wrote:
> Zero out auth_status on initialization. Otherwise, garbage will
> leak from the stack to the firmware (when ssid is less than 32 bytes
> and/or when params->pmkid is set). Then, pass the params->pmkid to the
> firmware (without it, the firmware caches a garbage PMKID on successful
> authentication and denies a subsequent association request that includes
> the PMKID).
>
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> ---
> v2: Split into a separate patch
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Please add a Fixes tag and Cc stable:

  Cc: stable@vger.kernel.org
  Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
