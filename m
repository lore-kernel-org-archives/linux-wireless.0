Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8580046AA62
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787767278; cv=none; b=dO0QQJEM4J52eIJRkusKwHn91w+ftE2DaNHLzgyYxl/SM4wpfR3YaC4t+nZK9rd7gbHJx0X4KJGqzOZDZykh7Wk+VGpzqblHRyllEkjzEnI302Ps7yLVuUwXvEuDi/hcw/U0qDe+dNyuTIIO0KtkL4IKELeuT1jh+UFIgLtOJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787767278; c=relaxed/simple;
	bh=eu2Ke/xEniw/rYEfT+YYjJaIbW9/9II1zSGpYye51Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6azn6bvBtNKADWbTf6KDts6l3wFb6hOo5n0popBTT6kC2I4Zv73hhxR69Vd4ByC+SvGCpIaRAa+6XeUockuzzICWeYijKAodA7R5Ia03T+5c/egIP3Iyf4wLQaDw2XJO/Vea8duKl7ANlHWj8qFyJIHNwps50Ufl7+HO9YUbiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQlJGT4l; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQlJGT4l"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso201436666b.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787767265; x=1788372065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nx5aNmdW7l90Z4iLHlBzK62IW0m03b4a8hEdI21wjoA=;
        b=AQlJGT4lMXPT9r0Pgnc+XQclpwRuuHEZ7FWeacTn+zMej9cWP4o8B0Lc7GkKQh7FRg
         bQM025L6uLDnEiOpFEuAQ/jiR4vRgyGIAVeq9xWXLpy82GlQcimXyL1718OTXVl50+Eu
         8PoZe8i0X6oszqU649RnlTqFl5oxyj1wvgFD7ZUHDWyNnhrWKjFlm7pwLtg7BInlueSH
         XWLdiESRBKMA+57oGL07WU8qhoMi6KSTOwfGAK5MYgcg3THAIDyoAkkXOPkQJFsMLEgE
         EAiXObPYbVjdvgIcSkICW5pSRMsBvluC3vh121wNkbuHKD+Sgp+87xksEDxmRgzGzz7o
         JxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787767265; x=1788372065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nx5aNmdW7l90Z4iLHlBzK62IW0m03b4a8hEdI21wjoA=;
        b=jbWeauzywaKhoySt+zeUfOq74pKfHiipOFq+YwZensJqy6lSEUZ+TlLIY76LI5s7xR
         WUtSOVYhyn7VLXsOF8n5jyh8PFSriPEERvz+LZ1eLBirHN/ZBriD9/bGauxu7LTYnAqB
         dFTHGNs51WJV2Fn/9ruOVbq5UDQLlPv8l5tUDoM18TOwHWlL/2l+dwoy+j8ctBqXWreV
         tY86aoQKakdbViHZv+7YFtNn2nfvsTByut8veTYzIjUkDr9R/9F5KaBxMfIsqirWrH6l
         fObeWgVsNZxziq8hbi2EHbwbsC7EZ/gWYBjFWsMFff26DHR1iAVFImPQFKSWDO2Wf1xJ
         yZJw==
X-Gm-Message-State: AFuF++l1hwzaesPSlzTVJSYZ1kjoajMtY3t5RnsRooUCFpAzxuuM0IPN
	zwkUUFp7n2c1j3aZvErQu4CUDyZ6FjAfB3YQolKUiyDzVle8gOzZDg3aO2lWAD6+
