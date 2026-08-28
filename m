Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26D43B6352
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894761; cv=pass; b=RDnXcR+s17w2tYFJvG9YcJjHThljPpS2DklLHeACoSGVWycCbKUesqR5JzQQwLpW6PDUAdCX196eppqGTlDI+ecckIc84lOMl/Jels2V+3j2BZGOfniEMLLEPiDRAVigrc2UPct42MtoTo8qe1ngQptZHU10tI3Fe8nWXihu7zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894761; c=relaxed/simple;
	bh=s0Xpsu8PNZ/NabbESJnLKPzbczhpjr1WEwgTvsXoiUM=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=P787Ql9wHcaZxQ31gv+YLSHGX7EH8BXTZvybAherblqkP36wP8ilUjQgQPma54A/Ug97pe+CZz9RwrvYdqAt1bw7+RhXJ/9lBlPuVKABy2cNLFdHqgKV6c44m8qrLdVrY979MZm22QR/MGt9vUJ+rkAZnUgkxjjzL8/RlADRw14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=RcAldx1Z; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="RcAldx1Z"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-382ef647e20so550276a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787894759; cv=none;
        d=google.com; s=arc-20260327;
        b=Jmaxfsvqxbi3UzPnZK/BiwHLd7FAHibGOLvkf9wtY5xi+UmtSXdfBANk8mLopQzIBP
         K13aVzuI7vSimHEzvb7dvxYKlvxZUwc/ni5pJ5w8xi2VLODzKHapC9eL3cv8j1HUuArO
         D5p8eM5qdUJk1DuTXs/soSeAYV9ivL6NHsFcHqIDxkAWEvi/IjJEat6mEOq/39qQzvw+
         9UwOyQZTLcqGbfrOHIPVAIrWjVBh5xuya8zZsN0wvvuIK5PRBB58/Wc3AjIDLtEgAS3k
         9xm1jStSZpmUIx1R4/JjqOmS17nNY8+9QgYz/C6lq+OdgUPMRQ7UXE8D2C2slNvPERbe
         ZhMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=lg/I1KrLMSgT8druSaCQ9xBXT+6cIU91C37g0VAcQCE=;
        fh=9Rkp8cf+5K/erjubcxyouYC3N3YnpReBsVFHxL6qI5U=;
        b=PYutT0VOlXQ7C6gSzlIRVITuNY/V81lptY72tbZU1xsEVr6gaOrAiz9Zgdhrsc0jq+
         CmOxpyNGmvJAgU6kirMYrczW+KzjwXifZ5gOS2EAI5TuH+DQeSkSijjl69U3yxU+9K3C
         RGYhM3Yq1GVTkP4bIPM/GOLwUKsnFPTEwkAZqq6h1hx8sjUM7VtofG+ume/KiYTYQL6d
         oMSJDT+QkCTrSyvdq+E6RvYCAN7Il5JiHVrKWTxQDOTRWq0EFErIBvrwVDajLCf+8Ip7
         AI/PR1Be0LfIlHdXtMZcEss0vsoPweK65X8KhWcIsxjr1EKQ+/ikq9w/x47JUbyu3/z/
         Jm3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787894759; x=1788499559; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lg/I1KrLMSgT8druSaCQ9xBXT+6cIU91C37g0VAcQCE=;
        b=RcAldx1Z3EGEYAnvZiB0P++SmE0vrL1NTlpIIBTjesv7EY2jxvP/qLS+lCPVt77Luq
         rUd1iwE7qJp3eHt1efgDnlu0m22nIiZ91jlM54OD1xzdwvUFRHU3a8JSXNLiTdP1exYC
         oumZsqCrE6QnBplNd8JuO0NKw8vH2quOAa3Nqcd0CVuCcfghzChNMmfzX4WGfuHy4HTS
         2hMajNa6CWxbxCIyMntAa2BxAnCQTADkWp0QrbR8doUDjxWSozUiQukHkH4EEj3NJUGt
         87zVNvLQXg4tqjUwxfFXtMeFYgNgs33ubV0Zz/ecVIad2Zg2YYSh0CQTLNsbP+EG0Mxx
         F5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894759; x=1788499559;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lg/I1KrLMSgT8druSaCQ9xBXT+6cIU91C37g0VAcQCE=;
        b=Lin9JVNbiwZIIGSgNAsaJqUMG+O5ORjCkr1lSnSoRZT08pzeQaCXSjzxLaMIJAXfCa
         0Q6AYws4b+b6dodAmelMrpGRDiXPdKUfn9Hm59FbZ9Q3Roegp0dnLxCMoScB0tphoBSX
         uhnWo92jJiAaL7H4oam5mK+MFdgme5Y1EOX+JHeUggLKaeGE0DyoMoon68IdpioixNP/
         eOeBB52VK95w4V/AlG+jkMgzWvWyvSJaC6sL01Pqm53KTkO3FMTcnllu3Y1JRu1sbPvG
         vRH4dtl6dKgWJ6mWjw6mRIccPe3ENW2LefG2ickyHi2otx/wFDk66Y6Hgyrr9YypkMKF
         QdkA==
