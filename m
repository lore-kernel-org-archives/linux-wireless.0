Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4F4EDCCF
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175872; cv=none; b=dWBSi7tY7rnIT48WN4u4Rx7ehTgGgCihRXw6jZ1hAM/ejzNu9AkPLQgbSdI/CItZ62BTocK9Q176Haf/54/0WFJmPKxE3vRLJJpZbNV9s2kG7MoYo5lWR1tIOFXnWZT8nKaf0zfdaP+ola5XftmgjuPZw4hXpEH6AThurCyYGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175872; c=relaxed/simple;
	bh=FNdaQtDLXPhBhDneZAU5Xq3VTmYyqfMdIvCqNB5oh7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Mt3jCg2EvZtBYMFOHrwWneXALkPT9sRL/Z3skDJ/M2H1165ThoiC2oO2/neet9TPHluRH1wdDtE0fBq/osHFrCL6NiUaFXpgzf4yhJuJ2e6xP0BDLdLlQEx3SG0QpyQamVQWTfHXQiiibgit2AhVtXnJ9i1iPGW6cZXn83F18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iKtqr3E6; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKtqr3E6"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b965f447cso8073265e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790175869; x=1790780669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QHYobJCB0QM9EQB8543tguRP7m9oT9qsRVNrSacw7So=;
        b=iKtqr3E66lcWq5nTzK/gLhvX29zHjM/fG0/kOZJQc5lKqsk3M580WEyfDTq+DUlfvT
         cio1oh1GBEgDxTX4Omm0nOGP0xTmXcO5tX7zDbfnQtejlCMwsdrX3hrGu/tR1d+SDnsF
         I0epbhIoc0nmWnTnTtvkobMf4/YhK3parnLuLLZByyGcCzzdtGhM1pyQ0mLAiavxWZAr
         Bb/kXVeuiT0IwxaDIhSlx+V7M1RgTbcwuEsDYzfo8AL/d4NKYu1lxQ7/ewMtJ/HKDObT
         XnUS+sx71CDvSIS3hdEe+KHDBiYyba91aLcMlmiuBN+Z5qqPM2agznrhx5csEF+uAGzn
         5bMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790175869; x=1790780669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QHYobJCB0QM9EQB8543tguRP7m9oT9qsRVNrSacw7So=;
        b=xlPZoiXoSamAaXeiOEUNNQJAtICZqK0Vj33bfMaDHoV/nFc333rJFB0a1u2Wzds0QG
         3tTCFSRZgaGSJ6T8dCHTxjTRvCdkKZxNq44HeYdop1F/FlX2PQyJ4vm5dwdSOPYUVYr6
         2Ytwn1ux/zg3rOm3HvVXBwYW/5mKOV9HcND/WgxD5ydkBnA4k5NL4znaJajyoMl8ulmb
         lmAFSW1+dXa6p+nThScTlXFJiA+A5V20q+iIwW9O6/JOzbMwA7zFw04S+uI3J3QetR51
         zYawNMKWq8lvv1hCDoa6A5oqpfXLObBD5wb/kz2pQe5Urtd+8vbop3zNwKlGzuDx6wSv
         qwpg==
X-Gm-Message-State: AFuF++mXAha6UP/wuCvFm4cVBdtypigvsBTXc19gWOVlLPG0N9PjYylt
	u8BuM94ZYwsE+qyGAx7YDQhrav2ezgGFB0y06L2KJ/n4vbHKoQ8NSRZ58TP03bzM
X-Gm-Gg: AYBFou3ymAqyym3+LCDRwpqW3x5OL48VLIDr/xGTc+m+JOTUL6UbGSka2q8DXXJSDqD
	jCm04ErhmRc6qfUINR6P4g6vLV9b64at6CIufiZk21z3Bs78/WtF6kLz3h4IGKS9kZEX9Zz9eUv
	YTz2CQx7Qh/08G2wsuLjRnLBf5hLmZ9vVQJTUNTtAwWJvrXpiOJOLji09JNvr6pdTlUudCG+LD2
	zKz17TTVkGI4oYU66gTxQi95hvuhKp2rbaU9PCuT45g06ATGTLXQneRLkaZmTDaEJTf1ofnp5pA
	fPHcrON/K3Wn6cifQ7mjdRKvMfEAvTfRVZrNfMYzYF13pZ5e08G1j2eqdsUOGa86sFe6DPENbXU
	+/HEBQoE5HMOY/m4XTtDZNRbWL7Z0Jbf9tKYkrEOum7DznzRjqfazEW2zWIMsVrkO7Q6dVE9iVu
	sSxsziCDOVfd5QtInnJYOB0o5miXVBmjJIeAQgHpFRMSpiIBI/zs5eCj1PLfcza7lDizGIVWqsF
	BpC0Km8xJRCVppwWYI2pZiK/bWCT45xq74+aoBGJUYZf3MtkknB+eTG+5Sk1gw7Ap/DVUBeezHi
	9pVP1Q9I8tpq5OO2PpD1Jek=
X-Received: by 2002:a05:600d:644e:10b0:49f:e441:d61f with SMTP id 5b1f17b1804b1-49fe441d6c9mr12105775e9.21.1790175868945;
        Wed, 23 Sep 2026 08:04:28 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18093csm94979015e9.3.2026.09.23.08.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:04:28 -0700 (PDT)
From: abkarada <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	kvalo@kernel.org,
	briannorris@chromium.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next] wifi: rtw88: pci: recover from a stalled TX ring
Date: Wed, 23 Sep 2026 18:04:03 +0300
Message-ID: <20260923150403.184831-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6f2a314798c64ccfbfd59ac8a8ee6e01@realtek.com>
References: <6f2a314798c64ccfbfd59ac8a8ee6e01@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorry for the slow reply. I wanted to answer your questions with
measurements rather than with an opinion, and that took a while.

> > +               stopped = ring->queue_stopped;
> > +               ring->last_rp = cur_rp;
>
> Does software pointer cause driver doesn't restart queue?
> Or without changes of this chunk, the stuck can be resolved?

No. last_rp and stall_cnt are detection state only; they never touch the
data path. The only action in the patch is the kick below.

> I mean just doing this kick is enough to resolve the stuck?

No, and you were right to ask twice.

I taught my watchdog to rewrite the TXBD host index during a real stall
and then measure whether the hardware read index moves. Three live
occurrences since:

  2026-09-06 03:17   BE rp 0x00b7 before and after the rewrite
  2026-09-14 17:48   BE rp 0x00c9 before and after (wp 0x6c -> 0x6d)
  2026-09-14 19:09   BE rp 0x009e before and after (wp 0x50 -> 0x51)

In all three the read index never moved and traffic stayed at 100% loss.
The premise of this patch is wrong: the hardware is not waiting to be
told about new descriptors, it has stopped consuming them, and writing
the doorbell again changes nothing.

Please drop this patch. I will not resend it in this form.

I have sent a longer reply in the bug thread with the rest of the data,
including the fact that the stall also happens on 7.0.12, so my earlier
good/bad version claim was wrong as well. It also proposes a different
direction for the driver side, which I would rather agree with you
before writing.

Thanks for the review, and for pushing back on the mechanism.
