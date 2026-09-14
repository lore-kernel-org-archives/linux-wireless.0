Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E156A13C9C4
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 02:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789352767; cv=none; b=USwj3cfWjyzZGOnOCHap1uVfO/MImhdvJ9hPR+L2Eg5O9NUxQDD/xMcNX8xoMVTMoiWHuu+KwalgsSIO9Lflj5Pbw4BolULLotxehmvuSnE6wEq8QSNJfhMFrO+vNptX+xRw48paZG8PZ6BSc4679hYe5i1ELLiaK5lXiRPC+aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789352767; c=relaxed/simple;
	bh=020bxIcSthkJsnM8YVR4dA+lUbFE4ozDEoobnkmHsT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LM8LiJQnHKV57vBgBZg3YB5ok0/FbKkzrv8VkWg2KPSzy+p1mz0HQngZrJfOTeaOg2dksJHoTWTfCNK1STUkpnR4e4Pwb1RrRuNZG81M3OLE2WUhQ+ubsOGoiSPJALAxrXw/ubc99MTzZVLLuUn/7enhKNtJ0h0rVq8BSHfoPGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQ+ClQRE; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQ+ClQRE"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso7015025e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 19:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789352764; x=1789957564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=020bxIcSthkJsnM8YVR4dA+lUbFE4ozDEoobnkmHsT4=;
        b=KQ+ClQRE7mdMsFp7cCGOS8lJHcoQgpbcUcQSnEbB+wl2bkuQH+YXA86kuK7SE4/WmQ
         pVSPmGG2v2T6IS2AUJAbxXYw9suR9DtaMDQGHL4mdmB90TITrSZDnku1BNb53SkwjSZA
         DQis0e25rnIDhCUda8wQRnDCN6MWV6WTL4BOZwSTpsfLnJge1McGBn94YND/bWf7/cY7
         UMBcZ3FZ/lYu97xQzCl1W5Y0t4gx76x6QgzU19neSeprXLdChkqtdz2TpUkdzd1TmWsJ
         8yG2HV3Ck5iIPCMdyTNS7vJMf2UXP+0N4YoiUNO6Elz+/SljlyLUbrnKqUcpl5jOPIa4
         8XOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789352764; x=1789957564;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=020bxIcSthkJsnM8YVR4dA+lUbFE4ozDEoobnkmHsT4=;
        b=hyylFtvmJ2bGjEqxDJ5luQrYc3Cre/lZmUKwBambbWNiS4dxVRYQsThzk25f6elHFF
         g3YaYfkUeCn4nBjSmVVWqN+MAYXrPZ3BhFjnrtS9R5PVqIcA78GthyleVI+1eL/Fm5EB
         iDkBJUlUSXI3Iy23Egjfq4BxCvDiVZ/5EdNzhoDcVSeEeQSeaWkE1HyTqm4M0d4A0RB7
         bTjGTqd/JthzrI3aGXWR6/RfqBiml6dctlfPYlQuwDcj/Zc+lY6hLlGvx7kyJ1ysyxbP
         /I9K7RQZ/3ukCnxf6/IaPAa5DwmEPEUEdfgaJxTws/KxvurxBPS/uiubmjKdRpV+kx3x
         F2+A==
X-Forwarded-Encrypted: i=1; AKwUvBz5KpdB1tn+/4mlr/9m+VlYUYf/yQhLkAuKRedqMaFvqSyLrZzE11Ctpu2oxhH+szkQKBqzXICVAGAYYx96NQ==@vger.kernel.org
X-Gm-Message-State: AFuF++moq32IG2oaaMNvB4ecu1Lh3AQc1/Dp2JiX1/NBi+Tk46HXAWlo
	zWr9M2qbu4bpTaQMGzFW5RZ5Ta56FoPTq1rFwwNuGjcAZ99hogQ/rhY=
X-Gm-Gg: AYBFou0Bdr82OQ9LwunrQEUNFBW8Xxbp73jThbiqpXJrK4OIEm/51j2q494z9pGcC0Q
	jPyPh+vjo7s9APIUQQD8qaUxs+6fnY8uAjRfurcJHfEApxnw/KdESP2bMz84gW2pffceRk/1ea0
	4oRgMtPQfKxaYwIQeeJsDjI73AhiQbxJ87niUTqMrUFewNUgpveeYIKPmT56G+ce65UgNfykupQ
	YIBl4zccIOzo4thcMEeTfXVvPHNr0tt2zaqHymJ6OqDog24Qu6inudJuN+14E4wDWIBElC78pRa
	uU2uMJ1WaFme+QfX6AR694lXgRXied4+IMuwqDWypt7mU23AdlJXDyoeveZKZ8MGKLtpMxiP2kT
	YzUcZvUp/FdynLbCiXgiLzG7ZUi61SUmuZC1jn/GEdZtvjiOQ2ygqeukjcENa6Om8WLcoIO5PkU
	gsbRi6hMHmNiKtX2Pj8ncLRVf0uv5177o9CgJk4bhL33Apf/XuvXJzuHeCWU6lfPfpa2gOfY7fJ
	Cg2l/NnIVNr4Z6ZNCZ0UwNw4z2QZVDb38luv4JVekCKCNJmmYehP5v5FFyMJqKnQVYsH9pXPYKU
	TuosCbUpxKdxef8=
X-Received: by 2002:a05:600c:1c0f:b0:49c:dcec:bd27 with SMTP id 5b1f17b1804b1-49e7a648ab0mr6027235e9.8.1789352763861;
        Sun, 13 Sep 2026 19:26:03 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60adaee4sm417415975e9.14.2026.09.13.19.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 19:26:02 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] wifi: ath9k: stop a failed register read from opening the RX filter
Date: Mon, 14 Sep 2026 05:25:57 +0300
Message-ID: <20260914022557.1141231-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <5f892b6a-7c02-483f-84c3-43c1161ef251@oss.qualcomm.com>
References: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com> <20260911014653.1566388-2-nerijus.bendziunas@gmail.com> <5f892b6a-7c02-483f-84c3-43c1161ef251@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Fri, 11 Sep 2026 10:06:21 -0700, Jeff Johnson wrote:
> On 9/10/2026 6:46 PM, Nerijus Bendžiūnas wrote:
>> +/*
>> + * Set bits in the RX filter without reading it back: on USB a failed read
>> + * returns all ones, and writing that back would open every filter bit.
>> + */
>> +void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)
>
> there is a standard for kernel function documentation
>
> https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#function-documentation

Thanks, I will change this to kernel-doc.

Per Toke's request on the cover letter, this patch and the other ath9k
fixes will come back as one series once, with the dependencies and the
testing explained, rather than as a v4 on this thread.

Nerijus
