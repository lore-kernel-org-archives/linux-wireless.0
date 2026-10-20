Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792513329;
	b=j7l4TVeT0OvH8U7r3Z0u28FsJptiXXxSpWgx6bEWQf7k7gwK7eOq1VfqMUu1W5AF2XUc
	 /bLDe7ZqhUf0FX2FZOC1MzzIDwLacYqgzS0xROZBjQAR5LKksHD8gShGvbPbi+j7N5kSn
	 pSUUce2eMeH6h4wzjAhotc5sTthmxqcuaTf6lRnR72bQFtGVfaXIAJMm7i/k3m6Qe4Ue4
	 chDRbOY1CBJaPUMgZfcoBwAEpXb/vkIsvk8Ce1EdefR18/0ejnZU6hbu6ouUQPyOO2Q5a
	 9QNMxWiJEVq4y7elOVjtaIBZ5X5icqxNHmDdpW4jg7iP3d1WN0VBgKSCIgVf94i7fog==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792513329;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=DnTw02OnMjOZAuZ9GRe6dL799zVWgxYPWHjHUsZLswA=;
	b=1m877nVRG08R6+uuuquJMUaKpLLs0rdZAqLnYje7MVddO5L9zrtwihYF3KiaG4BEF0jt
	 YOdq9pjVnvFb4mJff66oE1mjo4WPl75djETlBulLmr18LzhY61FBZNfGflUoT4JMF7lut
	 Qhz6YiKdKfVzY2lX61TBi3Hcvb9on8JPz2c/dk3lLF2cnz0qUE9NcjnodqhprraNRM7En
	 pCxwqPz/R0rKWyoQM6eAH9k8nhfljcf9B8hOEijIVyjz6qQFBbCkivH+9GvEvAPH9tCk/
	 N+3ClZNR8ejMZrXIxKQ78VFDzidaLzN6peBU+hTFbhw+ANZAJ/KGFOfNk3HB6M4Dyqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ZFsn1i8X;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03746606A32A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 16:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03746606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ZFsn1i8X
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8ac4806e210so23502887b3.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 09:22:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792513328; cv=none;
        d=google.com; s=arc-20260327;
        b=XkgUvsF8yNWYwzIwlLTz5qz0Za7CZAlX9ZAl2n2zwh48axYExuCgPhVv8C2mJnCNtc
         UthxKPsfLskdMsHmH8B7L295USvIDj/HDFvjTT3KuWzm4yk4wnXzjrZQ+NtdlmtY4gzw
         90WRqVViMof6PlmEd/SXzfTPGTOSYclDsVIy1copHgGsFQgEqxfqIrgnIFrIPXXv61ng
         ecu3oeAbQi8Gjd+ZWSf5oJ/y2DFE5KA2PbM07MUBM6PHCA/Blu93KdzvTzIOcKKR7i08
         dZJvKPHe8bYJu8pKBlMq43Zylcpt5dqR/8BIHTBN0YhbPM0Qum2DnzbDEEE52iyEg+PB
         ryog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DnTw02OnMjOZAuZ9GRe6dL799zVWgxYPWHjHUsZLswA=;
        fh=NF4kEi9o6vueZbdKAW8HeqgRdW9QkzGFr/G43wv1BFI=;
        b=TW4/OMwq4bGLcvq0IwZVzzrTRAfJRDJYP21UfmeJZkQ/AW3R/8tvOZUapjDvs1mtO9
         P3MQr2pj2bUDTpeLIjfAIz/1UArpiQ9vLCNy/EHz1eM6jZh9/ofAEGiZqkq1XTzg5cbf
         JVvgjRMoOBHhFYGeDC28p583UzqbrwiW8o3BmOgwQlN1CcoJNNcz24VhlqxJ/0Chu4Rh
         1EOxe/ScN208VO9kdEAdquBpmPDYGZ46uW04QdVlIAFqTNeR+ltPR/1tzkDDBF/KcqNX
         Nesesn1VrvAXXZO6eDwkGgEC2jqyk+qiARAog2vucQ5rWeR1fQhsX7ZzIZVdZffXcwgy
         teLQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792513328; x=1793118128; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DnTw02OnMjOZAuZ9GRe6dL799zVWgxYPWHjHUsZLswA=;
        b=ZFsn1i8XYS9aM7cbP84XG4HTWdW9gMacvbSziIeDCgFyuEhbhPcO4vVsgdZiMaspFH
         c7HZ7BMGsRdWgmyqPWLKXjrqLvqRKocgWb21Ism2rkLhzApyfzE8GyjSmt3wDkBDOwr8
         4Es2H9hPLdAutFqJFWkNEue5v7880yR9x9Gyro8+dfj79jg2wgHQIugQgjaQlRy4Fvja
         p9setNF454n4e6QhXq4YLJy/fo3uVuIdqs7Tk1AbF+/o1zPEpXJUUsnrzCZ9YbmMpxRK
         ZOX0D1OJ7E39hsnMDMVXMhIemrDD7WZHSMUGRi0wuZ2oPcFPGRXqqT3I1D0svDxOQelw
         8C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792513328; x=1793118128;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DnTw02OnMjOZAuZ9GRe6dL799zVWgxYPWHjHUsZLswA=;
        b=x+NwPtVpEjxwi/7BN/21m8AXNC/6f4h5IoqzYzf94fRBddChc8I3AD1WTv6n71Aqe9
         1BGTwIgQUt93IvzOj53r6A7dk2bZkvIGf6cAyOOpYomxcJkXzG1gZ1wFGSQ/87mbi75A
         1Si6RVfl7wnadQrdnkVQVUgaYloI55PKUNHhpoREt2F7vGLvw+kP9I70fgus7YS5MAUQ
         mqDSC8VqnxEBvnNpUw7PEqzJZVLGo+RjNs0qt8UZ/udEqI6+R358XKihvYHHQBCIdqjA
         tbV6bPqgIgN6UdC8t38a3uTN8TM717Bz5kNMvMG/vbJ8lR99YiALdxK1CWwpitGpOufX
         zZzQ==
