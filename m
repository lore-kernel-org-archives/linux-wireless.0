Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793346548;
	b=3n9+W6nss4Mp6ip9K1jgRMZB1vQdHo7PvXlq64ZRZndez4qk6qH5/qT82EZO/eOlQVZH
	 UIItPKeAwEtWcLoIXItSMnu4YiO+hyqOXRYBLLd09hbd6KVe4o4CWaUPTJOKiG+Vk9MwE
	 N4snAKVuFTUCtGqUl37VhvEVu86rNW1Ho/+lb+mT86uDmU2vaA3v2drfdadwl8HFA2sy/
	 cEFqwrBn31PYX8EQ66ZOxsA6XUFcyID1jEf8MTWv5Lyjn9rVqNvT8Zn+MqeMiT533sggo
	 VRiBsNRLxGuJGcOPiT4u8CmSwvBPFGfISEDJ9g3WDI1S+2wGhwWXnmXeiTp2Fy72QVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793346548;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ZuXQ3wdUhQi6zQebKfikV7mJP1W2o5SbdOEyKGwuYwk=;
	b=hZgVj1yS5lbz8ylQvO6m3saZYqI/4dK20Ln9xx1UcztMFJgqG4VTtPVBMu0InncVvFfS
	 Yv3s4QDqmae6jtuyf+LXy84TKRSMFSj45/XvJLYhfI3mM44tvyifyuSzhWMCKPjqbx+O+
	 LKaQgsbFinUIePSdZmWJKupy1mXiXId3bje0Nzb4VugTY5RWex38aVxe6fm6/aoJs/HIj
	 es+vifxO2OyVNJQcRRZGmclsxo2PnOlPZgsOYVrBUwcGaYQv/mJZ+ml5cHUAQPVyFnp6E
	 ignJKF4qgfsH0Im1aAql49NyR8fAbcZ2xWLtbQ0GipcUq5ATvvLr6zk6a/Wwq6ieEAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BqAokjDY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8A606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5F8A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BqAokjDY
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so471771a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 00:49:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793346541; cv=none;
        d=google.com; s=arc-20260327;
        b=sbWGhsw5cchK4sKYi2NfCjtEBouEyfI67pFKXXVJ0izhggO7KfMI7B5vpfW3Yy59QG
         U7/FPPF2oyYl9XZFwxvm/GDdsFHrczlFC/iyKSBz1cjxNdOedUY2M9/WdF5syk6Y21mF
         WXx+A9STYo7/2rQhBCZKIqEmXYt4Q5KpufCvF7Myw/JxU38tJu0WomkrxjU9WHdxPjha
         QTDmYy2VOVQwDbNu+s4dk5DPKy79MbVwfr6Z/1Fhy9Ejbw0vVYi8UMi2CbGn7bJPyE0s
         yktXXVy9R68gQi6Ka2b8zjJGeDWqCVd6vNM/jh8/HtM3/YEHUVT/ENyBPdNVdWXs3jFw
         elsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=ZuXQ3wdUhQi6zQebKfikV7mJP1W2o5SbdOEyKGwuYwk=;
        fh=CH4nd+rWz3U0ddHU8IfQPLeqruXXmWSUt5Sj2Tt1rH4=;
        b=ldLfhAWrsmWrg4Rd/Dhg3PH6rSOakGpmx3lhCCX+mFSARcp1NN4duGQmKKiGcuRg7t
         FTjBFgQbEVy2SOoeqJHxt6jInT3vju5OQ9aatCS152VFfZNdAC1PhTiVQ1rpu6hPzsQG
         FqzCPW8Y1Z98K5J2/wQ4t5qtKHANV3yxCNuNbVJZOQmDn0SGMxVgfBxE1l3nNZ3/JQJu
         wo8JZe/aNeOBmAoXgIpHZI2269Wl2z6JMZB4wp4VCcpNnbwKGTVJQf1050DmbIyyPE7P
         28UOpiFlA9DpRCghwD10QUPfZy0bVI/2ePJnJaavNd47uh7CIURBh0usi67RF42k83qm
         Qbtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793346541; x=1793951341; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZuXQ3wdUhQi6zQebKfikV7mJP1W2o5SbdOEyKGwuYwk=;
        b=BqAokjDYRNjUEDr9IbFhmrH/HAWKAVP8qKXo50ofWbz8JRbVabIkrEkVj9HeQ/q+iI
         MImcPKdxwxznE2AzYTerQJvc+gznlDOGZA8PVSHdeJWewd5L2F36+EelO0UcvTi4rz0U
         rtKDH1eVqtA15kMKOdJxq6W0gthUClIVMPHwzn2NN7Ki6FaxV+E5VcGKH1GwZa/kz3nM
         EiTRraAzlR24JiZoDu8/ThJIeKK/2XbVAGNS+sRJYRy5T+5wJeuHXgrZW2Tjv6lUXcMy
         mqTW1sTKCVP+sDiSi+392snt9hyjjRJe5icEFJ/GR/HvB/CgQbX3ysmzUNbRFHmdyRh2
         QI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793346541; x=1793951341;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZuXQ3wdUhQi6zQebKfikV7mJP1W2o5SbdOEyKGwuYwk=;
        b=mmiGx2VaZMmT+VPWGzCzJDJ9B0KTchuSuTGDHBMdHBzGZwMuw5lmHsa3xkT2M4sxgN
         1bTm+IbudB7tMvsVsL69DJWWvhIwCSB/sQI6wVczf7Y65qn/j34XCk9ERmDFeC0V3jyn
         fSS1iOYsnRd+ZADai9N2W3VhIlTzb4PJlOcVx+dEnabvbuvekPA8ohM3ue1LkKECnKds
         z067mEAqFZR2o/RRndX+9Un2223nFPbG0C+spYTAuneiGK4xN+AYidmyVaA64kVMnrRQ
         tM4zNv2iyIV8KsLhw3ZeO39ASF9xwFHGCyF6xPddnwPeCpjTGf0wqvGKnbhFQpzPtDny
         7sFQ==