X-Gm-Gg: AR+sD12ATrMfeF7MSN32fPBIfpE/wJ8gf2yGtZXyv1NTXw55EKUvrTzbS3gI2gTeGnK
	Qq++ZUSQcImTIfrYz05XKxboO1+EQHonuAoaYWsheUNj3UAbhDUk5lbkvO+/qoi2dbaNc5rjosb
	G23RRn4Gb8I+/bGm0vbrZ0zwrBWLnsji5HexXrqjk4UKk9OiKEXr9u3KptYe3oHy7XEw2leO7KF
	to+qA6351JY0Wh/s3Qp/zJ6Co+baTsEgmpHt1cNe6tQynebzJSmbTX3tIkuw6sPhxdHi1loAbAw
	/nTNyHgcuitMVZ82OjyANMGzRgcx7lmRhINFhyW1SE0p6CutKq8t7mVLrMuqPHfG6TG2Q8/ne40
	nPPCFHJuvpLG5AcRsa93IEjWpmn6zAN3Cej8KLrukAccoM2IfgCnWo6usFMFnWtGZCvaMM/rGVK
	vToE5YJYG8ugeCn/Q2J2fJVMqW8Zgf2tysh8nK6Vi/esofCO3Tym70sKQbRrzvZPxAtQpEfFrn9
	js0AMRy2ekQsT5IOs0ZePmNKqxtloxCWJYm7KKADtvbhUero3owaVRWc5slxpabuzHeqHfpUqdN
	QQ8D3Vc=
X-Received: by 2002:a17:906:1005:10b0:c25:315f:443a with SMTP id a640c23a62f3a-c25315f46c2mr318862466b.7.1787767264999;
        Wed, 26 Aug 2026 11:01:04 -0700 (PDT)
Received: from omarchy ([85.105.43.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a5d671csm555627066b.3.2026.08.26.11.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 11:01:04 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Subject: Re: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Wed, 26 Aug 2026 21:00:42 +0300
Message-ID: <20260826180042.34109-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
References: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correction and new data.

First, a correction to my report: I have now hit the wedge with station
power save OFF, so power save is not the trigger. My earlier "power_save
off makes it stop" was coincidence on an intermittent bug. Please disregard
the PS/smart_ps angle.

Second, I captured a wedge with Wireshark on wlan0 (802.3 view, i.e. at the
netdev boundary), and the signature is much more specific than "connection
wedges":

  - RX is fully intact, including unicast: DHCP OFFER/ACK addressed to my
    MAC, an ICMP echo request from the router, TLS data from the router,
    and the gateway's ARP requests sent *unicast* to me were all received.
  - My DHCP DISCOVER/REQUEST (342/345 bytes, L2 broadcast) reach the AP and
    are answered within milliseconds - on two different APs (an Android
    hotspot and a MikroTik router).
  - 14-30 ms after those successful DHCP exchanges, my ARP requests for the
    gateway (42 bytes, L2 broadcast; 89 of them, 1/s) get zero replies on
    both networks.
  - The gateway ARPs *me* (unicast, 10 times at ~0.77 s intervals, then
    falls back to broadcast). I receive every request and reply immediately
    (42-byte unicast ARP reply) - yet it keeps asking, so my replies never
    reach it.
  - My TCP SYNs (78 bytes, unicast to the gateway MAC) get no SYN-ACK.

So the failing set is small STA->AP frames (42-byte ARP, both broadcast
and unicast; 78-byte SYN) and the working set is 342-byte broadcast DHCP,
with RX working throughout and no kernel/driver messages. Since DHCP
succeeds tens of milliseconds before ARP fails, this looks like a
per-frame property (frame size, or possibly ethertype) rather than a
temporal stall. Two unrelated APs show the identical pattern, so it is
not AP-specific. The interface stays associated; only a reboot clears it
(a live driver reload froze the machine once, so I avoid that).

Next time it wedges I will run a size probe (static ARP entry for the
gateway, then ping -s 8/56/200/400/1000) to confirm whether it is
size-dependent, plus station-dump tx-failed/retry deltas and a
neigh-flush -> reconnect -> link down/up ladder to see which layer holds
the wedge. If there is anything specific on the 8821c TX side you would
like me to dump (tx desc, debugfs, registers) while it is wedged, tell me
and I will capture it.

Capture available on request.
