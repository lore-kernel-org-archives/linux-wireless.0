Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753361;
	b=Zna8BtfP8gIZJ55GpUr/FdARZNU95Xx3TFR95rXyLwxO8b3v1Pq+JqDs6D+ghtAaFUHw
	 R+WvBFWfxTBG8Hn/5+ex8iP7TPtwQbjEKQJYUDN1ky5gN//8wF53MGMJyBu3/Va2pcJ1p
	 +mXYV9DvYqPzUS8JvSmmyExdAdkcJjDwzGCGFqAO1gfnM7tKfROkPDVexue+PDwTiRYLi
	 5H0g8c/zH7I1OhpQyy8I+fJRg/FxFm7+ebLWvEVP3Wzv0OmjBBihZmlE4or/gpRd3I0T0
	 2h4X9ErJGLwMG1wHz16sMMXbHiVKwFNdqqsjh+6L7l3UVarimehp7jSRW1HpzJc0SZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eJC7xNgQLQutWHHXkZ4X5MyS9ZRK+CGwoz3uAzjDsLI=;
	b=WvqthClOPhkfW/xXAneBWlSs54wM9DXjByLWGtMkuV8HoEEnli1JpEMKLmTYm1Zh9NMx
	 H6w/yDmrFiAKiEjEzv3QfXjsqQS4d7pNpLkJaBCSaN5zy/JdZBG1n/eNtPkKxF+h3Fd+V
	 s3t7uVC4+ydQtXIdO1jL9qqiFYPf0CFrA3qBR81y84vnEFysXQHL8MQfyfatS4ezwB/UA
	 wP+Wjtb691/TCJlwF1YvKhh9YE5BQBomxM7bTN72xSGufsWg9xWd1IWonocZVrwuJnayo
	 VL6mYR4SmjRC9zPwMLi783pNj/Y5Ok50bWNwxO4GjUUpedvYbQ4LMhdNfhrn7xcHYqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XeaVoIN1;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22983606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22983606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XeaVoIN1
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso428394f8f.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792753359; x=1793358159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eJC7xNgQLQutWHHXkZ4X5MyS9ZRK+CGwoz3uAzjDsLI=;
        b=XeaVoIN1AsdgxiXmgX/39WBewj8KDsevg1v+JNoSl8CfcUaq6UcqC5OiYyOJqWFuEA
         V/TJ/acFlfwmM3CjmgDAjNgD4Efm376U6KgKCC4KQOTL8OO5ivmqKdDjkcRtQ3HrTkC4
         8KAvznjfZv8uo+qPuiQmH1LIIP30qIn9cFiEZ6/XrH87dWvNAnlOHPUSFZzpUgz5sEmc
         O0Z19irlBe6wyz7jU9IjWP4HgerhEG/nVWTVCbe6Ng08sNZ9vEYbNXjguEoNbJbdTQSo
         +i3Am+sqGGt1AO+jszQWF7cHcNA0tZh0medTKbbMXrLkjZ5gtp4bKgxHN7KH4jK6s3ow
         q6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792753359; x=1793358159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eJC7xNgQLQutWHHXkZ4X5MyS9ZRK+CGwoz3uAzjDsLI=;
        b=T6thjKqkY1YqUU7pcp5u/LQKjBmD7XeIQfro2V7C73kfFKUYing2Cw118jJk/YEmVF
         1eUTL3NjdQ/9FvZXLgw3effFqH5kXafW5mzScMWk9uBC9A4XgM6TZkQImh70QLss15fC
         owRoz/bGioUQ0M+LqveWpqcFR6j78DgczJm+mRwk6Cx1AHgwglE/+lZ1T3KvE/5jCh5K
         sGtP8tjie53K8CtnH45qqvXSDSLlByQbEk7UrO4fHmGoL9aNPYcozjk9Z9nrcpRUeIZM
         D0n559enS5SQIU64FP+9jnlkiWgwFhSCUl8wxAUPM7pzzkE8C35cqXw50v5RMPMLMMxV
         5v4Q==
X-Gm-Message-State: AFq9FYKt9vJvLobJYOnPXzSHWqy5bGBQklWv8jihpAK2IJnWgHmInA2+
	KYiH1sZTPU/kmaC0sij1/FPfM4OvyeARHbo9jaU4fqSYTwfX9rl4dXmE
X-Gm-Gg: AYBFou24b5CnRra9FeQGQHFvnOITQ/GFDBSZqyZnl0+6sLwIQDXBxZIDdZrW35sth26
	GgeLxMMWkqqMRt/Iu1Scfy+YUZd3ILOtyU7O/iWRyP0dS1ATyCsTmU3rypOnAw0u+a15aqjYLAH
	oAu6yqCyihyXZKLe7zIveTAy0YxGs88ngrkkT94UyIXu16UZoBODALy5sWz9upaMp0547IMmXi6
	tbOubY5p8THU9oMTQAsa3o9iHH77xwrDb3J/Ll24Oa+pbyXOjz7j5981dfYQ7nI9CHELtmgKrZL
	2Pi8JJRqo+kK0yIlUiJXX5eNHBUw+788c9ssz6zjFH7kwnTMTeQusZfmmbDLWck9VN7yc+GVynZ
	Y1tp2SRBQdsOvGv7Vsh8CH3+AFjvQkvmqZDU7atpE6/zFwbsVdt4fePK73r5NmWxAlv7iY++kvj
	wS+90JHWMoLAOyo+obzCoaYxdmBB9XPncF7MGdYHcnUbXUTgNtVrkM9FE4Cw0QVx2E1w3omSOG6
	3uCwNRedtgmzS14d1W9Y4wTK32B/I5pERvQ+kclRI7WuagYy0rjZCGTJuVqPCkNthjs887zQGLK
	kTeALpBrFfzXq43WPfLSMEFu1/vDlCOUjYyhCyscAXKTKvb5jiue19I2JPSx9timWbklQudhVyK
	8uA==
X-Received: by 2002:a05:6000:40dc:b0:48e:e2a:4093 with SMTP id ffacd0b85a97d-48e3859e1a4mr2854763f8f.19.1792753357897;
        Fri, 23 Oct 2026 04:02:37 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38062dc6sm4189555f8f.55.2026.10.23.04.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 04:02:37 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after restart_hw and interface up
Date: Fri, 23 Oct 2026 14:02:22 +0300
Message-ID: <20261023110222.2804687-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <e9cab7ed7daf45b9b4c2294174f8c1a0@realtek.com>
References: <e9cab7ed7daf45b9b4c2294174f8c1a0@realtek.com>
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

> It would look natural to clear queue_stopped before enabling interrupt,
> since it is intended to reset. More, add a function to be clear that we
> are resetting queue_stopped, like rtw_pci_reset_tx_{ring or queue}_state().

Done in v5 as rtw_pci_reset_tx_queue_state(), called first inside the
irq_lock section. It carries lockdep_assert_held(&rtwpci->irq_lock)
like rtw_pci_deep_ps_enter() does, to record that the caller holds it.

> Add an empty line before 'running = true'.

Done.

> For scanning from idle case, we have an assistant
> 'test_bit(RTW_FLAG_SCANNING, rtwdev->flags)' if you want.

The case is real - rtw_hw_scan_start() takes the stop before it reaches
rtw_core_scan_start(), so the stop is already standing when the start
runs. The flag is not: rtw_core_scan_start() calls rtw_leave_ips() and
only sets RTW_FLAG_SCANNING at the end of the same function, and that is
the one set_bit() for it in the driver. So the test would read false
exactly when the scan's stop is up, and I left it out rather than add a
check that cannot fire there.
