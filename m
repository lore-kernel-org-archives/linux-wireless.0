Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA52BDC0F
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 20:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786911347; cv=none; b=C8LHpkIDCVL0QVWTFzYpnJe+HQjhSZ0Xgs2wQz02gjDRH4Oe+mFeYJ//1fsGjaXtNeE+qOUxipBfmz+3NXpaDTTEgEVLCFHSDx5OvTnWcMXQ1Qe9lvqFJLaaQMjevLXSW1fccq2QrYL8rHrArQVIDCYyF8QyVJOaELDsjt5n7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786911347; c=relaxed/simple;
	bh=YLNFw0AG3etdwrl7ND3i6NgBpPAWyLQnnXdqNZDEzAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7plD58OPpVULFSaspeFyjQla0L7f1OMXffGzKjYAA6gS/ojQAP6dBuut6k8ajMoUOz3zvPuuKwS5reYsIB9Xocn3lNu+J5ZFyi7jK9qSorGy28xF9fsm663et+ZpCV0tuRnoL4g765GwSgZX5p6L//waz81oYZg2OuGfsA9Umg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXkDo/Td; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXkDo/Td"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so34497565e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 13:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786911344; x=1787516144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTar65Rimo56P+5q1sfLQwgooJmuM6Drj27jozp+ukw=;
        b=QXkDo/TdepBojPSPAxhQPSyDDXuveKd5HMEocxdmaNAovCIrEXImChNobnvVivY/XH
         gZTw82Nr/MNqP/ocjpvw3TAbje4/jUUVN9EaMaaxIvCXuWvLi0EKk8jGStW6fYT6w3Ca
         Io8y4y+CrVcBfAoktXsJ1IKytbtaazY8BVdFg4ypaRw0wqb8kHb+XhKTX6JG7J2REbUB
         tcShrwXV3wcn7PI0K8C1CbsxDeaXQTx5MskXUiVOR9Fq1drD1zmPce9ov/i8SaIWqCUM
         ziswpIl0rrJ93ysTb3caeBCdyDzuVxomJ/EEhb9cMloQ6oHtAXBErCZ0N3JEppoKoPkc
         DNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786911344; x=1787516144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hTar65Rimo56P+5q1sfLQwgooJmuM6Drj27jozp+ukw=;
        b=HvMuFFXWxr4oKg2X06ZaVaFvDTAXC2p3qDjpBzU7YXxoi2CxfoG4aqfVPXdGBzNBbs
         4EAH2Ss8pcocY/keytd0dQzHVg/S2VP28E1Aq782V2eSurjY2YBH0r6ONxQ1l8b90N+Y
         9q8801Z8XyqJM5g+FK+Fs36m9ijZgfDi0idyQcnbPHOwCUhdHXMX6Ge28/XmAf+U29Nc
         psRnbKTn3FUK3LprzzUHxe5emUkjw4rlOyEGRERgmtYXccVZQmtZKQ/5TKzQWfLwlR3k
         dzJLtguRFsROufHyiM6lSpOf3z76GqcEIn7r1yhPi0vVRnNXjUTpd348Gu+yB3zWXIF1
         QCOg==
X-Gm-Message-State: AOJu0YwL1CJFtoosOvXfN95z+zhX3+jlY4qzFc4Y8sSo9mcMkDytwDQM
	VADr5lTKeiOn991ta7qHCM74kwh1S3oU1ZMb37SQGFhSsSNQYFrJDAjN
X-Gm-Gg: AR+sD13ejdjP+m8w9UWSZE/mUbFtuh3rsoaNAdOmAC++oymbkvyT5fXZQnE5EdxbyIp
	OEdQs/YZNyMHMO7Lx46Maa92PsCsMehc/Ww2gOlIX6GVpWXWLHYr0ZhAHR0O89w5nUhQZ2LJrHz
	Bv7SVihhNSfdj3PcSpDzlSMINDadbkIbFiwsAPMrqSOyrOuE/6uUPwJmw3HAWdUvf/cyaPeqrJr
	HYdlSpAP1D0CnuFaMGwtxeX+kj4reXMyNaCsbyddfhfbLJHsRN2TRXSRrfqig2djxQxkwFmH9nK
	ysD/e5SsCquouM+HYjuj6WjJsP75m1Aiz/yxruBl91C73nUY0HF5PVoCPg2NE4u1YWnkAqfeLg6
	I7mgxD6B3baWy/usUw869su+rAJgM1PpiheoLazalSg/Nf1B+kRdBz+RyvXjW+cKsHwRf1MDl1Z
	Uzl+RV+ObZO+3L3Y4QIhOB6pUi2OMYU9R5E4aWNDd7ALpZYVGEX24tVSXek7+iBqcpZQ==
X-Received: by 2002:a05:600c:600a:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-49987981e14mr223870225e9.11.1786911343891;
        Sun, 16 Aug 2026 13:15:43 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996127629sm67000195e9.14.2026.08.16.13.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 13:15:43 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Sun, 16 Aug 2026 22:15:42 +0200
Message-ID: <20260816201542.291030-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <9367d61a-bdc7-4d11-a424-428950d74f60@gmail.com>
References: <20260813131845.1330003-1-mehmet.fide@gmail.com> <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com> <9367d61a-bdc7-4d11-a424-428950d74f60@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Bitterblue,

You don't need real mDNS/SSDP - the driver keys the routing purely on the
destination address of the frame, so any multicast/broadcast the AP
transmits takes the same path. Real Windows/Apple clients get you there on
their own eventually (that is how we first hit it), but here is a
deterministic recipe.

Setup: RTL8822BU in AP mode (hostapd), DTIM 1, at least one station
associated so the BSS is live.

Generate the load from the AP host, egressing the wlan interface (use the
bridge/interface that carries the BSS, and your subnet's broadcast
address):

  # ~100 broadcast frames/s out of the AP
  ping -I wlan0 -b -i 0.01 192.168.42.255

Multicast works the same, e.g. "ping -I wlan0 -i 0.01 224.0.0.251", or a
UDP loop to the SSDP group 239.255.255.250:1900.

The firmware drains the HIGH queue at beacon pace - in my measurements
about a dozen frames/s at DTIM 1 - so ~100/s overruns it at once. The
shared TX page pool then bleeds down; I polled the free-page count
(register 0x240) and watched it fall from ~1800 to low double digits
within a minute. Once it bottoms out, new stations can no longer
associate (their auth/assoc responses queue behind the backlog) and
"error beacon valid" starts logging, because the reserved-page download
needs pages from the same exhausted pool. The AP keeps beaconing, so from
the air it looks like a silent receive stall; only a reboot recovers.

Two knobs confirm it is the queue and nothing else: raise DTIM (e.g. 3)
and the HIGH queue drains even slower, so the pool empties faster; drop
the ping rate below ~12/s and it never fills.

(This is on the v1 thread; the current revision is the v3 I sent as
"route bmc frames via the high queue only for DTIM delivery", which keeps
the after-DTIM path only for genuinely buffered multicast. The
reproduction above applies to both.)

Best regards,
Mehmet
