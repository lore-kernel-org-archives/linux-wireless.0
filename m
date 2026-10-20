Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457420;
	b=uiMRVIE3uMDc8WGhO9fd6n/8VR3ME2EV6a35Z0baCa5XuRlsDFIys7/BjnG/8ecDQVFE
	 rhrFhMJDZn/LFhHWUiNFD/BtaqCCATI6Twt+Qg6SCXN8C//WNmRN4ToqCs8Kz8+rKUR2G
	 88K09sn3f8rGhVZNBjTzdqbiCNWnDetARjaXU6CIQ6SYty14l4EMq5/Q34g2Nm17FB3fJ
	 dUsBSCoSSF+Zow8P9HEiLalOW68PLt5GzVy9fQXqo1d5UyW12lLYVGL0NBKA32fMIuseY
	 3AEKR4RCCaFcQps4FFZaxtHXtqLq/ngmirVawlJCDSNavfnpX8V/W1YJC+iEdZsj27A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Qhg1mk+TKSbXJlLmrTbnehLYHTBBzICBJ2ydFEY5x14=;
	b=KPj/0M4vakiTVna04iJXyCAaLwW9CUoJABjagfqnvCUkwBEI8yM5IchJM8ZWkyzVMb+R
	 ZpfH+OSwplUGEQD2BcHH/CDE/xPAjY47N0cM2YO+2VR7P7oOUbDEzvagDNEn4aJkut3t3
	 q/Tab7NGWy2zkIKGK4FJg2jGcKQFgs0x7Ut1pCBbVBHb5p5MpIDOIW1pBpo69e3W6Q4V6
	 P8XcDn0HgRNJgUmPE6p1yz+ganhnMW0Bf9C0daKncc2Tv2vYlv2eQkaK8WiZRfRmvJRB9
	 25N0oqRSd0X4ihSsmslvYChuW8A9YmrtJIEwqyK56cNfp+dHMS642n8z34OFgqbSQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sLheooKG;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D860606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D860606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sLheooKG
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a07025cce4so794718b3a.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792457418; x=1793062218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qhg1mk+TKSbXJlLmrTbnehLYHTBBzICBJ2ydFEY5x14=;
        b=sLheooKG60Uxk70ynZ1E3+9Ax4Y1JGIovLgMJXyVqR8cg13gCmSIz4jcGIzWkijl3P
         j6Qg6vvukNuNIWgO36m/2t5e82752tISCTa5j75jCrjpgFHLSlf7TlMnXF+OmuOy6srH
         picoa4yddE0PR/w6TABY4Vao9ec7vKORMNHJSu5V0NhhUf9FTGEFvxGC0FIsvEHCV3m2
         /vpn/+ZeDhkDrxM4ueO9MB8dM0WZUefqqzmLCts8vLX98l1+bglop/erlOBEoLrhPSEd
         hv2pMV1nZzcUFmKRSQDClj7bCKwhPHKyWMRnZBeCegGDybK6D/x0zPI59i5nO8DUgeNU
         nXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792457418; x=1793062218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qhg1mk+TKSbXJlLmrTbnehLYHTBBzICBJ2ydFEY5x14=;
        b=Imw1t4vG2znledQi08psIilZfVK3HlUrmVWAW8qJ8sitSwKfShY3ipdq14OJRd1Ajg
         ieVvBcN0HIkKGIAXsUdrLDrNg5LPCcXbvonADkjDzKLNGOGve0WX5f/URDlQoDTdHikW
         I12opo3lV5yaf4UL+CqmPzS9yPiDZzTsPK/CJKc7O2F0j9WntEbWc8/StMvalcni66oX
         B06FIkB0No4b0DkLtrIeTERJgfWPeWTk/9YzdDAEkrwPVFcQIXl6nYycj/99Pp3ItG1G
         x7H1YLUwtcMEPHQ6P3yP9GaQljdvrr30XwSh7N5P6MWqqpT684d1nJFBQEPFBY7lQLDU
         uhLw==
X-Gm-Message-State: AFq9FYKZwVaX3cbKIrY2oBR0kaHvsnBiKEzwZ+MnADPKMrjm3moxdm7T
	f0ATXbU1CBIeP9kXG5EGgDRhSWVboIfX6yFmA/PU9T6J4yUQq+RX/m5ET0lyV6hi/pE=
X-Gm-Gg: AYBFou0cgnhGrpPfZwil8RInYo5A1X9d2rPlJox1qqsgIwbKuY4BqIgKz2T2LbRouse
	nyYA1A9dfjAJACJtDcW+H8bLh7rcwdpU2OJ0usRtyL/aB2/tAERhqY3yztOFXs96Do3QBucJK0s
	IF6/G4mCUocB/3zFc9KbNxOdX5Fi5OTD28S6PYWSDhwEagMeZzfEKx5fCSDEIOUr6MClzs5GrIv
	EQMfj1IGoVv9mpzNNjnbcSxzHFBYS3AzNZ3STKpcsV9Fh73ER8AbOrMhaRuAa4NTQfwB2DbtktQ
	TlJeD0UcurzLVIBDwx3MnS5t/fWdyQOn4Dm8mgO4gnrKI40n63xcifkDXi/1HNmn0TePRPnVCbM
	o5Jthj0xgJyekr3pl/QxniYKv+yC7Rcf/CIAJ8hhRaxnyqnfkiGTzVo+WACVpx3fHKlPBzb7iOF
	jNa3/S4e0fqOOGLFQ1ftDKuEYfHjDa0tEmBnysOy6HjGJGHMqiPinKUxM/W6g+K9oAPNLkNcEJ4
	3FRqg==
X-Received: by 2002:a05:6a21:8286:b0:3e2:6f90:b54c with SMTP id adf61e73a8af0-3e26f90b707mr879180637.47.1792457418390;
        Mon, 19 Oct 2026 17:50:18 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65ab63cadsm4224287a12.4.2026.10.19.17.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 17:50:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 0/3] wifi: nxpwifi: fix the 11AX_CFG response handler
Date: Tue, 20 Oct 2026 09:50:02 +0900
Message-ID: <20261020005003.1105086-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019092653.3609605-1-jeff.chen_1@oss.nxp.com>
References: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr> <20261019092653.3609605-1-jeff.chen_1@oss.nxp.com>
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

Hi Jeff,

Thank you for taking the time to review the whole series, and I'm sorry
for sending v1, v2 and v3 in such quick succession. I understand that
made it hard to tell which version to look at, and I'll be more careful
with the cadence from here on.

I've folded all of your comments into a single v4. The commit messages
are cut down to the issue and the fix, and the bounds patch now selects
the destination buffer by band before validating and copying that one.
I'll send it as the single revision to review, and I won't post further
versions on top of it.

Thanks again for your patience.

Regards,
Yehyeong
