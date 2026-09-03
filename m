Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35E74CA775
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448572; cv=none; b=iFGEndjVue+csSkrjJ9whdixQt9pM8v3pBlKZKX+E7KbaAvmCbPcl14qz5P1MzjqjnGTTt+84W0laxnzTRSZIknJJLpUfL/HmfHf6ZLR/xrNyJBjCt6H0fOwb9hWlQaBQ2ye5ljxM+vk+fN0Eb3j31ccceGZGo49DNMoWKURYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448572; c=relaxed/simple;
	bh=PzECq9Nkm6b3bxsxN6/LxBcAb33HZbdJHHOmu1wRy7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCuBseEkHVpa1viGT1wfGzzef3iUAVH7nABnjPS8NBJ6w5OHcWo3KZPsxepTfwCDkDjdwUWJMOuCknoewCdFv8AirL/kz+77N3FOIMKMP9Sg59Qp+Sm3nUW0YIKJ4cuoedWUfLKBFknfJFpztAGS8WNnd4ov5YBdGCrCdz5FNUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REK6RZDA; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REK6RZDA"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso1596864f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788448569; x=1789053369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PzECq9Nkm6b3bxsxN6/LxBcAb33HZbdJHHOmu1wRy7I=;
        b=REK6RZDAVZkz6HYZjjPpi2FiqQpiwH+t5kb8P3hR3/rRD6i5ElX+jV0haZOe4PQsKU
         F+GuTCJsWlkRF+fAUOHDGMefeTLHE+hmdCHN8XgjH4DjLDU+xWA639wLMma345BHK/hM
         EPgNdPoALVMy9yEm2NafJ+Jj2k4/GevHIYwIXWgTLs6U1q6pJxJdjLk2AcC1I4KUHoGy
         lqWlPDMq2NQlQ3TafWGveizPtRJjCw9RY5dbsL8QFOKNLUhSt1535AsetKvvCVn2pI8i
         /mbngmXHnEd92dLPlV3ZC1Hk6fv91+jlfIQfpGsvBNmAFw4w9l/tnHxqmiU2rVsvgYoh
         HtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448569; x=1789053369;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzECq9Nkm6b3bxsxN6/LxBcAb33HZbdJHHOmu1wRy7I=;
        b=W/QqNg1WAgwCRUdoGlklVNK8SeSoSkGSOJW6KrQELkh3SxqxnuKaXNTMzDPJBikFgN
         oEA6EE/Z6zTDOySRHrngaPK/qZwxnHr92wfK4XxBCIL7ZCBAzrWfMBdE0sbvVHJUMnJL
         U2OiITHJ+Bh7uJbkWhLPhLYhClc8yBsDU6A5vQuxEK1Sp0R5//9HuAeBVIYFtnT4NHvc
         9S+TjGVVIicBePXsfuVOnvjG/8ZduPVzDRw88iJwPI4eGlDtcBE1DI7YKspUzdWIUUE9
         GAuu+YLZj/TPhIN45wdDpiNKYjcPT+Bl7pmbhxGMoz6P7CyXRoT3832OHE0bnWx5jeKZ
         38WA==
X-Gm-Message-State: AFuF++mchWo0LeVCgv01cENSg2r5pEEACa1xJvWVZJp/jmfSgTohEe8N
	W0h7O9pzIn4QXmf8TXkOCtZNQa7MclF3HUVDPLgB6q6Lc2CV0Y3C7DruG+etUc9v3Sw=
X-Gm-Gg: AYBFou0RXQ2EVLYdojD5ZpZDIgBjWANd2KwtydYNE1sCST3f4JY2cWkkU5+CMFhm5li
	wtQTqOlOBdCILSRFVOiwoNd4AqWYRzlpIJJ8Ay9PNfngThAR4AY4euyUl8jSeHCKbZ3MkW0mjLJ
	y7tA3XTihxV6JxanJ7YykC3L1PUFDaGw0fJIajI13df2ji+i/vNguwfthGMUgfM22IlpUlVTjqc
	JA2Osw2TV5CTg3Fln1U+aDvBOwszZGNHLUqiuTr3/tlpBRzWHMH7kLjSGFE4Sta/mARwAtaI/Pv
	kyosuSBXUun1dChe5cruU/uytaBOmc1yAIrmzk7uurtGjehc/GTT9imBsHJ2G5+fa+YVYcWt6u8
	ykgLi3lZ/C4G9FEXrBE8g3MbLdUX9+jbaB9Yw/zzLF4UNyBIB8LaWroFHN30/Zhbxi4EKTNqwLG
	/AY99OzqrT4Ukq1cM7f3gAd5uxKrAGk4PhVRZvQhUn9XLWH420WZpCQxMP801UEGOit/Cj
X-Received: by 2002:a05:600c:6383:b0:49c:dc14:d681 with SMTP id 5b1f17b1804b1-49cf5bb8040mr16748105e9.3.1788448568466;
        Thu, 03 Sep 2026 08:16:08 -0700 (PDT)
Received: from metepc ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm77097075e9.15.2026.09.03.08.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:16:08 -0700 (PDT)
From: =?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	kvalo@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls 
Date: Thu,  3 Sep 2026 18:13:10 +0300
Message-ID: <20260903151542.486376-1-omermetekaya0@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903111705.472491-1-omermetekaya0@gmail.com>
References: <20260903111705.472491-1-omermetekaya0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Apologies for the noise — I forgot to mark the previous send as v2.
This is v2 of the patch, extending the fix to cover two additional
hung task reports (tun_chr_close and switchdev_deferred_process_work)
that share the same root cause.

Changes in v2:
- Added Reported-by/Closes for tun_chr_close (b0ae8f1a)
- Added Reported-by/Closes for switchdev_deferred_process_work (d6bbe0f5)
- Added linux-kernel@vger.kernel.org to CC
- Updated "three separate" to "five separate" in commit message

In-Reply-To: <20260903111705.472491-1-omermetekaya0@gmail.com>

