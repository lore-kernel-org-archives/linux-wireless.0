Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792450611;
	b=hFFFMPi/NKuxNuxuMmR82SZ75BOUuev7lCo+9dac5t8PFmwK2uQYIyMUirSpxQiQOsgN
	 F2YcqsOGZGKp9E4IaZrRjBciDqiJvRwgtE5W+OtvLdxKArFzcSzJhci5M2Zh8pjeleZzo
	 4z0qxRRgzNst7wW4P+S24uFvewhW4KnJVCE1IMZGc7aLKY9OJ18BFIK4oDsUr1ZLMrtic
	 cSpEG6Eax9nZ/yAr0LtoErhqpQkAA7w/6T8Ps0N/3LBgn7mNtFB9k4pNtZvT3kAtTBB4A
	 e8hx4gCfyinVZGsIHrVQjreGsODkt1uBPySKe1oriBl7PvWPoDHE5ujQAUDaSmVL/ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792450611;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=REE29c8UBh0TXGI809b1Z+iw+yDqToJ7DYkOaz/LGnU=;
	b=v7Bc3fSsdwwpX+VgqKeKKiS8Dtcqn6Mc1u+WfXHrKeQu1Aa5HPhJ33YVZSEw/ZpD/Tnd
	 IE46AvCuUY0SnkxXtSikLXTOl3nCXp/XLDLds1gq1hWIHcrXzDkFYnAXv/tFJPCUTkWjV
	 9XWtS/PHIIbRpeJE0VHyzQOkHPZMaxHcvkm+8sNLokwsx6Nrd78xDfajj43rbzJZUh7Zi
	 36G4ighb0B6CQf05iXfO8kQqLgXf6njTf0eLK2iWsd6eSu1KjzajA1duooVveqo7UJi27
	 h0eU8WtFttO2MT6mAhazGeMxfJZ1pzYIrptcGQx2apAGZANC719smnb8mfLUFepmVRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nagashi.ma;
	spf=pass smtp.mailfrom=nagashi.ma;
	dkim=pass header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b="T0+gM/qj";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C738606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 22:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C738606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=T0+gM/qj
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so2984670a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 15:56:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792450603; cv=none;
        d=google.com; s=arc-20260327;
        b=XfHzV4taxPRUkxHpArf6PiDx1It8rT6g/Z1HjePLEwoIteISQqfJWqlnrxLKYLLe/F
         xQnHO4IZ07TyPqt6rXPlax/0aTTV0tMCNr1uRlvU4nNv3FO5FBSW0v4CvHGe76ZpWJah
         d5W7vTIjwsJ+zqzjCZOpz9B/162ZKNjBvu9gcp68ozTxYbT0ohzuqdcGbgCrdfJal0jQ
         DcQQ3YiROe2bsyfEMytC3vP927qVzsWCzSulRgT4DZa2owf1CTm0qw4I0EKWbzRohJxQ
         n4Q8Rk4B/RdIvORvVeHHmDtiE9s3Pmg6MpluT53QBDR9NOub+XrDvbLTM0c4ApzI8CJP
         fU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=REE29c8UBh0TXGI809b1Z+iw+yDqToJ7DYkOaz/LGnU=;
        fh=9ZBGk/cwJdM0bu+CN2pWE+g8zqVfP7tY0ScxjJ99oyU=;
        b=j21DB5CCmbk2u5F9OOkz1TaufttRJNp6iJJB18rqkk+HbW1kzb/q0tqaGxJWBJpX06
         H4w3b3aVOqMBD1hvq2fYRLm0FbWha/yTXs77DGgT7F+FLaJ8PWGJIofogGQSTFLNSOhH
         vaK8QDkMXOItdKkYTHqjUuiWNgvDrIGhe2/YSM+VQnTArfnkyIO9vzBBomSEoUNa7wNg
         GUoOKHvnyzCZClo61KwIv3jxFAIQPO5ubThYsuPYuX1XaN1svu2c9wjWM3oo3X1Hkk15
         JhpjGhNJHRPYzJQglE38ApcUJBJkOjzI/NSWciMCKs7+YN2MRpshxQ+7bt8krub4FDoH
         nxgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nagashi.ma; s=ggle-ngsma; t=1792450603; x=1793055403; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=REE29c8UBh0TXGI809b1Z+iw+yDqToJ7DYkOaz/LGnU=;
        b=T0+gM/qjDUiAlf4RfS1uvHJ4FW3iczcqsrxH8413ojHDK4te28GuYt4iUeiZU6L5Z6
         V1avUKmpKcSbEznIyWT1rWGENWkYKaBV2RGtkZ7bQbIIO3PHpqr/bSsZ5FobebOWJpi4
         UFbDv1wSM+okH5q4N02N/CfZUavVxj3yFr/tWFhK8iyVCPUJSmZqE2tG2t5I12a1+Vij
         bkhu0l2iahpi/JY74t23gxv8MJsc3L6HrfsztHDaCEoHazACGR0F17q/zdgPKpegmqJ4
         X6jKUW8zNMaMzN7St9DKjXm7FPjG2gUVFDsTMMU8dyOpWS1ZwENjpxvKT+a+SJQrhd0z
         RzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792450603; x=1793055403;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=REE29c8UBh0TXGI809b1Z+iw+yDqToJ7DYkOaz/LGnU=;
        b=LBvJkpJoQ8kix6GWVOHsKjkQ5f7VW+AvKucoZ7jvsXWm0KxFgIXlzXjhRiG/McqP6H
         g4bIcOQqk7cqWvrBSQdmjuSmXysIQvxNapyiujVlEVpQ2P4iAmVXfVOxhpzgiA2jbNVS
         FAHZXza3ztnCfLYvM/dTDhZ6XN+X8lLEDrWg52JdYobT8pddLmzQ56SwOAqVBs65hky7
         crLorWH/b09hiwWSmw62Ohd92tAaybJ3AuutD6mZo3NZixOgeeBBM1vnZ0Zv0IYencUX
         h8+r5ogFUEy0MDXw0aqgTBsKXMUamsmbsKFv9DIV8NtRDfukaGn1pknpW/Cki5GxDm7X
         a9Jw==
