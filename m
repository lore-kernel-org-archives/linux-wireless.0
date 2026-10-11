Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCD3340416
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747735; cv=none; b=LUKCM/cNOfF/R1XrUFm9pL4TnNCACfKzmEzOYZnC1i0G9TrevMgcoLbbPtE2E170a65g8cv2ebzNZqXDDe/b5hIhR7n27YsOiGQuwUqjKhzFgBzm28cjT486BKHvsqpHLZwJaC2dLnOQVrUZ12iNOUU5VRRYfBVYxd+t7pGdy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747735; c=relaxed/simple;
	bh=4AMJ4/YUrPp8c+UnnNwqZYiFxBTm23GrzrPTxaOoYuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjfApUC8HENvHcieANMjAOtBUoCUYmqG/HeCwwoyRRsf9toJr7w9r275QHFJY6Up090PT6JrqxQHFNOgNMrVhVhtkjSngpa9VBzIQD/63tO4v/NATaXnrwXEGN9HOzq0bauZVEHo6TJ7Or3eSWVweL5vNb+BRZNNrczHVfWve30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XazWImHb; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XazWImHb"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1880e1bf1so11643245e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 12:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791747732; x=1792352532; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z1QFtV7KI5OFWzwbAboD0j9bhs+VlQKq149o9ZSjG8g=;
        b=XazWImHbNz702kBVNRWtoiti7WE0n0wXrlG1mEZBm9Ke+hFrxjg7TxPr8S3lAZ6jt1
         RBt9QDtIVI5xEtRFirEzLGViDX6SIvEiJlZFxQoa2m+Bfr+pX6sXixqRdc3/+DNZgkjo
         WvF+w9ybTCHojz3iB6xKt6+LSuA4xv2mslFfJ8MEZgnvXoOwPC7DMag1JP0ot0OF1eOT
         NEN1A8QnaMYX4UlUqWGiNo2pm3QgPDR4+2uBug4qzqFwt+NNjAyk7I5BT8sEobZbI7Gd
         ZomsW7zkwc7KZFLbA714kg1Fut4AbH3icjiu7sIHJVJhwWBQFVDJe46S1oQe3b12T7+d
         1Pfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791747732; x=1792352532;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z1QFtV7KI5OFWzwbAboD0j9bhs+VlQKq149o9ZSjG8g=;
        b=Gb/biAFkV9oyFfNflfNvVf5N69WSu7UpSF0y0Kdm9aZPC08wOArqtvlJK4B5YFJSr1
         8sNWeT7ODlP9Y6DPjKZgDlhqVGbnoQL/BYqxc1Por6YMIEpE+F7x7OAUQ9tNf3LK+dFS
         ozrXeoTvG1PHHAEOrqf+UlHUsNR9FrnG3D7WDuVu+UtlxVx7T3afi6O3RUOiKeQsfwiV
         3mqK9I87vFaVv9/d4n4OENeZxyJMIHsnv+jFegCtyDQcWZ6gMH4dFRInbhkBO/EVKslj
         ie7Y9pua0/soLwruyGsz4uMT6kdz6V8Wu3yqCWg/iOBo5nY5sLFPtiD1btPcwA3+ezuA
         CIzA==
X-Gm-Message-State: AFq9FYL6j0gFgREHfgEbQj2F6lDgab5musL72+1TcbPEFVcAvyfuNKth
	t+5gnsFRUHsWfIH2Am9O7vn2nrneZxkAxWep9kwwh6ylrmFwM6hPxT/q
