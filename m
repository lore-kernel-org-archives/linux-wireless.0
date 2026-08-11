Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254A25B09C
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 21:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786484385; cv=none; b=bvaiD+5OXH/gpjEl2QlS0BlSuN6/kVjS4FWXSI2ZUYif+aqQ5hkC93Euwv6FDAC7QhNd4Qd1xflytO/aDVPsxU6WrETvL2h7qVNxs5W7jaWylv9YIOpbwdJ2fpkSYhnQjGT+PPRqheLpsZeDX8CUk4yhRCA1EtN5suo56tz/IS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786484385; c=relaxed/simple;
	bh=Lu4czVDBOBoKMCVqeB6++zrpWjBzqrBzCBr7IB+hP2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfrWvDUmGBDjP5uvRDYFcAcdeftUoQ06mbMbjfVzkrRARooFVzve1ciJt9JCFPXA4JFf4UeX8oAGgwpoaBCrkp8YhuYPXwKMtznlYlgQXm3qm1paF3tAqZY+Mp1R6lSVITBShXL2nMBXKoZsi+B2JBdSKsmUR8gfjEyVlK1lEIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=HZNOa6mN; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HZNOa6mN"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so430528a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786484384; x=1787089184; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lu4czVDBOBoKMCVqeB6++zrpWjBzqrBzCBr7IB+hP2c=;
        b=HZNOa6mNJQr9KBzmKV5PPNy9Ar3keCGw+qkL5D1nhGsE/XGR8BO+azvSuvK5f7P+zW
         KezgtXFzty75OFRTiY744ZT885uRGW0K0zu8P7yao1JSTIOpFuPn8FbtLlVBuEGlcneh
         eLeMKsBPq3sWHJaKbRxeKN8wVRik5KYCyGtRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786484384; x=1787089184;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lu4czVDBOBoKMCVqeB6++zrpWjBzqrBzCBr7IB+hP2c=;
        b=iOKMjYR5DLC2ydwyn/cFr1TwAwb9v5CZZNoBYFFZ5dfNvBoplSiyg7lgzQQSy40G/f
         ct9lIPZRljPa67XFyJ4T5PFzrvpyv94LqA5ceIJMhL3Xl0KQohzYT/+GOD9wy1r/1p4c
         UnjzBR3C7dLI7EtoFpXm29KZ29HeubS3GdJRkBvVaEN8Urk6wsD+1Y6iWRQKkKK9lfOe
         wVJZWBZk3pQEpz7bZrwdBU6OrWb6r8wKRLFjulTCFoVN/CqbkUQBp6FvaCWDZZBQU//g
         DJm/Q3Jr+Xcgmc4VQfdnGEk6dDKMflwpT7bWjwI0cEiBfeDhzkQHB13WNLxAtM6VDtt9
         0NyQ==
X-Forwarded-Encrypted: i=1; AHgh+RpL7p4im83a9JSfVDMQAPE5rylG+D3/xPFekCp6BNuxIvTKsT7UsSOhGthTCaVVqyTV1NlqUKgmLSJ3sficrw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+CZxG5OnKWnhQzYuVKE2Djl0jLxFM3ngM9dbDio6Htm0Aqg6f
	CELbUTnc6jPe/dVbnDs3IZZzGhK9DgoIU2kXoxvv8n0zd4cxb7VPTeNgF08EoFz10A==
X-Gm-Gg: AR+sD121OfQlJ8TGvRwgRxb+nIhBczNHxTu5UNGjyAFEqTCt+h5FcwIPUE831uS0+aL
	dsw9HjPZVv01ZL7Xa3vNZzLx8frp1C4aphWcEkIVaO+r7HUhuoWOZXtpTdpfbPM8N+PkWaF6eL3
	1KJ6FZBLAO8zDozKhapVWpSK162/9JOBQx0pT60VhUv5rc3lal9K7HL0kqlm2+IYstfHL5T0+oG
	72Ld0XGe56hLbfycSAEj3/FaQGhMwR7AQOkWQssmtbI1UGp44odBgxhb4fm8vRw0IHGMHBOxxAn
	dQ+XsSuUHSmZ+CgR5/2Pu7p3YNj3wHn30OZenaIusqKUUIMengFPcbPnpFrEiVcEPMDYGylo2vt
	bBRQteggGzlxo8tHxNriTU0he/TXYrRH+teed8Qa3nRjh5v1KLa1nzbQSQjLw+ULbxhCImNmNxf
	UlJdjCi6t69M70eSizB2rFHrM4Q6T+/zRGg/dJnzxT9TzJzdW5qEhN1ajrhVoYMrU/+uAuQZuxc
	Gdg3fZQGihY4DOLlePJQTA8fqY=
X-Received: by 2002:a17:90b:440e:b0:38d:c74d:29c5 with SMTP id 98e67ed59e1d1-393014b609fmr30801a91.19.1786484383845;
        Tue, 11 Aug 2026 14:39:43 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:79fa:d268:80cb:4947])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-31cf628e2aasm3197805eec.14.2026.08.11.14.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 14:39:43 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:39:41 -0700
From: Brian Norris <briannorris@chromium.org>
To: George Valkov <gvalkov@gmail.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Dan Carpenter <error27@gmail.com>, johannes.berg@intel.com,
	kees@kernel.org, bhelgaas@google.com, s.kerkmann@pengutronix.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: replace one-element arrays with
 flexible array members
Message-ID: <anuWnc6MKyT8J-O6@google.com>
References: <202607150932.F2A0836@keescook>
 <20260716001728.57799-1-gvalkov@gmail.com>
 <20260716061638.GB9973@francesco-nb>
 <alh5y74H5bJyDSSP@stanley.mountain>
 <20260716063246.GA17850@francesco-nb>
 <aliAaHF3NgwAZ60v@stanley.mountain>
 <CADOrJmYnAph_TgxGTx-36ugkjjsiH=1T6uzmh4FuQ=EOio2m0Q@mail.gmail.com>
 <CADOrJmaRjN4XEZAyaWR_4g2vTbmmaSeFdzJ7r2ncsZkbvAxQsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADOrJmaRjN4XEZAyaWR_4g2vTbmmaSeFdzJ7r2ncsZkbvAxQsQ@mail.gmail.com>

On Mon, Jul 27, 2026 at 03:16:54PM +0300, George Valkov wrote:
> Any update on the progress? Do I need to do or change anything?

Your patch was merged for the next release on July 21. This process is
(unfortunately, IMO) silent in wireless land, but it is reflected in
Patchwork. You can see its status here:

https://patchwork.kernel.org/project/linux-wireless/patch/20260716001728.57799-1-gvalkov@gmail.com/

You can also see, for example, that v1 was marked "superseded":

https://patchwork.kernel.org/project/linux-wireless/patch/20260712222334.7134-1-gvalkov@gmail.com/

You didn't send v2 in the appropriate format, so it didn't get logged on
Patchwork.

Regards,
Brian