X-Gm-Message-State: AFq9FYLsurj/qPA+TfcmEGcv/MZol9jMbGs0qg+NJmbTQeZLIw4FUgwp
	EeEXb+Yz7k6F4enzKo6/sFJ2IeJ7f1xlplEfTuDf4ycHqd4D8dKNENwwM649omfN3fcSASao9q5
	LVEZMOFvnHRtDsG9y7cTxDUXrS2Lm90Hxeg==
X-Gm-Gg: AYBFou1gbBtcaLhyDk7ayHrSz5ydbx7XSm0SLAcrwxLSlpkFhHwoMzaS0yejo176zZv
	lkKLqDlDyIynTXDJ1YEBCDH24o/3gEkHqF3GGXuAvpAZE2JyRLG0DMJfgam3W/n2zIvyBF5gtcL
	WFnzTcp2LqlPYvJlVuOt3twBJ4x1N9R44LQx8J065bpNhnSSbqVFtq0tuTcgZTCOce1kaMGzxoJ
	3tF8i7hkgxK1idZZhCxQuaAZXeDfCAeAVvb7jqMBar8wYANj8eKeIM9t8/UvRLxnoyXvRPlAjcR
	csY/SzP0rcVO8/5xWkS0OGOY7SzJFg4BaPJR3jcN7NWMt8rAGVo2qoSBO3w+CyOJrA64JJQtlGf
	nhyOWhLr1ReWTkx5g6aBDbJsZgLmzq3Hspj5L6KH5sC7drV3QPqInwFgG7g==
X-Received: by 2002:aa7:c744:0:b0:6b4:2b7:69aa with SMTP id
 4fb4d7f45d1cf-6b4d4d803f2mr689195a12.34.1793346540946; Fri, 30 Oct 2026
 00:49:00 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Oct 2026 00:48:59 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Oct 2026 00:48:59 -0700
From: Ivan <ivan.vin.ctf@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 00:48:59 -0700
X-Gm-Features: AclHuK8rq23fWJRKEAnfZ8MdYFxQMV6Wk962LjtUakMsaPK4ygb38H7E2PiuhqI
Message-ID: <CA+hZKYLbHFFPrEUp-e9geuTHFLZ119h8FMLecQMsjz9P542KVw@mail.gmail.com>
Subject: Re: wifi: mac80211: two more check-sdata-in-driver WARN sites
 (drv_bss_info_changed, __rate_control_send_low) - same family as the 2026
 set_bitrate_mask fix
To: linux-wireless@vger.kernel.org
Cc: sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sasha,

Gentle ping on the 5.15.223 reproducer and trace I sent on 27 October
(minimal syzkaller program driving drv_bss_info_changed via
NL80211_CMD_NEW_INTERFACE on an AP_VLAN with 4ADDR). My follow-up may
have been silently rejected by the list (my mail was wrapped with an
HTML part), so resending the essence as plain text:

  - reproduced on 5.15.223 (KASAN), "Not tainted 5.15.223 #1",
    4 instances in ~80 min of focused nl80211 race fuzzing;
  - minimal single-program reproducer (syzkaller-extracted) available;
  - the class covers several entry points (NEW_INTERFACE/AP_VLAN+4ADDR
    with flags: 0x0; the 5.15.216 logs also had SET_MCAST_RATE /
    SET_INTERFACE flavors with flags: 0x4), consistent with the family
    of the recent set_bitrate_mask fix.

Is there anything else you need from me to move this forward -- the C
reproducer, additional crash logs, or more traces? Happy to provide
whatever is most useful.

Thanks,
Ivan Vinichuk

Reported-by: Ivan Vinichuk <ivan.vin.ctf@gmail.com>
