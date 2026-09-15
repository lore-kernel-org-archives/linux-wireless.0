Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F13C98B5
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475868; cv=none; b=Ayu51uSjOZdlvrqHMIZoKZ34nZCJbcfiLQrh58G+0Tz3GIa7h7vZPcXD46Z8Rrv0TIwpaPCLox9MMhaPZot3B/+RQigFXcZgI1KhsiLj79MUjR8ba5NhS20/SmlFTC6UJw01vrwsBJ4cYlrsM/5uH5nf5Ikgy+rmujGUnyDtk64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475868; c=relaxed/simple;
	bh=PNlXEHjK2B9b0orFcipGeTUwZ1wdjmlH8mHEOReTbi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlKAFWhrZRCSygd1qwbwatjtCCfm+Uu9KqXK7DTIIISBDyAm7tvNsASYnZYG976iBkquaD5QK8eoNZ9ncYu3512vJ82YeNZBBsBWxcyE4hByj4hZ4PP9YfS1AslzjUwwZLNV+5/YE1xuvL42fLo7l7PzEk3Z618Hb3P43/5NhEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CqN2cj4M; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqN2cj4M"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so3536453e87.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 05:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789475864; x=1790080664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DBTYIyrUzxbaHc/VKLKI+lmFuAUg1QVgT0C/YM0iinQ=;
        b=CqN2cj4Mzf5zHQoX59EX2Q+JHtPqz85isJygk+iqy8DCqvz4+rd9xZ5wbE15UhrRkE
         iwqbf8+Ou09AnQTRszun+Se+Vf4SCqTiDWcPSE6AOdWYa643hnDG4a8wpfBA5DVIvi4p
         MmTeqRVz+xfqc4Y5o9iS0J2Acka4ovFAUGhXxp98jAXuGQmlNh6cl9cZYcOa1I8qUxSf
         NqRWT2IWGckQB+gKrN8tBMH2QwHtVgaCL4SHBU2YD5pKNHwvNcKHrnjzP+oFV5B3OCeF
         YFYEWNi8UxCWYjowrk8SSgMCNIwTZqdbcYpC5UNtXAP370FLIgO/6Kb98pvnksQgzfoX
         QPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789475864; x=1790080664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DBTYIyrUzxbaHc/VKLKI+lmFuAUg1QVgT0C/YM0iinQ=;
        b=MdeszvL/MPeLEbNa6k4xEySbXZXmkTFgLSUGN/G7Ie0h1vBw40pIj6qxfrFOeIR3Gy
         PjGcgBUFZi9AlkF28ybelvHbAo5pzqsc/8IsqzZcWrmasctJFcI3Doz3X9IpqWc/TSo6
         NDVYkmp+dntqqCbjVkq+yoMkxnTCxMjfWSBMg/P5hb0XS9Po5GXyESQ/LVFLbPUxEDBi
         FZ1OsUw9A09K0Gqbt1ftQwMkHj7zXKDSuB10bhOvsIfqaT0HrNCbxVqhvg98s3E7D1mV
         /E8qwG1eVnwomczAKgaYgqaw56RqrZK53lR4N3msKhII2oyTNiGyG+6Fdm52m2QqVvJj
         lV8w==
X-Gm-Message-State: AFuF++lob1EKYA4iX6r6ctl0OaBnf/QMlFk3FQDQl7tdGFFlr7/aMcAs
	XXWB+po/G0RuNW5kG6RVRVX5wFnvSw0ilwFXs89FtEnvb5jBs4zZdSRa
X-Gm-Gg: AYBFou1ijC3CQUe78ieXl6ri6NLv0MNKvwD8s5iziDRmdqRGDJYcTD/OSbVSMBQzx/v
	GJwskHf1xa/mIY+TSNSaw+zfI9KAnnH8ABs2oTcfaU1COU0x+r1S5d7AFwfE9etR363tSDaSKgK
	aS0Oo+nQInDm8OFPLv6LDVnlQJ9i2gWUywVOHV25joPDNMmtHuW8IL+eGt88lXYk3UPtNi6usQV
	haqnhTkdWXD+8sYTI+hkcY7ndTQGkJVX7yWa6+S/Uey/iA5Vo/fjW29/t/qWnRoeU/xxgamTrkW
	p9N6imqKnHMOwghdzEd0miKdW9GzZMoBPyfIHP4dFAV5lkQvpkXetHd5Dt5meE019ImytqeFAaw
	IhCFfMgWjqyhTxBxUCam5t4L6B5ABwssEAWZYi/Z2UZ7wEEfjecwMeQWaZHVSjqLzJZ63pSxd4N
	oj5VDiWoQlqWVx1xF4xpcuN6HzwHUGxY9EJu8HWXy6N4XLRIBaUQwTxt5RpXwGq0LFqcT3l2Z+R
	JMTgMnmx8Q/G9IBCQ==
X-Received: by 2002:a05:6512:3c90:b0:5b8:99b0:6565 with SMTP id 2adb3069b0e04-5b8ae67d2a7mr3505713e87.6.1789475864168;
        Tue, 15 Sep 2026 05:37:44 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.39])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a5a33a1cd1sm34986181fa.42.2026.09.15.05.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 05:37:43 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: Re: rtw89: BT connect state differs between scoreboard and bt_info on RTL8851B
Date: Tue, 15 Sep 2026 15:36:58 +0300
Message-ID: <20260915123718.7239-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915122625.6341-1-skokovmaksimevg@gmail.com>
References: <20260915122625.6341-1-skokovmaksimevg@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same on WL_FW 0.29.41.5, the newest in linux-firmware, with the sink
connected and playing:

  [status]     : enable:Y, btg:N, connect:N, mailbox_avl:Y
  [profile]    : profile: , A2DP_active:Y, PAN_active:N
  [bt_info]    : raw_data[49 00 d0 00 04 00] (type:auto/cnt:82/same:3)
  [scoreboard] : BT0->WL:0x40000003(total:0, bt_update:26)

BTC_BSCB_BT_CONNECT is not set here either.

Two further notes.

BTC_BSCB_A2DP_ACT was set before I reloaded the driver (BT0->WL was
0x40000013) and is not set after, with the sink connected and streaming
throughout. bt_update does not advance, so BT firmware appears to send a
scoreboard update only on change, and the state the driver lost on
rmmod/insmod is never restored.

The cycle reports are unavailable on this firmware, which is why I have no
slot statistics to go with this: fcxcysta[0/5], fcxslots[0/1],
fcxstep[0/3], fcxnullsta[0/2].
