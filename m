Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6541B455630
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812674; cv=pass; b=C+v52uezUPsfEVSoQ/2MYfnHFzkl4OSNAxRMt3BC606HzlMo3ZkBbyCq05KhUFPiFQLQhAwE5vUVxijoqh3VyT+t2MTL3NOCdDWjywhf8qJiUGAhZ40JH/qI3+DeCwCSopObmwC+Po6nEAjP6eaV2Welv/kS+evwP95Kjs9CXPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812674; c=relaxed/simple;
	bh=SvG+erpY8uKXFYtGDRyc3aMqWU3WSYP43CA+vhvkcqM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YaEqm0WSWPN8VPVH6Ae17tjm6M9Biw7K0ecVlKg+fmGyLRyHsJtk+3ls11lAoUZPCCkD0fDAL8D2wVrIcVye+DK6NWrXH3RYBCPvzWb64lygscj60pSIoJ6chQPaE3IgQSiL5kEImFqsHSWt7E16NeMU3Zrqcyu4sfaNgH+6BxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E23Fxt5h; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E23Fxt5h"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b55da9so159013f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 03:11:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789812671; cv=none;
        d=google.com; s=arc-20260327;
        b=GGg++UYAjXASdQ/K5BvLxA0OzIGumeewhSvsqYchOxHl0XBUbucq2GOMPWwt6utSeH
         +3CiKNt98wFBHhlzqwE1+ZFc1gV6VWhSW7FUwSZIxgmif3jYt7/etmLkCWS77rx8Zsx5
         IL/YXBPxA3XvuJux5pKQo7SRKi9iVe7splDj1TsIQn3DzmugTQWYf09mVl4ngrtHoir/
         mevArALX1fYAT0sUCyGVw7qHTKL97y8Sc2DhBGoxHe10Tm3qVVAdHHbgI5eq788J2Nra
         4fbSyuymT2s/f7Qpb+g3tLyTJmU2RlJBgLQYnnC9JikiGcnUF1zjH0JYtqnnrajtuI15
         S0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=EIntrnUYtiLQgtTmdNzLmKPD9h2uP9+qst+23raNb5E=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=W55j8eaQIN/afUIbURTAxYmNlEkbRVUWDj054o0PnP51QQ7ClvVhTrzZsinQTxot7E
         TxKTYk1ozcxRwwin98rZcRfo6DGlo/zEL6pulK1X4fs8+nkQZ7JsyTkqV3kONjQdwrwB
         FZEdPKGOfmxcsqMbVlyTxMPwe65mFBPgVQK6TpINGicxGF/PXrleza1hIt+oI+JoDpid
         EA56/BZQrqPOmS8ocL0u6Dcp+LbyrQA0ZyjbIHbHulOM+NmyxVxsMPyPl7603g+KTyAL
         A9+FVFm9WgbZ+rb7WgJSEV0e+JttfZpYCqOuSE4zvY1W9a/dof7a+8AlZjVp8I3NIZbb
         uM3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789812671; x=1790417471; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EIntrnUYtiLQgtTmdNzLmKPD9h2uP9+qst+23raNb5E=;
        b=E23Fxt5hj7TlW+IFVcPqnnZcv+CM8JIgdY5AiLORcVW0drKrRdcEE4L/0SnXirkHyA
         SC4mE6O2A0p/fN4mHgnW5vjAwDy0ySfdVzhthtT6uaak4rAodQwNSXKv+MJCmL3H4gd/
         Ajo41e0ClfSqItBaAo6VnIcBVUX4UArxf3eMGd5b+SB3/mXaHLH4yGuXOO1YQs4tWumZ
         5rXGo5lszOq3DW7rAi+5ZyStfQIlAqy+NSg3KCRkYGuZfKtBpAk+/+BeAoeIufueAqf7
         Dviy9x+K7nBNIZAOnMK5aYUxlITncPBDVJLgcQZjEfVV7Naao7v5C1nPW0ElT8kplEQm
         H3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789812671; x=1790417471;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EIntrnUYtiLQgtTmdNzLmKPD9h2uP9+qst+23raNb5E=;
        b=BBzY3kt58LeC0jwToSCfvtiCoJe1TG4OLtsrXvgUFo+ngmwULtS5igySzKbZUcQ5Az
         3Auac6loslubQobocxGtDqXjQqzhXzxHdzdL+86o6n48/aM9sKCBBpTtORj/zRTfZCjX
         +wFhFYrPTlYZR284L+uiOysv5lAjbBZwSCPPIp+uHfH0Jp4FijFqa1k1fBIe2IyGf+rH
         VxQmvVR4FovX/x7r4n6gDzhJ8sQPBOAay3JfmGkn5B5hghCG+NmXUgDpVeok9ufYm0rF
         72UE77hjpEF0U4z5o+LuFsyGAnu7lWN4Q7rvDdPLQkjE8spRJxFK44Cd7zUSfr4vJJ3W
         UGUw==
