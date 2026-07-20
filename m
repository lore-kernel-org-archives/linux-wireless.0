Received: from mail-ot1-f97.google.com (mail-ot1-f97.google.com [209.85.210.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3334DCCD
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 19:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576949; cv=none; b=lO5D5IrPpGf7Y3cKD/92H0lW0Iw7m1qOSstapgz72NzWttG6ZZQMMme8RuxNUuB6S3JFgfyQ6+w4gVD5lkyQgGL83d3dQAt5IqjVgSlbaRVUNVD7cd0bo79MbHuffI4355QsWiZdOizAR2aQfaP2r+2qYRg08fu44LFMwtJGdg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576949; c=relaxed/simple;
	bh=GpwzMcCRlrGCMNpB+RWtFToyJqACpU98Z/yPN70gqNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM2sR/LUr58583MmY2dg69QPlf3MX3C0/dk6ZbXll/rs69b/a+PS5DJw8be8OH30DnaUHBweJ3c2izqSn8fRqm+F3WCaXmV30L/CKNtwcm/dnkeKLNENnc2DitM82COzm7Lc76BIdZpAHtBNyKY9v4JaKQpYYfH5uR6evlCA6D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iGN6H64Y; arc=none smtp.client-ip=209.85.210.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iGN6H64Y"
Received: by mail-ot1-f97.google.com with SMTP id 46e09a7af769-7eb64371a2aso4409776a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576945; x=1785181745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iU1p0NoD+yje6AFqPCJghg44m+FupeiwPUYO76Klhto=;
        b=QeVqVBN9dF6NX2hp8VgVJWybj18dcczPmZPeYIe13HjQO8TMCBf1XNq4Utrehenb2v
         9UxCsJNgcmW2Q9FBEucRqYy4zjFAddrGMCJYb6bmw58LFq3pK1u7+JWRaL56TADrqLCW
         jelyBN9blrulE7Y887MANmuZmrtMhnnNQ21qpuVVSjgD3CgFwWmXueBBGeJaUSRtbTXl
         KK2AmvFX4f2LuRuggT5gIRNTT9ihxoaI1TPlcc7yzv62vZrgc3HCV+UFT28xkefJOXlz
         AdI+JCGIKpWY22KCJLfRydGE8iE7BjSuab6wGUK5mOyndFz1I8t8oE1QRSbGi7pNaTem
         mNzQ==
X-Gm-Message-State: AOJu0YwMUPBpo0ceQejDW9S7gwwDUr3NggfyLqGjEUJrvCdrz4CUb+e1
	IjugQrBdX60GHS5qIzj4K0G8GtVEumNHFJ3mh6muagBoxA4gy7kfsUCGi0s3fMjU7imq2c/auOj
	mPeoHZpHMtCbWyTRkciOqAo+4P5sgDCcQu9oVE52c0pOrzN4OdwnmgD35Dk+rTFUbSGENVGxMOW
	3HUOoxRWsWHC/hTkCvZycjKh5JsKZX/mECPhewRgSpi3UCBPjbawXN1c3O9k5De7LfGjCyHp34+
	DKfPumyO4vaBdtHL6T1yBVDZodQ
X-Gm-Gg: AfdE7ckKwsDYSvEVcaFz9aJXxWp1a/7uXMUh0e8mstmLf0Nh9UhP8nDRCT5/oEELWO/
	EvxSpLgh3iD7tfImR404gIdwztNmYhZOVSw7S1MS+AKewMbDUBzIFlUT3/AXMKDq+aJUia0CapU
	cn+h0IjlsDP4QEbkyBY2dTKBLjyhgROr04PLsDZNNU3GVQuAe9gcXywx6c4neTvBnuK+gCEvVZp
	ZjhjZ0vRBMePrBVT4DNv8fRI8y+tDdPuzlz+Y0xaPtBe8JinesmscRnQDlIOOHclkmKH5APdsGT
	VECxlg2VzXknIfIqArLvuJ3IBsYCOTI54HU731/ftMq8w5/nDwHFeV+ksNs1vSyTZ7J6L+tmIUj
	92My+5pDbxK9rNi1Q2L6gd6dDdSMSonUAoywowWK+zfwuLRK7B8W6sHx0HdkaZx/HhFdqV2j+vn
	9sFyZnrhxWykRuPtghN5sCv9HtQzlK3BP2QqTSzA8=
X-Received: by 2002:a05:6820:180a:b0:6a1:5d32:a2f9 with SMTP id 006d021491bc7-6a5366cdc63mr7056559eaf.27.1784576945355;
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4568e6918c1sm958855fac.10.2026.07.20.12.49.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1662ffbf57so767746866b.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784576942; x=1785181742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iU1p0NoD+yje6AFqPCJghg44m+FupeiwPUYO76Klhto=;
        b=iGN6H64YTvtZD4qYvvN8xlnCLToQ1ENVU5sc4uymw9CmMmYdDs0gQUZk+TSaWn2BaO
         m2Y8RPfAoHawDiysoBYDlYkhWjb6gnAKajaajuFI4U/vN5IsidsDxwdkUW823qBOw7mM
         rIdx/O17WhLyUrAfZt8lekD4b1Q/LOl9MtII0=
X-Received: by 2002:a17:907:c70c:b0:c12:894e:501a with SMTP id a640c23a62f3a-c16b4572167mr651063166b.2.1784576942608;
        Mon, 20 Jul 2026 12:49:02 -0700 (PDT)
X-Received: by 2002:a17:907:c70c:b0:c12:894e:501a with SMTP id a640c23a62f3a-c16b4572167mr651061566b.2.1784576942178;
        Mon, 20 Jul 2026 12:49:02 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705912972sm506543066b.14.2026.07.20.12.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:49:01 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Jason Huang <jason.huang2@infineon.com>,
	Kurt Lee <kurt.lee@cypress.com>
Subject: Re: [PATCH v5] wifi: brcmfmac: add DPP support
Date: Mon, 20 Jul 2026 21:48:56 +0200
Message-ID: <20260720194900.2356442-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260715084718.667522-1-Jason.Huang2@infineon.com>
References: <20260715084718.667522-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 15 Jul 2026, Jason Huang wrote:

> [PATCH v5] wifi: brcmfmac: add DPP support
>
> Add DPP AKM handling and RSN parsing support ...
>
> Changes since v4:
> - Drop the pre-existing P2P device vif fixes; they are now a standalone
>   wireless patch.

The DPP code looks good. The P2P fixes have been removed as requested and
the changelog is present.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

This ack is conditional on the standalone P2P device vif guard patch being
submitted. When you post it, please reply here with the lore.kernel.org
link so I can track it.

Regards,
Arend