X-Forwarded-Encrypted: i=1; AKwUvBwlM1KziKHTZeLLoRwCMRcxcPjAGqm5UE6D2XuL0hmxApi4ipBeohbHhN2BMwAD+AjAmo/5PvyUjszdpIHTjg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLICBRhXOUctwxOSLz/UbZ2pd/pmBzYHBOzyVjCSW80K5CXj+g8
	b4nYG5l/FQQC/Ych04TlTkTVdk1VB+2/gNPoufyutwG1Hyacani7oDrDLGfgz0lW1B3VyjVBYzB
	HzbzBGkUIBbtT7wO4Wgfog9wLL8R4dty7tA7Jk/Vo9P2u7U8IKe75HpSvNFw=
X-Gm-Gg: AYBFou24D7NrGJ58WoTbBNqJojyNNlCYZXffE1H3Uy2QZlT0eBH7N21tT+l84u3Y1ZB
	spJgowUaq3zeECExsEv/4POQllesldHZ27uiZBaUroE9v4IRgYmjdLtixl/ifuuo7VeZsogNhwt
	MNQ5CO+bn/gC7Ujsd2WZstZ/xzzNi1Q3R4rGgDSDKUIeRW6BnAx2UhPA1PTksLdQd24nPDrBIiz
	08lNvGT4jyN1gimQA8Bij8Wl497uEJeWHr2a/ew75jhzUFLVUZsvk/BarI+TC8UhmMHzhgQ8WtA
	xu/tH6GCrEN6nGkn7Jv6TwZ7jRLlntziq7WaWbS6RgSaJzAAv5CnMHiAk9V0WsAYCKhJOTG840Z
	enFKy2SFeeA==
