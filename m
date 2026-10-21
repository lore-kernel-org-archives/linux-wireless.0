Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792595039;
	b=erklWPzEbDaCzUNhICAH/wavvMq4S0cMZ2BfzJasg0w2UZhwu/x/ol7++8WO0gIncBxD
	 Y6t+5jUJ/kJxpOz10l1RBOwHc/6z0Ukgyfp6oGsZoSabf5NwCbFN1zZE1yv7Lo/Ya3sFq
	 cQdro0lgR3aj9hh7DWjnHFPt2Jb+k3oR5PYPDyHuAFQX2BbmcUjMNeNHXnWgcBNBIsgp+
	 LL3RX2dOGrIwrxGOGWXP/6sV7MatrmjB3xvgYHk3WhAyep+8Chl+JfDGvX+/11kCFHKU5
	 /YZ8jeNQwc9G+wR+vchelNY88g1QlEzV0Z6ZCb4duJIJNnAHTbe75eryLozgxGijbnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792595039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rd4JFQ0YCE+t/QQS88S0VXAF6TZs6Kazifp1MOzHMIo=;
	b=mrjxLE5WBTlwL8jAMVCr+59m/RllyhK0QhaTQqEOYfqntPuaYil4SRwzU7MZFTjqoH65
	 M19lHdJmZFsl01uZ4YZgTWW26YToklmKvpovzGmohF7S+Jhae6tTQrW/XC+L9rj3eWczm
	 jCDQgR5gW2VH2yBgdyPq8fuLpcscaVNgSE8aNPcvunmiJtbWNkcrNeDxq1mrjYtaVTodM
	 O6APwzPS9sD6h6Gh2gT/ffxsW+VUzb/f7J4KaNktooF4lhWMlF5/MGTzEGy0BRtcqTaTa
	 hUQBy1ZFGZn3WoY1LDSStrOy+RcTfT6ntRQ4TW9pV6/WF9pv8e7G2Z40I9sTnMSvyGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="ceW7qv/w";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4E606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 15:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F4E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ceW7qv/w
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1cef0439aso8213495e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 08:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792595038; x=1793199838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rd4JFQ0YCE+t/QQS88S0VXAF6TZs6Kazifp1MOzHMIo=;
        b=ceW7qv/wm5lINFPZwKS23RgUSJatTRZLfwSymrJNX+o/skOudp52if3hzIJ2PKow3H
         xWwsSzW4gnzGCg4HeBdu1dAFmSvrOOEYK6kzX7A9Y34oj0OctquFhMXzAZmPs37tDI8t
         Y2TfcVqIY0WwtKjG4cLStywFP5GSfbX6dj8kk7KQtBCqqrd2Q0JnS/l5962/mhBG5dhh
         Apo08daRYHZZDZwkJFuO1N7IUN/txXv/9YcfuS56MUOl4XVK7/GsbmrlpfmPpklIVJ9C
         FbObeNd6nleEQyKmBaSCk/MYDa1o7n7O9l7PExE1f1T5+i4tTwJtBU3uUgr5bUSq3fiU
         nAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792595038; x=1793199838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rd4JFQ0YCE+t/QQS88S0VXAF6TZs6Kazifp1MOzHMIo=;
        b=VM25yaR9/zDCr+N8vvhxEZe6osQGKzSHtWH00du2IJF7CUhmn/qjgyyKbWHMEbaA4B
         J4P1O4sqY6SMiSW7oEOHH/9FaSSCumLzYUG0E/jAvH7QkMx1yWtgcFsj622rKsKA+6ss
         RXvylxfHPxhm3/Xy9N5Kx+aLYk3RSlPG+3W36avW4chAVSCA0jiffDSF0C6m0L9Kd6db
         8zyegpV5bDui7OE9PDDx09+6VkFCdr3nSFmo6kBHiySqyK292pTlAVBS3obU8r6XCYvz
         k4W3+DPqcXpYJrNdKCJ8jOf9rKCR0ssf1SOsqmc9ETtHmmyhXAuP2QHowk1itCReRZTT
         oaOw==
X-Gm-Message-State: AFq9FYKXmAjX6XCC+U2mdSqTazgs2NeqmDVVM9pyz4l2eztZmZJmRArK
	eIhhEIPEhevPQlQDTEZOsB27l+ZkvCuJc6Rlq6rNiZwa7umpAhT0JqlSFO9Ixw==
X-Gm-Gg: AYBFou1AKgQIn15HBOBCZZYZvtUL7VRDYnONKmJqE4uLeqfkELio5gZHM26nNjw2Lhf
	DNypGPNxVRLLUkw7OA6ZdCz4PfnnAUK46H4px1nGQHfmI4dW9NxpEoLVlaYMm3tbei8esXPMQ12
	+gHhv+u8YYhSFP/CCDegPwnzHpAn4i/kophTKQT/a7SCH76jDVtqj2gZ49kjF5YEx1V/7xiI4Qa
	Jxs1wP3jUJS7HSk3scwSxoTZGlkzZjUviCapTptS6sYI/Hxk5jcHat2DzroqPDlBM4x57bZGEhm
	5G3sMpIemIkJ+LxWZ2gLJNi2TFB6aKUZeTP7n+G2m1S0qo2Dxxn4v8ekcefkvKRa5DdTpT/ywMV
	aBMEtay0KbSDOOYtLvWW4LyljcvHC/RCKHtDPW3FdMrMBw4PaxCgf2h6N3IXDPQ+ckXqq2XzF7J
	mW5Shdl5UjKHkweuzhxgiOeKZlP+qzPcm/hpv/7ROfWQIJmokYE1Et31VfMgLOLnf44KZEwp81S
	dvjQSETweCBzp7QMrm9SvkuTjkSsyJfMMMVhfZsmBBymvrB8q1igWaKsd0bAtoYLt5gbgNWZA9q
	Svjq/9g+7zaUImbcbjg65mCtxcjrd49c+cFxS/vKiJD4mLm3KzclihAuDdrNfZawcyqpYz3d3AP
	qNQ==
X-Received: by 2002:a05:600c:354c:b0:4a2:133:45e1 with SMTP id 5b1f17b1804b1-4a201334606mr32287635e9.24.1792595037572;
        Wed, 21 Oct 2026 08:03:57 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d569d4sm165086435e9.10.2026.10.21.08.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:03:55 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after restart_hw and interface up
Date: Wed, 21 Oct 2026 18:03:27 +0300
Message-ID: <20261021150327.2519860-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <d62975cc45c5b17a85f1e5cb7f9c1e326f27ffa5@linux.dev>
References: <d62975cc45c5b17a85f1e5cb7f9c1e326f27ffa5@linux.dev>
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

> The gated wake still releases that stop when a ring was left stopped.

Right, and the message should not have rested the gate on that case.

The gate is there for the common case: a start that stopped nothing
does not touch mac80211's stop reason at all, and that is every start
except one that follows a ring-full stop. After such a stop the
completion loop that would clear it cannot run - it needs a descriptor
and rtw_pci_dma_release() has already freed them - so on that path the
wake is what gets TX back.

Your case is the overlap of the two, and as you say nothing transmits
in idle. I will word it that way, and keep the v2 note that the wake
cannot be narrowed to the queue the ring-full path stopped.