X-Gm-Message-State: AFuF++kFUAf5Rf2nIcySeFcsQyAlpZ5y0FxRlTC+SfY7S8J7Lt7JrB2i
	9p/vmIIsd11hJNsR4WkcJuCEUs1CWmHBLk3HtfvVyn20QhPA9cMwsXF802PKUvC/b+Ulrk788gj
	+vcTvASv3KRgNudnvV/dJXCJz64iHj90slLnuoZU=
X-Gm-Gg: AYBFou1WhIkyajeRC4OdUCLqRo4A7LimmMet2g7P+Qwqm7IKKA8asG56/qi+Cfh/oyT
	PUPnDprWP2tVcY+UNL1gW78eb5RBzardNmE2hEP/DTlZmHXcj7EImunxuVmxPC3rP0vQbkzNiJE
	4gWX2mLByAMd2ztvQqm4ihsGnz2AgQdmvbrfKF06YIsKFelOHG3efagBqOqkrkizejjZvjyT/1r
	mDiSLJKilIv9yeyD3dLpA7whER2rQ2W/2gopqf2mxe7bfjOaxao6ET9UbjmT1xMQdQaXttIDYno
	ZJe+oDiFktVb6EqrDW7wLQLVOVaCpPgBA7L9t5uU7c8Ph+wXSVqwxe4mMQ==
X-Received: by 2002:a05:600c:35c2:b0:49d:1da4:511b with SMTP id
 5b1f17b1804b1-49fc7dd94c0mr66826705e9.1.1789812671284; Sat, 19 Sep 2026
 03:11:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Bedirhan_Ayd=C4=B1n?= <bedo9737@gmail.com>
Date: Sat, 19 Sep 2026 13:10:59 +0300
X-Gm-Features: AcwNN1U0r46a_A-JGSrGwUu2iIYNHiWbhjIB3mMzCxxB_wgVZgJ86ugNFjiePQA
Message-ID: <CAJ7TRjmy44BUtm1BP2-Uy2D6h+2sQypcMEbFU3eGwvgFNaNrig@mail.gmail.com>
Subject: iwlwifi: Intel 7260 firmware crash (BAD_COMMAND, DQA enable fails)
 with 7260-17.ucode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

My Intel Dual Band Wireless-N 7260 [8086:08b1] never works on
Linux, but works fine on Windows 11 on the same machine (HP EliteDesk
800 G5 Desktop Mini). The driver and firmware load without errors and
wlp1s0 appears, but the firmware crashes as soon as the radio is
enabled:

  iwlwifi 0000:01:00.0: loaded firmware version 17.bfb58538.0
    7260-17.ucode op_mode iwlmvm
  iwlwifi 0000:01:00.0: Microcode SW error detected.
  iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND
  iwlwifi 0000:01:00.0: FW error in SYNC CMD UNKNOWN
  iwlwifi 0000:01:00.0: Failed to send DQA enabling command: -5

Kernels tried: 7.2.5, 6.19.10, 6.14
Distros tried: Fedora 44, Linux Mint, CachyOS, PikaOS (same on all)
Firmware: linux-firmware 20260916 (iwlwifi-7260-17.ucode)
No PCIe/AER errors are logged for the card's link.

Full report and logs (MAC addresses removed):
https://bugzilla.kernel.org/show_bug.cgi?id=3D222030

Is this a known problem with the 7260 and the -17 firmware? I am
happy to test patches or collect more debug data.

Thanks,
Bedirhan Ayd=C4=B1n