X-Forwarded-Encrypted: i=1; AHgh+Rp6PCFJJmkbWYu8pVt6JudA2UXRO5vICL8hOUM3ZAmYRt2T6LXJvuPdDeX5GcG1fIP9NwHSeDAtlmVrXv5e9w==@vger.kernel.org
X-Gm-Message-State: AFuF++niARm1EP/T9+Y54gMNUteBeHnZcmcepEFAM6Ydj+1cmpMuNmwU
	mk1cLh0YwGRnkbSmk3C+LXp6ymDV97BcM+ir21eNGUPBbv/fWCjx6QjDwi2w9FRWzCSpeYntkxe
	6O02s0xsFnwzLqgZs6dsaDEKSAIX1lWxpws/ayDhB
X-Gm-Gg: AR+sD119j4Lec5K+gZlu64GBRvR88lLXn5I8urDmRslNNCtjkxOKLjUB1bfOVbDDwrs
	cYroiS5cxObcGOMkyP9ty3hkh6YrbYlmZphmyioVqYx6yDyj6BxN6ybp0HguxJ39sNVFksjV8TN
	2CLfGAs+9fODE97C/0Up3qbPoG5FBQk2LWbRv3mclktuTqCpk1q03Uog6PYOHhtDlRBZVhtJJpB
	gw7K43oq4VrVjqUk2V0v8HO261LX2LNqNPD4rEyOx+85Dd/hxJ/T0ovkOxIo3c6qGWnW2Px2I/H
	MWWcfXAdUzoknwfbftlT+s7QRaCur+f2puAYUozn9DQXgveINtbQQJnr7AShRio5zMX2X4lgW14
	lY/ClV5Ks4yeBRhNkqKJhV7HqMxmZ+SaB
X-Received: by 2002:a17:90a:da87:b0:36a:5d1f:7b6 with SMTP id
 98e67ed59e1d1-396d0d4c42fmr9563046a91.2.1787894758191; Thu, 27 Aug 2026
 22:25:58 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:25:57 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:25:57 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:25:57 -0700
X-Gm-Features: AcwNN1V4QqjGk4nAEbmFvmEZJhLWR8irifXvEm-WOqTp4ehBPl97ZxhUjAj0Tc8
Message-ID: <CA+0ovChRy63DAXbxzSqmSQ+QTsGe1=GrwYceenJM1m0ebUxQuA@mail.gmail.com>
Subject: [BUG] ath6kl: WARN in ath6kl_htc_pipe_conn_service() at
 htc_pipe.c:1314, :1342 and :1347 during USB probe
To: Jeff Johnson <jjohnson@kernel.org>
Cc: falemi@asu.edu, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/138-ath6kl-bmiss_enhance-outside-wmi_ready-guard/

  WARNING: drivers/net/wireless/ath/ath6kl/htc_pipe.c:1314 at
ath6kl_htc_pipe_conn_service+0xb46/0x12c0
drivers/net/wireless/ath/ath6kl/htc_pipe.c:1314, CPU#1:
kworker/1:5/11133
  Call Trace:
   ath6kl_htc_pipe_conn_service+0xb46/0x12c0
drivers/net/wireless/ath/ath6kl/htc_pipe.c:1314
   ath6kl_htc_conn_service drivers/net/wireless/ath/ath6kl/htc-ops.h:42 [inline]
   ath6kl_connectservice+0x16c/0x6b0 drivers/net/wireless/ath/ath6kl/init.c:291
   ath6kl_init_service_ep+0x21e/0x2a0 drivers/net/wireless/ath/ath6kl/init.c:398
   __ath6kl_init_hw_start+0x8d0/0x1260
drivers/net/wireless/ath/ath6kl/init.c:1753
   ath6kl_init_hw_start+0x16/0x80 drivers/net/wireless/ath/ath6kl/init.c:1832
   ath6kl_core_init+0x7cd/0x10b0 drivers/net/wireless/ath/ath6kl/core.c:191
   ath6kl_usb_probe+0x1b78/0x1e20 drivers/net/wireless/ath/ath6kl/usb.c:1162
   usb_probe_interface+0x657/0xc70 drivers/usb/core/driver.c:396
   really_probe+0x267/0xaf0 drivers/base/dd.c:709

  WARNING: drivers/net/wireless/ath/ath6kl/htc_pipe.c:1342 at
ath6kl_htc_pipe_conn_service+0xbdf/0x12c0
  WARNING: drivers/net/wireless/ath/ath6kl/htc_pipe.c:1347 at
ath6kl_htc_pipe_conn_service+0xc3d/0x12c0

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
