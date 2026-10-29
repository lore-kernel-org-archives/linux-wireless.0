Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267062;
	b=IcEQhcluVSYosDejICuABYlXSJLlEMFCt9NMi0SqX/DNEQE2uwcDHmpbK+ycL3FEnIWy
	 7AIphZuLu7neomez9avjX8TKPuo8MuP5iNqjLw8npJLsQ+rKYpqsscml9mAT+qYAwYdFR
	 xZguJt7lZgn9fSmtCB9OvaQ01ybqdfpuGani6kjubtpsXM55wBkLrlPEhx8GmPYljn/5Z
	 63NE8WQc75T1kJ036IwmbjDCqjNqS3gk/LMaM+ehz+LG8wvpvQNVJ4M+aRzG+TkxaeWp0
	 qc+5vXkVE3uPlVLQYMBBRbcnDMGCCoxmcP/0Q8Edwky9kIYGJo5Beg1dkeclFmvFihg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UKSebZaSFVefMa83WA9Risb9bDftelK4ymQGDTUiUGc=;
	b=MgkE6ujOF5iTcVq6ggmy4eZJmCKy6uEZRiik/jwb8Yz47KRJTkQ6KJpjnVvUgXzj0L53
	 gr9hLCFMhGSFJiITOwa8ikcA14tmuhZzKGM4prMF2RWSJlZFPc9dE03ar6NZq0NXh2ii8
	 R9Gor8uy7woFYmROYO4ooWE9mSDOLOiH29UildYVdiydPXGO6kHDx3OUbEvauFBgNeytw
	 EQFEnGAP3wwSUEK9Txmhs9Uv6Yi38Z2yp10dD7SROvWufIe8cg5JzHzXxNL44a0Jgwd0Y
	 PZwNKn/277A7Yx20X5oKhCs2WZHjRTZCT6QfSpMtLvaum0G121hhoqyHaLPTso1G7Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RhUWxnDw;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5244606A330
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5244606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RhUWxnDw
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso934220a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793267061; x=1793871861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UKSebZaSFVefMa83WA9Risb9bDftelK4ymQGDTUiUGc=;
        b=RhUWxnDwJvX15K7ipRR4XPyycz56J4nWxBJ9wQ+7eveSbrpw04HV1uu0M/TFmlJFmu
         lz0Yh8IQWBwf4EE41qfAD3bAIpcDW4vWPzANZwgbOIgn8rhNRIh+vxKHE1OH2Sii3drj
         1D9ouxhDZbqIFhW1+IUYbrnXkM7Xz9jbkkHOZ2LoBy9ZfSDgFETK+iOTjip9E+kholLQ
         oxQmFNP2JgK2m3UOLr0n1jREU+DEtFBd8idnQhSc3UeYOaw2KEk9HtN5Yc9roucMviUc
         lErwfgPN1F3zlPe834PQmwHx3H5ARm6HXu48UzJQYYsr+Y71lX8bzBgpV6ewGH8GTH/Q
         13Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793267061; x=1793871861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UKSebZaSFVefMa83WA9Risb9bDftelK4ymQGDTUiUGc=;
        b=WNww3yEAekwhohLjm5AWjT1xr4lQqBSceKwcz5dovOJfSw9SAXZS/T2R4MKH/KvcrX
         d/HSHzunv+0ikV0euQA2rO5efZ/78+m7y1+CyI9ppUg4zjr1lOm3yc9IZm4maoYEQRsv
         oZcIR8VdRsQqgeZkxrmGhgsyjn35Ucg2jovVH0gtXzMw7qDTdAvR9ii7gEHF4gadSYpB
         w9HMaanZVX1fHv2GXvGAaBBtqTXh71dKkyP89zjSTdrX8/IZ+HA1eqsXJLZ9wbRSU3qJ
         CbkzS5EhM3sj2lYNvgtroGokEk3Za3ko83imJORVggGPv4g7fgSBPHssXUkVvtYet0s5
         KvWA==
X-Forwarded-Encrypted: i=1; AKwUvBw7ddcd4OJyBj3V0gE7TwEwXy723o8NEHI/m6nFandv+epDYgGE2WTA8EClvxZb34/hWSYX3i2exNK5ClDn5A==@vger.kernel.org
X-Gm-Message-State: AFq9FYJmjCZaj7R1vDg6QXi8v+2CI6xAR8VXoaP5MgIrg6BwW30uvu1K
	1435yssbe0wTz+x5rRHxr5V2Id7c23JuJCsGckZaadNhjkFUo0okwOcB
