Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793551640;
	b=Z6la7jiWK3Jhk6k+i3uQNtMz3uIKaZ95Av8sbqVmhLzogmIpxFa/Zz4ceLREWA1EjHax
	 dXfbesz0K0g6I5pwA7ivxPCx2lpVTBGDQjuiw9WXXKjoeQkcrhhg6PU7RKrBiJvQgTGKL
	 x4Lov/CCMB+MsHTiWXWOin7/MNwXfp7EY+TYzVGA64Ga38XhMR9gIAzMKnDHheWA9ZIfT
	 1dc0GH3VuprKpa1CV1OSlr3/g+h0bt6+jcPiMqg+oD9ZQXzQuM/eT+lhLOkCLRn9Tz3DG
	 ju2EvAHBIdkz+MgCXtJ5L4+vwAXQvCR6SoF2D79QzPY/f5l+O1fs1n+rPR0oIkVvgwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793551640;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+QmBRgJFhtFLO88pUA9+jvHOb9ztG8eZY/mf5WUdXt4=;
	b=mixLtkYTpCu55XZ6+n6W0vSPIj1H/TqnrHxj55fahKb0f5FPfygPvH6BeHeFKsPz8yc9
	 zilt67ZOZ4zJABxfRsnBTo8RIwhjv2H+iCwtWH4uSrQEpW2J67jOUITDd3/7j1yMfehKN
	 AZZMXvZmEyuaDWAIMReHS6f3tKORLwUYqynbV9SOTvRSWDBtkn42rQ9nNumZIf9Whb0VI
	 y9ITP5ZxdiEIgV4f8MqhXmx4vRKCSyYxyq9dPnnKn5hq7TSkS17h6xX9IistWq4mMKs2G
	 Ya6NaQI7XiaQEzUdhTd0MjNbNaAHMa8Orxxw5bkeXbkG8QmZtxi9qRtQ1ZoIb54Cmcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b="n/F12gFP";
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7647606A327
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 16:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7647606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=n/F12gFP
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b45f9ec1ceso2487056a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 08:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793551638; x=1794156438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+QmBRgJFhtFLO88pUA9+jvHOb9ztG8eZY/mf5WUdXt4=;
        b=n/F12gFPVpxFWUK+fqF6mtxqvv8ZkCQuy1esRW7YgZCTYmcKkXX4Gx2WalHux3tzjS
         4XnRIFo6Z+LMohQ2yzQWmLnIEdvnSRYVkP+y+ls/h4l28/Cs27L6MX0X5CnTJs/QyrBv
         N3wq7+kPMvLcdIse37nOggR8G6dYvcprDknykO6zxzCAlNclKhzAhjcnsxFd+gh7E1JB
         4WXNG2Er/es1rZB9/9EYBuzXKxcnDKAwXp1JELXoDQvnZDIj9fcKWUoIAOM8q+6MQlDS
         pvb3loY5rqWQdxgnwbgI2LC6yD992IwG8viBoQ7dy309bjnOzZR+pKOVXmSIDCM936KZ
         nRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793551638; x=1794156438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+QmBRgJFhtFLO88pUA9+jvHOb9ztG8eZY/mf5WUdXt4=;
        b=WHPb0kkLXKs6OzMunXyLzNMyn9k5EkeO+smy8iwsYy/y+A3OfRkF9TuYZ2kBFMSst1
         BqPIEcX1l2DKlZz6s2gRq0+Wuz2G55dgm34cc4UFzlPl2sjeT2TmbAjp6Ly8Jl0mv7Kd
         krktGFaj2k9aESvuBo/br8Gfh1tCsSeu9tlkIWdx363seJANBAGGxppZJlrcixYIyNAW
         kNoG6DawyqkRH8fa8ENbG1x9tRxrD6/b7VYmw9yONVDz+KoOUmW8OJc5sjsNiMxXslSQ
         ycXD3f9UI+d3fW+5SJIRB4iyp2MCzo+sodfXghaHMmrVZ0gcC7Z7cU/14ae2VxwKkCuI
         Opmw==
X-Forwarded-Encrypted: i=1; AKwUvBz39jya3D8IAmzVMKP1FKQzptqq6Krb4VsY0I6eVmhYAyNqHpbe8mH5iw250Gc9B3v00jZ2W1NM1MGxoAtLZw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/qWp7+lP0BRl7/e7XSb4SHJUWQ9LaFDlGhl9Z7rKE8IrGvcphp
	FMgz0xtdKSYOF5N/t9jyzSN+YO1kMaHpfjdYwvAKR1kMtobiKPBz2AfGy0mdE126oA==
