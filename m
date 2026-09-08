Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27C34AD7E8
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863495; cv=none; b=cYd6erjdp82nl5a833paTsdzuTDrLohGh4dqxbCqjTepxH53cSiS1ZulxLxewRU5hxzNRoXO/5EM6d2+/2Qv09A87k7XLiwAyA8yYJ7sEZFF3Sx8Ig5d28BeLoV5xzaJFvvlongqYyusJ8wS8yt8acAn5p57wIIVdHIg05RqC/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863495; c=relaxed/simple;
	bh=A6304mBG6FGQ/fDwUs64kFcv0me8rAoRLEcQnUU7XNI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3AqvwBfJNH99EvFRyoUlQW+LJgvQiOvtr0dJee+2251NKLTxfteTN5cmJR8RojN9h7Aw6YhmF1Gphq56EOO9GvJBvSn7ANaaGh6txaklo7+3uFRmhVWQhxi3Gm5a91IWWWFPGt/9sQQrgP8SHxEWUKc/rjjBGtdowcfNZ8q7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXMnl04J; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXMnl04J"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso4198058a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 03:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788863493; x=1789468293; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qn71u/aHB6JMlwJXjbL0v7QfP4FTsu1/7iGvG4jLTdM=;
        b=SXMnl04Jt7GS4VlhXGFe8jlWIVwqk6OYJAc6J1gIs4m5+/alQ+PV5fTkbhdtVm6EWU
         9ZzXsN5hnZ7SgByvA1E7w2fVwaebQsSTwuCtFAqRS+/E8+LnpvlNs9RGrufL5Jlkv+6C
         y2GELT8u2IPgO5gwVSr9Q4YPvufMnsBZ1QNPvLK8R9E1r33yFcIkXOHT3z+fNZeTk9gb
         aSW5idlOuCsquafCAW/mBktvjoRtRxH1fSojTVMpK4+wgrP9L3R7oo3k5IYTvaRHkCVw
         e7ckUISqv/1ZIzRrScrcJ0ijz1di95V0cDVST/qw150+GwDjtIAAlRUGQDGTheuBnPEX
         h7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788863493; x=1789468293;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qn71u/aHB6JMlwJXjbL0v7QfP4FTsu1/7iGvG4jLTdM=;
        b=WlNg6t2cL2os9dbUyAQcbR/z9EK9T/kYU1VIPYCrdm2cruypMz3WajLNmc3lrdliWK
         DLiSw/5+DCpNKvO9JLFWxbZp8KUZqcoFpCXH1rRaLd0P7v89cupZOIIfcwtMIIMzRopl
         snGqYGybeW4rkYUof6w6ZQv3eSwcQ1Qi5NmgvBmK1HIaCg0pWU9A60Hi7h9LAEKOPjH4
         GsU0V+12og14/NnlKlLiW/Qlasgx2LtscSrk81GafXHsOYzIpxspDBfS8KaVbgPvRnHg
         YNeBYzItIcqiBt1EhF1M1+iB1IG3v1kb1Q7rHy0Oa2yJTLHz7JAKDH9GStOoh1E3RUDe
         bgTg==
X-Forwarded-Encrypted: i=1; AKwUvByIn+uIY7wNi+mZsfAMzkLl7bPMZknKuUi90wcgT1lUGVVme8fotEGX+tJBGN425U0+aS+OOp3HPQiBC1ToyA==@vger.kernel.org
X-Gm-Message-State: AFuF++m1306bcOpNATwdXHsJeYtocqT+cHS5lg51T0Qr5sE63ZNnjSQH
	ZzeievQJtMq1io1s88ICocBtA8amWdH/+T9So+XT/V7By7RMOR5qgK5E
X-Gm-Gg: AYBFou1ON/NiMvl/egoWbaw7jwN0GC8sDq2b48TGfw63u/lnJV9XPq9iDBWtUaN0+v4
	pk+xcc58xy8QGEHrUTRam46ZjFSmJwPBDH/bCsO6tUd1rFf1zSSGjISSJb/K59QhsOK5aVNqTyc
	nkcpCASF67Pye6Wh8YXlmYXb7Nq8/0h/sdKDWp0FGfgpZ734JXp7YDGeZOKsxbrzJxQkucZQKat
	bls6TiUJyKGoivCKPSEdr208Grp56LTgKwlwgNCYxzgeYQMA8L6UnPOkegOvN0/pN01zqmNFgFv
	PNRcMG5BqbKGgeyLvP7Ikfeobe3ZMf73bCtYtIQZTY425RORtEVILihK6QXbs4wtIT5h9PmVmDe
	f/NllMamMoDj1nv506Rr7Q6GRFUat18cYOli0sFg4bxedc9mMfVvFtmpgSbex1oLhDuP5f1S/pH
	iN0Lb0u2oZ07HZBvh2GeoCWI4zsiQjXNY2wR0ssjVTFUBJQA+u0CrXiiXrQFdlhAnseZLoftK+G
	1dK27cLMBCRx+clS5hGbS2DxlYf5ioxKv8UsLOk8MQNB0yS3CM=
X-Received: by 2002:a17:90b:5344:b0:38e:4f41:83df with SMTP id 98e67ed59e1d1-39b261e0f14mr42744964a91.15.1788863493014;
        Tue, 08 Sep 2026 03:31:33 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495a0b2sm55767935ad.28.2026.09.08.03.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:31:32 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 8 Sep 2026 18:31:27 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 3/3] wifi: nxpwifi: zero the channel
 statistics array
Message-ID: <ap/j/0/eVoq3E1nl@nxpwireless-Inspiron-14-Plus-7440>
References: <20260813082315.1390321-1-lilinmao@kylinos.cn>
 <20260813082315.1390321-4-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813082315.1390321-4-lilinmao@kylinos.cn>

On Thu, Aug 13, 2026 at 04:23:15 PM +0800, Linmao Li wrote:
> adapter->chan_stats comes from vmalloc(), which does not clear the
> memory, and nxpwifi_cfg80211_dump_survey() reads it as soon as user
> space asks for survey data.  For the entries no scan has filled in, a
> non-zero cca_scan_dur passes the validity check and stale bytes are
> reported to user space as noise, time and time_busy.
> 
> Use kcalloc() instead.  The array holds two entries per supported
> channel, small enough not to need vmalloc(), and the two callers change
> to kfree() accordingly.
 
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
