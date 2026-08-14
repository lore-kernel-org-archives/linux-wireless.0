Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C99C2441B8
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715217; cv=none; b=N2hIUdVGCeeNCir2x8+okzPr0EAgnGyMfCImMet+1E62nvwXpPM8gmfp8shklSOQkAQ4DgTiLprbhd1EhJIXsNNuZoSOYWPOc8PaokTay9sKPoZCqLdh9dUY//BmaddV8CdZh7GcoR3gveR649b92FPg4KmE3ASdO+5JiaOBndE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715217; c=relaxed/simple;
	bh=20fbU9cscw9pYdO99cBjLYHWgdI7uYb5rHOtbX6DcCg=;
	h=Message-ID:Date:From:To:Subject; b=I65b70E7M2ui24QAkchC8BV/hV3Tttmu/IF68rSULFrPs3srPv4iI4y+oBH1+FRziBdfRATvrXfMuEd5s2aBUMRLAcB8XFFow+NSIrjW+48lS+sC84UYYE1Jr7O3SbHrksdA3ol3zZ3Sw0VD3NRJ066z7sxVrXly/uLjU9Q6S7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FzpIBggw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzpIBggw"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso11094885ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 06:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786715214; x=1787320014; darn=vger.kernel.org;
        h=subject:to:from:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NqgNmlqrijeAU72tJfWNhzCVIYAdWelzVlfyBTEuNi4=;
        b=FzpIBggw53qeu60o0sBh8WcuHd87w+f8ukK4TG52tHoIdpvmSGKEc5jqsTwTzEQbIx
         0f7bz7We1yZpyY6UvgIZmOhlpovQb/ScFQdnIkVVTkDj6TM5fuU5Tk6aaMfcfzF+xDXw
         4bUHd0NBY2Zxp0hAcBAez5H4WWRcgNT7+JU/Qa8IPbxTZOD9G8n5rfILo1reHL98kslP
         VVlIkp2iwwKznXAEcRZeKRal2C7dCRa5+jh4JEBOcqOKD5g/njf4lwn5hpTO9/ersqwR
         vRdFNwUKTBSBxFH6v69YiBvbCRgHUk+CicUlaBq1J8UaEOkXxGlcH/jtTubGmI4sAQON
         VFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786715214; x=1787320014;
        h=subject:to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=NqgNmlqrijeAU72tJfWNhzCVIYAdWelzVlfyBTEuNi4=;
        b=Bk2aM/C/MNmxCvbijUQuywH+RVk8ZS6pA/QZPj1PsgiwtsVWKO0sH7NbUq0UxlBEE7
         Phsg8Uw0uKEDmjPpUhuwm9rMEbeBJRiy14aZkDKK5H5DeXUDZuUKANEH15fLu1Yba3Mf
         IcrujLPQb5HXeIz/8/VZb0uRTSEemzWKvd3ejxVIM3a916gFRFS5yjes/hsrw4uwiHvv
         H/L761bzSe056iX6cuEn0dVueR23ZmMd/7J++6PtVGF2gHC2+kWcms8cT83GROMIMCFU
         S1nhJvhI1H5qv/TO0ltfBdU6GNxl2+3E44QNZFyKjCwfROHiUy4OU+OFfUvkJlf9ZNUv
         B9kg==
X-Gm-Message-State: AOJu0Ywb500EmTPiPLNZji0mxaqsFsLGoI1Lh41ffrbDEf2PIm0JSMiY
	FjpMHM+5ZIxsZjllfW6S857zLxbyq+baiM7tSm1fFyfdMztk/aZiyXdR+an3oAcpyyG6ZP3UFmm
	Blw==
X-Gm-Gg: AR+sD10z0Ns3ArrSTIN1YAskFCLRpj/q3I8MuYWkTw77WmVLJ8vhDtC1OCuUs96fOY6
	mTlBbFHLVMOlPypKu0LsJX70j5iKf1tPV5rGKav5+vMsMFQ7cbTg6v/aW1LoSzBg2KTMun0tcPJ
	MMSF8SWPYW0g25mS+wiELEXj/Ji4ORdQdUxHVvA2VZSxxdJWg8bBajgUOQkaWkwjMwaSaYFK0Su
	i1RyCJ/cCy1w7gSA2if69MdvEWG1I1cmkCu/pXhsaHNbd0NWPEJVuRFTFzBbvs+rv/qZx1CatrX
	knWQqK05PCl64pfgPiHdWZLw4vxyNnaOsbTn5N1HgAGfSCew+OoXhrMH5MTEMYHNm173OxnXa8U
	FkB7UgZnuC0o6g9x2d7YT6FNWg8HsOZrwPy03UKsbkCpnABkcZSmoKp4CC2U4YR8HVqFQXpFuxE
	Q0ZVtzHR4ee08O54aLN55fabhprhuo8UXfUf7CWv+lxzM+foM5J6uzrvGeBiYz2/lk99tlf/rtI
	tBkrS2xjtXEr4zWnSvVvgxeHYHBlYsGrBsaZ6NLzG92CTiG9mOK+VXBb3hhBsQR9hk=
X-Received: by 2002:a17:902:d545:b0:2c9:c083:cd50 with SMTP id d9443c01a7336-2d3b0da5ddcmr72979625ad.17.1786715213767;
        Fri, 14 Aug 2026 06:46:53 -0700 (PDT)
Received: from localhost (ec2-13-235-62-231.ap-south-1.compute.amazonaws.com. [13.235.62.231])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-3218d3f398dsm4227105eec.22.2026.08.14.06.46.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:46:53 -0700 (PDT)
Message-ID: <6a7f1c4d.642c3f8d.364216.004a@mx.google.com>
Date: Fri, 14 Aug 2026 06:46:53 -0700 (PDT)
From: fadamu954@gmail.com
X-Google-Original-From: PayPal
To: linux-wireless@vger.kernel.org
Subject: Renewal Completed | $387.50 | Ref: I-9RMBSQP06GPJ29
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

Dear linux-wireless,

We hope you're doing well.

Attached to this message, you’ll find the documents you recently requested. If anything is unclear or you need help understanding the content, please don’t hesitate to reach out to us at (831) 356 6612.

In addition, we’re happy to share some good news:

You’ve reached your 1-year membership anniversary with us — thank you for being a valued part of our community. We’re also celebrating 20 years as a company, and as a gesture of appreciation, we’ve applied a special renewal offer to your account.

Renewal Details:
- Service: Protection PRO Security
- Account: linux-wireless (ID: UID582935)
- Term: 1 Year
- Renewal Rate: 387.50 USD

Your membership has been automatically renewed to ensure uninterrupted service and protection.

If you have any questions about the documents or the renewal, we're here to help. You can contact us at (831) 356 6612 during regular business hours.

Thank you again for choosing PayPal. We appreciate your trust and support.

Warm regards,  
The PayPal Team  
5454 Paulson Pl. Boise Id 83704 USA