X-Gm-Gg: AYBFou0b/qZ/H2u61iKAERLcQ8pKv6Qyb4MayzI188VkGPXJlANKnczlYfO4RCDuw1o
	kTyZeMl4g5BWRq328pz4FBBEP737Ve5cYnayL3iDMSaROz0Q6gVtZjx8QScIMCNh9M7G3tfG+iq
	SRdJRZ8OeICghOis4vzqxChzE/LscqkpvH8OOPJygnDfa1t9RlTRswpVWfhl3yq4r0UuySUj6kP
	hdo0oC6eZ78KR6QycoiKwS8gZKW7fybJWFw6VxqQ2JPCSNXy0N5Jgd8mrodtYIT/5yqin/7I5Jf
	EYeGK634icjRbMRL9J6lCjztM01tvR3O3CK0pYbpiU4AjEkJRqNFRqJ/cfHpb/acEgKivFVSpPs
	bSmWFWwb3LZ2dMQyVXmTbZIjtqS84T+bOezTdCIQ+afnpJQvYlRWzOjOlkjm0zfw9MA68x7857/
	Y5ExJu8Xl6tv3sJfRex8OAQ1wJ7N8ule494JzycckZXBQQ4qowZA23ZSMxGHKPKjmJKV+AbJRVv
	pVoE8x1FM+2nmuK9Iuqyr8LhxBQ/rtXr+/7P0RUgw6QDQW9CTXjoWgWNTfBnKe37P9RGWORK5uW
	qvCh2djLQCI0qrBzAlepXI2UB4VFxU23JGbPylxHygROYf+8P3jybRptsm0PnmfY
X-Received: by 2002:a17:90b:4b89:b0:3ac:17c:6e85 with SMTP id 98e67ed59e1d1-3ae581e1959mr3851734a91.47.1793267060784;
        Thu, 29 Oct 2026 02:44:20 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae579c59a6sm2912203a91.3.2026.10.29.02.44.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 02:44:20 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: iwlegacy: unregister the LED if 3945 hardware registration fails
Date: Thu, 29 Oct 2026 17:43:37 +0800
Message-ID: <20261029094336.19250-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029081955.GA10212@wp.pl>
References: <20261028142328.18560-1-enderaoelyther@gmail.com> <20261029081955.GA10212@wp.pl>
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

Hi Stanislaw,

On Thu, Oct 29, 2026 at 09:19:55AM +0100, Stanislaw Gruszka wrote:
> On Wed, Oct 28, 2026 at 10:23:28PM +0800, Zhao Li wrote:
> > il3945_setup_mac() registers the LED before the mac80211 hardware, but
> > its registration error path does not call il_leds_exit(). The analogous
> > 4965 failure releases the driver and reaches its existing remove cleanup.
>
> Could you explain exacly how this is fixed in 4965?
> I do not see this in the code.

There is no il_leds_exit() in the 4965 error path itself. The caller
handles it: il4965_mac_setup_register() runs from the firmware callback,
and a failure there unbinds the driver.

  il4965_ucode_callback()
    il4965_mac_setup_register()   /* il_leds_init(), register_hw fails */
    goto out_unbind
      complete(&il->_4965.firmware_loading_complete)
      device_release_driver(&il->pci_dev->dev)
        il4965_pci_remove()
          il_leds_exit(il)
          ...
          ieee80211_free_hw(il->hw)

il4965_pci_probe() returns success after submitting the asynchronous
firmware request. If the callback reaches device_release_driver()
before probe finishes, the device lock serializes unbind with probe.
The callback completes firmware_loading_complete before unbinding,
and il4965_pci_remove() unregisters the LED regardless of
mac80211_registered.

3945 calls il3945_setup_mac() directly from il3945_pci_probe(), and the
probe error labels never call il_leds_exit(). ieee80211_free_hw() then
frees the il_priv that embeds il->led while the LED is still on
leds_list, so the next led_trigger_register() takes the trigger_lock of
a freed LED.

That should have been in the changelog. I'll send a v2 that spells out
the 4965 path; the code change stays the same.

Thanks,
Zhao