X-Received: by 2002:a05:6402:4403:b0:6b1:e361:5550 with SMTP id
 4fb4d7f45d1cf-6b3a81657c1mr5897174a12.17.1792450603223; Mon, 19 Oct 2026
 15:56:43 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-3-c847697b3558@nagashi.ma> <61207966-c403-441d-9019-583702833a7f@gmail.com>
In-Reply-To: <61207966-c403-441d-9019-583702833a7f@gmail.com>
From: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Date: Tue, 20 Oct 2026 07:56:16 +0900
X-Gm-Features: AclHuK9QItXkR2B2Q98NX99AOaM5Tsth9CYzCO-Xtn0rwNKADE_0wzaV0-bDX4g
Message-ID: <CACB3TCKJN8ou4qa8BKJZYGgv1RRH0awt-eu07YRDwPkppuLQJg@mail.gmail.com>
Subject: Re: [PATCH ath-next 3/3] wifi: ath10k: bring down a station vdev that
 never came up
To: James Prestwood <prestwoj@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Heidelberg <david@ixit.cz>, Fabricio Akio <fabricioakio@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi James,

Sorry, I am resending this as plain text. My first reply went out as
HTML by mistake, so it did not reach the lists. James, you may get it
twice. Sorry for the noise.

On 10/19/26 6:12 AM, James Prestwood wrote:
> This seems similar to an issue we see on the QCA6174's. I don't see a 20
> second delay, but sometimes after an auth/assoc timeout we get a spam of
> failed connections with NL80211_TIMEOUT_UNSPECIFIED. I've mentioned this
> quite some time ago [1]. Do you think it has any relation to whats being
> fixed here?

Thanks for the pointer. I read both of your mails in that thread. I
can't say for sure, but I don't think it is the same problem. I only
have WCN3990 here, so this comes from comparing logs, not from a test
on QCA6174.

Why I think it is different:

- In our case the failed attempt gets to the Auth stage. mac80211
 hands the Auth frames to the driver ("send auth to ... (try 1/3)" in
 the kernel log), the firmware completes them with status "discard",
 and the attempt ends with "authentication with ... timed out". In
 your trace, the attempts that fail with NL80211_TIMEOUT_UNSPECIFIED
 never get that far: each one is a short scan by cfg80211 that finds
 nothing from the target BSS, and the first rdev_auth in the trace
 comes only after a scan that did find its BSS. That matches what you
 found in March, that the BSS was missing from the kernel's BSS list.

- During our hold, probe requests still go out on the air. Only the
 Auth frames on that vdev are held.

- Our hold always ran for about 20 s, and only on two newer WCN3990
 firmware builds (c10-00459 and c10-00236). An older build,
 WLAN.HL.2.0-01387, did not show it.

- The missing VDEV_DOWN goes back to commit 077efc8c42e8 (v3.19), so
 5.15 has the same path. If your problem started between 5.15 and
 6.2 on the same firmware, this path alone would not explain that.

- You also see it on ath11k, and this patch only changes ath10k.

There is one overlap: your first case starts with an association
timeout, which is one of the failures after which ath10k stops the
station vdev without a down. If you want to rule it out, the patch is
small. With it, a failed attempt gets a VDEV_DOWN after the VDEV_STOP
(ATH10K_DBG_MAC prints "mac vdev N down (never up)"). If the
NL80211_TIMEOUT_UNSPECIFIED runs still happen on QCA6174 with the
patch, it is something else.

On ath11k, only as a pointer: I have not tested anything there and
have no ath11k hardware, so this is from reading the code (ath-next)
only. ath11k looks the same. A station vdev is stopped with
WMI_VDEV_STOP in ath11k_mac_op_unassign_vif_chanctx(), or in
ath11k_mac_stop_vdev_early() at station removal on chips with
vdev_start_delay, and the only VDEV_DOWN for a station vdev is in
ath11k_bss_disassoc(). So a station vdev that never came up would be
stopped without a down there too. I don't know whether ath11k firmware
cares about that.

I worked through this together with Claude (AI). English is hard for
me, so the English was written with AI help. The WCN3990 results come
from my own device tests on my comma four.

Thanks,
Shunsuke