X-Gm-Gg: AYBFou3Sof3r8cMBnCpVpNYo30lTMYnrNkvK2rkYkFAhZfKjWN7RjAq9JIXt7FUfe8u
	t9pISZkK8bhyhSiDdAU3kEgGzllX2rmKnmFaAhkqmGJdgyX/4pTuvBewNGSjd4lT9AcngxwgCjS
	yCPSzZY6wKO+eMHNVFJcQsRFygLwp1FU2RI5ON7JkgqnuNNkWlpbxj0QowV4qSrEALrsNH3objc
	IrYZVo04HzMx0t19KrQ5ACfMDHq954eP3z1LmCkFP6K9Trz0AXWoy2fEHMoFP+e8cYVxNhu/T2g
	vGXBESdP2u4B9qi012zTYzpDRoL6L9SkSBpK0N4VAeSIWzzWKB6Ri1yiCyfEBMwJYetY5vazAjI
	DhJx9t5yS5kmgl8MbLtW1DKSyBfou3afkglXLzCaO8eKYlN7sMODoAW5e54h8/Xf0VM0hM26XzT
	GqkBtZSLb2RKZY0Q1AqZkYsjUVz5yU1Gmn+eRK8M8zNAZiHDzSok/oOBXepdalITvYJfXiA7L3T
	taaRdbH39jYSUEy+Cee3Z8xlcuecgEa3ezgjKO5SJxsMJl4C6ANq5Rs9B3vVJucgADbCAZxEM3l
	+tTpMqYW8+jqYwYB9ET/I9f8TeqXTGomGJH4KsViSpJ16UAEBU1UBKhr7aMiPDEOzeMp/+5ksyT
	xdXy9UIwPYbew4ZQ3LtVsIQIC5ZqoI/0MraSljZGOJK4YLHlsU68UKYi74Ss/v4EfgmvpwIy9Zu
	i4gbNiA+F+WD6SEmLhSHClvoButN53D+ibs1hnAyH4i9AhW9nDQ6DC0j6qJzsJbuapqmRPp+l6J
	jmyEMgV5BBGuwFlTW+bEJPiBGiqcwbcZVu2uQdb5jOg4CnuXZgVcUbaKMvmHbCrqSFip/vt7EbS
	Cgy59TN9JztRUPSFXVmw
X-Received: by 2002:aa7:d387:0:b0:6b1:ce74:2913 with SMTP id 4fb4d7f45d1cf-6b4d467561bmr3616851a12.8.1793551637969;
        Sun, 01 Nov 2026 08:47:17 -0800 (PST)
Received: from Desktop (p54aff790.dip0.t-ipconnect.de. [84.175.247.144])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca0f376sm2371248a12.26.2026.11.01.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:47:16 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Florian Maurer <fmaurer@disroot.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/5] wifi: ath11k: firmware crash recovery fixes
Date: Sun,  1 Nov 2026 17:47:16 +0100
Message-ID: <20261101164716.302826-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261101131550.1890062-1-fmaurer@disroot.org>
References: <20261018210153.1925962-1-julius@bairaktaris.de> <20261101131550.1890062-1-fmaurer@disroot.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Florian,

Thanks for the testing and for your three patches.

> That recovery fails after ath11k_hal_srng_clear() but before
> ath11k_ce_init_pipes(). The next recovery then tears down the CE pipes
> on the cleared rings and hits a NULL pointer with BHs disabled (under
> ce_lock):

My v3 covers this case in 3/5 and 4/5. In 3/5,
ath11k_ce_completed_send_next() returns -EIO for a ring without a tail
pointer before it takes srng->lock, since ath11k_hal_srng_clear()
zeroes the lock with the ring, and ath11k_ce_send() tests CRASH_FLUSH
before it reaps. In 4/5, ath11k_core_qmi_firmware_ready() clears
CRASH_FLUSH once the rings are rebuilt and sets it again on its error
path before ath11k_dp_free().

> I can try that if you don't plan to cover it in a v3.

I will run your crash 10-20 ms after "is now up" against v3 on my
AX3600 and post it with your three patches on top as one series, with
your From: and Signed-off-by kept and your Tested-by on my five. Is
that fine with you?

Thanks,
Julius
