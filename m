Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C52417D1
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785288949; cv=none; b=NtNMiKdpK8Xc7zzykvFNBMKuWDnKQWI4FoSAoTHW8NWZjHDr4Y8UirJ9qHfaurENrHuRApnowArUOXpTWx41FnUa31luJVmfnmjqfYhmSGApP4PYjJNaXbx57FFzaEKJCn4pJ+r5H8s/IrY1mnTO6GUYG3t6HabMJxDa7ZxJR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785288949; c=relaxed/simple;
	bh=XG8pA3oX+7vm1B+kPgpg+QaY0m6isirK0YPztzNyrf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MeLLkT+Cp214Y5IGkSomKIlQiwsLswQeoDRHyqYl1qhNSXFCK0CTvnuvYpUPka6MZwTDgh7BK++N1PT8qcYH3a6gitNOqsppxZrAxAbp4vZRXyk3Xr8UyTesisrOGsEiGYvu1P4LMXinT8C6Z9aKlZaXwtGmIcuO+gY5QAdLQNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+1LTpSa; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+1LTpSa"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso4519845ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785288947; x=1785893747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iuP/AYgdjMyDRmDx/Byw+xb11Y/9nEt37npkFDTyqCE=;
        b=T+1LTpSaMwp0y0ndJ+2MZ365qTZZC7fHv5AA7zZyVnjCfKm/yrZKHKqXWECWfksmUX
         n7I1pNczZjfBzChZFv3KdciU9OlskcyfJjCEnfMApcfv6Z7rcsEXLoy/EWxeA7x5/Bly
         VzbLp7xcnNvwuSLGbN8YWajsl/FL0+/02mJUee+kRAvXB0AXTM05/l3cQr5AEdHJBseW
         8+NZ+rTIeqKDAOIgbZW8bPCAuYoaCStpifxPDAuOu4XFk5NJ/Bpj3770HMHKtIfIKaca
         Dq0cgKnLaRfv71ebpWYQmQ44jVyh101I42htCO4IRnQzZu/HJP7F5uPPK3YjH/ZeYDF+
         UOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785288947; x=1785893747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iuP/AYgdjMyDRmDx/Byw+xb11Y/9nEt37npkFDTyqCE=;
        b=nI+AZoD5UeNw3J4R2xCN3fs6hCUn8VnFvwsAwJdk/9KzPqJGMWYidYSFGewULRUNOi
         CxyUeMt3M1HDgZcH3ybgkmdevoqxbFgrsQ0HsmYIesMscwRuLjrSgWfVnYR1y8yJIfO4
         ghJ8WGuubyBWLX40CQyaOVDEG/yb6sGsk/xLgomjbhdvL1uw31i0bp+UadM6Ql/eJ+aK
         qSxEKtAtA7RHPJN9yDFAdxvdK0EbpUjwdqbt8VpSmTt3uSMzpx1j75nw5sQNOIjUPcdv
         KBDc1CWEWjz2yk3AeOgfi9EVvRpiLfA2kL7FeFwelkgfzAMBAsJ0VxOfTkkiwsLzUK1Z
         hXpg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2YnwVnKobhuHtGkH8E7I+4o2j/4zWIdTfIV9kfvMytgAPoCAPRhbW0WSpPSllTIShe6SHbVLsV/GqivRDQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn4v3Y1NFsQrWnkWFNtriQ6kh8sOeveqibU1YKwUI3CUgM9SMQ
	MP4Vgb8/tWVPLrvGT3rbg2t7FbL2dvZKVCKc1+vYpKV3gljYVIOfHYcF
X-Gm-Gg: AR+sD13p/7ENBJHSOXl7ITBBElOQJsJuclzF2JP9vFzsjaUuZO2w0EJuZP5yNa42ggQ
	ELHx8vWrgOCaNvWg91WWVcJXA0mErUare4kGwz56StPBWE2zWoYhgLDPIR6+yaFxJlPd8oj9JVI
	zEk6FVKvqPmbY5loM/9Wq8Gs3nZFb19agjQdd0MHLTu4Db4BuMEtpMkm/xtuaLxZATgp83gfUjd
	aOiFeUTFU9enLeJSr4PWaby9U9eGePd8pAjY3Z6XZWyDvPvoQzePYHTebC+q5/9mBSODT3ZhLyq
	/eMTOMI2TOH57d9YUUEdd8zM5vMkFki38ZSvFZnZ0tKQeiJ3ICGXIvGFRQ1q0IVC0KoO6eSEQQ9
	6Gu6GV83SnF6VX75Qobq3wBI8amfX7/0BNR5t1ZptGnFA1AlqQNeOfXvhXXP7ize+FohnDUSLmz
	Z2iKoMDawMdTASGWL/FU2ATzWj+DXUs2yxl4bG1dRqVTlRz8dSQaC3hqtBV5S5tYEDAxXm9gCaG
	rWAq4Lk
X-Received: by 2002:a17:903:390d:b0:2c9:97a8:afef with SMTP id d9443c01a7336-2d015d6e468mr54480275ad.40.1785288947453;
        Tue, 28 Jul 2026 18:35:47 -0700 (PDT)
Received: from cyh-System-Product-Name.. ([129.227.183.200])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a167b5sm3532195ad.7.2026.07.28.18.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:35:46 -0700 (PDT)
From: yhchen312@gmail.com
To: pkshih@realtek.com
Cc: damon.chen@realtek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: 8852be: add .shutdown callback to quiesce device on reboot
Date: Wed, 29 Jul 2026 09:35:37 +0800
Message-Id: <20260729013537.2743729-1-yhchen312@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <142c91dfc7334136a5dabc4f91504ec6@realtek.com>
References: <142c91dfc7334136a5dabc4f91504ec6@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

Thanks for the review.

> Does it mean the work is running after .shutdown but before .remove?

On the reboot/poweroff path the kernel only runs device_shutdown(),
which invokes each driver's .shutdown callback; .remove is *not* called
on this path -- it only runs on driver unbind, module unload or
hot-unplug.  The rfkill polling workqueue, however, keeps being scheduled
by the rfkill core throughout the whole shutdown sequence until the
system finally halts.  During that window the platform starts tearing
the PCIe link down, and the next MMIO read issued by
rtw89_ops_rfkill_poll() then targets a non-responding device, which on
arm64 is reported as a fatal asynchronous SError.  So it is not ".remove
after .shutdown"; .remove never runs on reboot -- the poll work simply
outlives the link, and that is exactly what the new flag stops.

> Not prefer calling rtw89_pci_remove() twice.

Agreed.  In v2 I dropped the rtw89_pci_remove() call from .shutdown and
switched to the flag-based approach you suggested:

  * add rtw89_pci_shutdown() that sets a new RTW89_FLAG_SHUTDOWN flag
    (mirroring the USB RTW89_FLAG_UNPLUGGED pattern);
  * make rtw89_ops_rfkill_poll() bail out early when that flag is set,
    so no MMIO read reaches the chip after shutdown begins.

This keeps the shutdown handler minimal and avoids running the
non-idempotent teardown twice.

> I think this fix can apply to all PCI devices for this driver, right?

Yes, agreed.  v2 wires .shutdown = rtw89_pci_shutdown into all rtw89 PCI
device drivers (8851BE/8852AE/8852BE/8852BTE/8852CE/8922AE/8922DE), so
the subject prefix is now "wifi: rtw89: pci: ...".

v2 is sent as a reply to this thread.

Thanks,
Yuhang