X-Forwarded-Encrypted: i=1; AKwUvBykwaqCJ32P2SRRUXY0DMzU3/YRenboH4r790d0Abp1mldu9MT/Uq6K8EL88ejieLx92A4jM0Iox9Da3laPjA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJxPZbEAReI8Ju86Fs3mWr4P4wcqb0xV4NU4lukzLFKHjl2nnXP
	pc/FnHvno5CZXjzTmrhLnCQtViVYjxxXK4XnzKlNWk6L0/DyQ9MXZyMK2djS4Nq3dfjMbo4LGQk
	naIPRaA26Fe9NCN/DNlk7Ta8yaZwzZ3xKpw0G/u/A
X-Gm-Gg: AYBFou1ZEmk+ExzdTFmkLLRFJcHR/iMmop5CFf9A/XVmV0PZ5S/5xe9K/OdYnmMbDXD
	FpR+DBwzptphbu0VDNO1RNMxJOmzhASh/kWqlJvdQkXzxUQIoefFgKntzGqRzjPdmcuGUrLWyXy
	WqU2lj2hluynxlzJbF9pDlRuH4K3TTvF6yN9CpPq2TAMK+zBA0Wub4mrAW1uD2RHMU1Kkg8m8bS
	8mwdAoB9AYQX3JXUWAo2tEcxpheHl/vZNodO8lhzAAShloUPtmiK7CI/ckRu88z16Ji4heHjp0c
	KPtQ0xZr7SRuAlcXAEixBecX73qT6vRNK5S/Juy+09nsY/yPQ0cxIaPVExQATY1nnn6sivMkKN0
	tc+plcVcsMpwYryZ4CYMPgGz9iRBm/ibzdWDloUH9SpOKma+cYWITW1GrPDRfbz2/Aaeu1wo66p
	7B8JLd/e+Mh1GjE18BFEr2jEISkuviEPM36uVM7fd0yid6x4kZn8t4XZg48yR39if6X/M1FpKdG
	7PbIFLlFxRDnrKsaOE1Q4bO/cr6in9P/GNkZLfIZ+dLg97LNXHG0fPRpA==
X-Received: by 2002:a05:690c:298:b0:8b0:cfe6:29c5 with SMTP id
 00721157ae682-8b0f2189609mr42132047b3.37.1792513323232; Tue, 20 Oct 2026
 09:22:03 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261018131930.1116724-1-julius@bairaktaris.de> <20261020160831.2133912-1-jtornosm@redhat.com>
In-Reply-To: <20261020160831.2133912-1-jtornosm@redhat.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Tue, 20 Oct 2026 16:21:27 +0000
X-Gm-Features: AclHuK-kc3kyc5GKqkjHU7MJ9W5xa_vMhwo9wWG2suT1Jp0haBr3CNyjEmQ0QHc
Message-ID: <CAC1t37JurQdWm7+kvBRuAafTY88DudtmG_Y=oLp1zk6FKxSkBQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	baochen.qiang@oss.qualcomm.com, hujy652@gmail.com, 
	jeff.johnson@oss.qualcomm.com, jjohnson@kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	tamizh.raja@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Sounds good. Looking forward to it.

Julius
