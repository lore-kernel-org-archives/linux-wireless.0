Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05A23E0758
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275334; cv=none; b=n7a3CxSd0TwT/BuzV+2gTFWrU4rJuQ65jaSC0/X75c+qs1gm3EZVE3hZ9U2M3p1B85BvyQvsQziO3AFPghRu5fXkLhk7Tes0yVxdiSezPc56rnebuhQUn/9xxlpta1ettBybojEkuCou1dORjRfEqMl3cPxEq/E5Js1Zd7X4bIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275334; c=relaxed/simple;
	bh=7Mu0EhtB43qJQzBdB1aFm1c6mclUcg/caZb089tchUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRPFyvsh6TxB8JJD9GvFgq3xHmGkunp9nkRP+wEpCgzPHxePSk5V62YxoIyWt/W0rqOAn0YUN4TUsd3lc9gBuFquF958FTIyr4IG6iGDet3ROPYTrI3UeTSel0pn9pPxrppEdaBcXdh1gujL9CWQ4JXWogsXDUWnsFVWEgDXABI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awP5H0OC; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awP5H0OC"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so41546955e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784275330; x=1784880130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f5BpFTf9mdjyMKNXMvmwTPv2PyUehO/uFHWs1x9kFi4=;
        b=awP5H0OCHc7QdjNbPucZNsAsvV3D+0v5Eh7DEyHzTiNyMDD8oXayEq9MEhHQAsqlaC
         4F3FPyU5S/R0AFFs5yB3ltD1lbiOenVAvy1yvdVgwHw++iIQyNG5vEGZrS01BT669Av6
         Wjnp4spy2GoWTAQ0Sr3d23uT8AKJhJfIp5ksgcjjrvjJ7rV0F3xjd8EJjzIPDgA9vnZq
         326uRyZn4WGiMLvVd+ArRrRL12kcXUZaA6dseFa0pX87522rUtcbU06GwDzOsaaUldJD
         BsLgo33LxYaQUNrijecGOvWD7ukkUWRjLDFxUs4GgaqpLYv9l+Xo6f2vdCcwzNe68DCi
         G2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784275330; x=1784880130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f5BpFTf9mdjyMKNXMvmwTPv2PyUehO/uFHWs1x9kFi4=;
        b=a1Wy5smEEkkWBWEJZSYqjNf6I/fPCWEqHlytz/TFNxEsFwWb0u9fSy32coMtrOG+5w
         vQI54vfyXXiw2mjsPHK0dQ/fp2g/cwe0vvfXMz4/wSGrMdR5ThYR+s+FkMqbkAqu0Pay
         buzPMeixLAxd+XmUs6noFZ5kd9ov24OPQ4Ychf+DRMIsMD3+UvQVjD3FK+nU9K7BPYGQ
         6pkLrI96CBu5jh03wPRaS22ALwfDyQsde5+zOeHnRp/If/n7BQ5fMXqWJ0YbFUM2FD5d
         3IojgXq14F8444iS8ADVrbgbIFZw4NrO3dIVzUeqd1/eS/YPGg6ip1W+DPpWFGxbbLSc
         YYuA==
X-Forwarded-Encrypted: i=1; AHgh+RrX6C1HfkfVMpvFPm1BRFrHrUQV6ANr9brRGyyBTUJX0rAdIMJMdC3m6p8vsozyJeHKn6/jM2ffqh/Al6xkmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDB54GMj67v9bATXYe77TYT7iycesr2M75p4Gl9nNfzzu6CVCr
	MRapB9ORg0k8GiYEO2zV3ZDYuaJ2G16Rhhv7PqP3ZbbqtD6Y/eWPEoSK
X-Gm-Gg: AfdE7clYqAc/kfEgeGzJ3OXXyx0UAdoYKqf6IfkzwLatcqNp1t1dC3ha+FSRjtKSD6+
	V/QpVo9D/o50Hm6VfDW+jOlMemYRwp8AcCFDQzU2HvaJpk+Ezj0m8WGGDzdlg4aqe84JogJiGxB
	fzZidPDovDUePF4yhlo+sesi3w2ZpbBRmx+NXdv7lEjO+qpSZnBi3H6CUWRrwxCPP+0gcxqToY0
	Um6whyOnZUNhuQshHZNvybTiWJhY1ECGoqRa9gKllGt2sMwAmA5S9XyENQfAItVspRsOhyYpR/9
	ORLEyxhtxQB9HtPYslGsbVH6VzNOX9QW38wYEe1ZUd5T7YLu8GJF1E2T6DbB+1fM+QQSwYvUxpF
	UWXjA/vEUPX1kwSWD1jClr27PMIPMCntfYSbCbI4JGfqee47UKdlnxy4BgWxGn6F0D/rbpRIXNW
	3reKikV+wG
X-Received: by 2002:a05:600c:1d15:b0:495:43df:39c0 with SMTP id 5b1f17b1804b1-4954a513abfmr15712185e9.27.1784275330284;
        Fri, 17 Jul 2026 01:02:10 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2f210csm30817965e9.15.2026.07.17.01.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:02:09 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: =?UTF-8?q?Georg=20M=C3=BCller?= <georgmueller@gmx.net>
Cc: Jes.Sorensen@gmail.com,
	rtl8821cerfe2@gmail.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/4] wifi: rtl8xxxu: implement AP mode for 8188EU
Date: Fri, 17 Jul 2026 10:02:08 +0200
Message-ID: <20260717080208.3270786-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260313131849.3148013-1-georgmueller@gmx.net>
References: <20260313131849.3148013-1-georgmueller@gmx.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Georg,

Is there any progress on this series since v3? We are very interested in
seeing AP mode land for the 8188EU and can offer testing and debugging
help.

Our situation: we ship embedded ARM devices (i.MX/Vybrid based) that use
the Edimax EW-7811Un V2 (USB 7392:b811, RTL8188EU) as a WiFi AP dongle
with hostapd. On our older kernel we run the out-of-tree vendor rtl8188eu
driver, where multi-client AP mode works reliably with its per-MACID rate
adaptation. On recent kernels we had to drop this dongle because rtl8xxxu
has no AP support for this chip, so your series is exactly what we are
missing.

What we can offer:
- Testing on the exact hardware (EW-7811Un V2), both single and
  multi-client scenarios, with iOS/Windows/Linux clients.
- A/B comparison against the working vendor driver on the same board
  (register-level or behavioral differences, e.g. beacon/rsvd page setup,
  RA behavior), which may help pinpoint why clients fail to associate in
  your setup.
- Over-the-air sniffer captures and hostapd/driver debug logs from both
  drivers.

If you share your current WIP branch (or v4 draft) and describe how the
connection failure manifests on your side (no auth response? assoc
timeout? works open but fails WPA2?), we can try to reproduce it here and
compare against the vendor driver behavior.

Happy to provide Tested-by tags once it works.

Best regards,
Mehmet Fide
Screening Eagle Technologies