X-Gm-Gg: AYBFou15GBkYFx0d2Aihkg562NtMqfRZAFZFtqRHl4CIbyX7xtpeq9vZH0aSCKfkh3I
	JTseYpBbx45MKw4bYz2oVb2PBdOqPEKuSAb8ji992BzDqpF1r9MOHO+Q2+BMrOzxcHEtvOI2QzG
	BATmUsiJxG5t0tut7uWpe2H4uAvSOQNmYw35R34vy0D9Ms9LddMBByehpPFqy4Zckq+nwtObdWQ
	I19+l6K9M5VHc2/E34WUhV7hcmnpdMnUwAfUs2kKXWXQzOWbAi91PXHVOYZ31lAGwLvtIk4//Q9
	WG1wUoMaFpo613z2JgQ5+UyIgBhQQhm4zPTPAxv0hQsJ3y62ZrFG+nOHm++ql1K7m6atJlcPeQF
	9Sc0mnBeZMS4m8jjVkrgRYB7Y+kLagqserpFAFJHkyi/ZyC/W9TKZRjp5KgrydSvBCiFFxosxCB
	hIscVWSCnxrIg/MDtlZjm/+2VI5YZQeha8ec9bwAhoc7yAzX5UGYveAX0UTW2m+4G+pg0KNzimH
	uG0YMGb6wQ65iW6vZmBslBVnN8L53bOvePFRDHL1ptjJineGPddUnq8X97zSmeT3ObLKM6EjVwz
	zEQb0XIwJeDcj+1fUa+2yVz255riP5ongiG1xu4eR68hSspszC1I6U38g6hOEhfRsJiieLvdfo1
	Ua2ng
X-Received: by 2002:a05:600c:34cf:b0:4a0:159b:d2a9 with SMTP id 5b1f17b1804b1-4a18e4d68aamr114369585e9.24.1791747732221;
        Sun, 11 Oct 2026 12:42:12 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a124-4001-d491-d32f-6b9f-21c5.310.pool.telefonica.de. [2a02:3100:a124:4001:d491:d32f:6b9f:21c5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a197c465b4sm89015105e9.3.2026.10.11.12.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 12:42:11 -0700 (PDT)
Date: Sun, 11 Oct 2026 21:42:10 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: avoid sleeping tx locks in netpoll
 contextg
Message-ID: <asvjWF8q1injcEIh@gmail.com>
References: <20260930185417.61865-1-kmehltretter@gmail.com>
 <20261001075755.3MilPS2C@linutronix.de>
 <ar7vLt5kQ2HJoJY9@gmail.com>
 <20261009160015.9YCN8Lt-@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009160015.9YCN8Lt-@linutronix.de>

On Fri, Oct 09, 2026 at 06:00:15PM +0100, Sebastian Andrzej Siewior wrote:
> > 
> > Source inspection also identified 8139too and macb as candidates: their
> > transmit paths take ordinary spinlock_t locks. I have not reproduced the
> > warning with either driver.
> 
> I just replied to the netconsole thread where I did suggest to lift the
> local_irq_save() part. This would obsolete this.

I've replied in the netpoll thread [1]. The netpoll candidate's RT
locking tests look good so far on Pi 400 with unmodified brcmfmac.

> 
> > The earlier netpoll/NBCON discussion concerns NAPI polling and
> > scheduler-lock deadlocks, rather than this driver-lock warning:
> > 
> > https://lore.kernel.org/linux-rt-devel/20260618111554.2n0pP_O9@linutronix.de/
> 
> There was no fan club behind this change and PeterZ hated it so I
> dropped it.
> But this deadlock should not happen with nbcon or do I mix up things?

No, you're not mixing things up.

> I don't mind if you have something to optimise the driver. But as far as
> the netconsole part goes, I would try to kill it at the upper level so
> the driver is not affected.

Agreed. I'll hold the driver revision while we discuss the generic fix.

The generic fix still doesn't address calls to brcmfmac with
interrupts disabled from non-RT netconsole or atomic writes.

I still need to compare the unmodified kernel and the netpoll candidate
on hardware with firmware flow control enabled (brcmfmac.fcmode=1 or 2).

[1] https://lore.kernel.org/r/asveuLDEf6a44bkD@gmail.com/

Karl
