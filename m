Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4293335E952
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850577; cv=none; b=j9lob+bSpc6nzxq4F0oS6MiknY9sDsqipGrNrTQ+gfQddOCTyU0htgAl4FOYoGp/cs4yfBdyuu+kHWw08jV04HRNMLIX0N9f3Tz9XovnFsFf7H9A+9MHSV6Ux0JfsModfd0JFd7SNydaN7x7jQFM0j93znNJ/FkDyuiaccTeivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850577; c=relaxed/simple;
	bh=M2U1p76YKupUoiiBvk5LkAZTxxeUuvSM+Po2PF1GMfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8aAH1RYB5IW1e7hhWxgxjR+FGTlSeh8RkbwQ3J+13YEIwwaeOSl+94YHq4U1SlJ/9CSJq4NyLVv6t6hO3SAKmgthNA+TfsgdUcmDH2z4+iFYOrE+Nc9hKDr3FWPWrONqVI5JHX9zS6sqgkpy546+51wp5j+1ZGT2bf/qs1kJKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQE7REJa; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQE7REJa"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e5e801487so352385766b.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 17:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791850574; x=1792455374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M2U1p76YKupUoiiBvk5LkAZTxxeUuvSM+Po2PF1GMfk=;
        b=HQE7REJadbtsfDjuCDXLUaZT9HGyTHJJkbqU1rOrNohjamdesYP9qGGZyK2mnANkib
         P6ydlAMrabyXhY75i1fnAKiADB3Dd6PyUKY/ClDFz2SVMWGuYKdjNb9INkV3p0TUPpK9
         czCq0KeoxZRC9kfpOj9O+vcIZl86yUzBawDtVXb6yKbUHaX8H5YDAyKCr4qVNU6qQNu6
         xDNCKrTJwqVPcnufzN+HEVejxDss53kJF7MLHTG/csQKOkpiQAc+IxCB0MSaG4PMuZ0M
         Q7Bhb/NUJO0RAPdp0nsbhX9twevfglKUAAz+BTo2K5UXE+xGJbX7ty7fELPJR3Ye958N
         7CZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791850574; x=1792455374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M2U1p76YKupUoiiBvk5LkAZTxxeUuvSM+Po2PF1GMfk=;
        b=E/BX5e4Hk3hNrzXxkM5SLqT8il6NxKA91eQMSX69/5COh4mHXxtHeepziij5NEj6EW
         gaoId8reTyqUlxrPIR/dwKNZX1eQSTB87yZklgEleFBffHI0vLbHVzSeamqrz4vAPdOm
         g0vceRSK0Cmw+2Lkzs838mDSSCC7Oa6tTCOYyWbn20JH6vXilLD7g7cTU+V2SWqyD7gI
         vFsb0SpF9twI74QyWblWPG3O7NPWk4cq/XWIPV/lHxGbU2+66LLCNmXJxzjxLopIU7HR
         iaqrdWMPP8jwoiofhH7G86xTm2MFIxJMKlBurJJ5TlwM2rGjTxpUT7N2O0LIudRe9HKP
         lMpA==
X-Gm-Message-State: AFq9FYIrDir2i8TL0mfuyGNM+krgPtexuh+USTNykCUP70Mzfw1y0L+V
	ZQvZF1OPdxEIJx9OKKxHYJEVxnu3yrhbBsk0rCxTTr/2DCzWbNxWVWnJERMaIjM5
X-Gm-Gg: AYBFou0n38YLIcsF9gLJce+lZ+wAoeFn6WJO3qHKcn33rRxnFD4S+wdqyPjp+P/S/Z+
	ZBk+aIIaquh4V8hmAP4FLlJ5vFOQAA7O5Ja/AUENA+qRJuEM/RVnsDNgkwMHwH9+RJRUeqtLXjH
	56/NeHGhI5pnx6sS41ORroQPBe6WsMctToUt3fXFwhQRLhYfV/Xqoadm/20fXyz/58KsFs1qFkH
	8zBj4yTqRmv8FbZbPANkmEDtgQ5zg6kpbWDich4kbK1SQ2IzMpvo2Rfam1bJ1uISQwpOWDCGQTg
	ECmIXqFovGb0komqT859Ku4lH/NIU3m+iyzVBQyirKg5XDDuu7JZYlO1Us4730MEZaUZ4Jd6ZZ/
	bcbZbzon9eTe/+ucTy+hg6g8nlWijjqZAFxIHp6M8liK0r8Wyc4hXGqpbBt6uEwWIJ8B6wikJxg
	eG0ncJW/FVfNSDhTXQwAQe51vjgmWsuGU3fX+dPqc+zsJdGZC5uWgTOWkUrFES12dk+fNmRG579
	R1XjrxPDJIPouHW9kS+2OFcvM+OapENT8MKdw7+x37ZfDek4vKAzJjwth3HPCRROshSH5UnGFh/
	tyBjdlVk6Zf0Fr+gyC5y48ERTxaJjz3mv9zUMuPXHnY11VXXKOBcD54l76/opX9za4NU2auGsKB
	Gbz8kaitShfVti4o=
X-Received: by 2002:a17:907:7b9c:b0:c26:1648:a06b with SMTP id a640c23a62f3a-c31aa0ae725mr1023575266b.38.1791850573809;
        Mon, 12 Oct 2026 17:16:13 -0700 (PDT)
Received: from zwetschge.tail45b538.ts.net ([2a02:810d:a1:6000:a55c:f7b9:d145:2469])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-c3547d63420sm142459266b.13.2026.10.12.17.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 17:16:12 -0700 (PDT)
From: Andreas Wendleder <gonsolo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	b43-dev@lists.infradead.org,
	m@bues.ch,
	alessio.ferri@mythread.it
Subject: Re: [PATCH] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Tue, 13 Oct 2026 02:16:04 +0200
Message-ID: <20261013001604.49954-1-gonsolo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013000124.48605-1-gonsolo@gmail.com>
References: <20261013000124.48605-1-gonsolo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding the people the CI bot listed as not CCed (b43 author and others
working on b43), for information. No changes to the patch.

The bug is in mainline: b43_bcma_remove() reads wldev->dev after
b43_one_core_detach() has freed wldev. b43_ssb_remove() already takes a
copy, so the patch does the same.

Andreas
