Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644C495042
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 13:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788614155; cv=none; b=sK8CElMzMxHNK4sDyh2Fno/isGd2+vh90GIc0ybuHbnZGBMW0JlwAZ+qCSyHZU32J6q3c8cdqAGSL33e8jktc7nJHBin9ILC5ZNHne4aWu5LsR2BpxWhBBcoljGPU36KOnGvaJT1uumWU7Z73FEIGV9foAYzwe8t4a9q7ozNwL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788614155; c=relaxed/simple;
	bh=x02e+AcQWhKoSDQts+n0fQrOPhqoUTC6Kx6Hf72oalg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qoSt16Wpreh8SABRlhKei/rpz70gHUJcG3POCSlRQbO+28LLau53o+V9gHnplN280+gaJw/lDDe5YceyNlyIZLt4oMIXdqlSOfpOHmB4eM6Aztj9MHxqjEtqIw3kSU4YB29yEBHHf9TVyfShs3E8iSs65NyfSlMTll4THsHJHVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRzuQXrJ; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRzuQXrJ"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c8ee87f7eso17544851fa.3
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 06:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788614150; x=1789218950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1IAKejBbCFEENItXm7dVKC6hy1rL0d1+FmV8rB7wtwg=;
        b=YRzuQXrJlk9DlIa4Mgrgia5KUJ7BcsfgMMiqTJrWY1gnp30FZAHIg39245r6U/buFC
         iPYd5VnGhpsEKCjo3uZh4lqmWCkBUJPuBhbngzzomBN7klFkU2PtZl4rlcJCUMJh0506
         xW0jAUvKr4SsN+l0tTqmp2KdYibBD3ijPUYW+/xHUq8Ejwt8QL2R59rsTEUBO0jYv4W9
         HXscJVz49+h5ZM4XCvkxC5ai2Kz4JXD+5EpN/1nH67TuEGy4wyixyctGjHVIdLYETqot
         qTCx4zdbyDuP6YRZWqDXnh+RZspyYeRn2Zjoq29biDdQGgHE4DgqhSaEEqxyns4tU30a
         kf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788614150; x=1789218950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1IAKejBbCFEENItXm7dVKC6hy1rL0d1+FmV8rB7wtwg=;
        b=NHnhwGBujPHTbYbUpeQ2X0V+Knp8fo9NiUh9g+Xd2d4SfrmLFk8b4InDLeft+8jYPH
         hiDwdaIqxGOh76yPWU339kgebVtdGIVhR+k+vC2DcPr76r3MkofpAo40I/NoYuoT9fOR
         pEvjbSh/wcx9RAK6ZOKKyJCHw/mS7HuGMZ8D2FelB7czLnqydmUBbwDvkPioLKzO7EIA
         9qpS5+od3Ip7ZV+JBsbYDdOyM9B+miCJJFUcFd5VcUODtFBSd0Uw1+zI+f6zDungfTw6
         HAIXNzYMUGqNWRSYPw08PjEd6zhPvMaRaAf6koC+xcVdWWwz/zYoHii5F/hoEgZsIbRD
         hFKw==
X-Gm-Message-State: AFuF++kM6jS175I88vZbbQZrZ1w50g/FfHmqHQevC7bdd/iVaVbG2EY+
	DnslBoKCNKxpuc59jAlPZHHBOkSEMOq2iWh6pRfmCKe22rp71tgrNK66
X-Gm-Gg: AYBFou3HD3sZLHKVmH8LI63F4ZwArhakPM7iG50wVpeSpJ4wp3k9sfzT4gIR8iNhT+t
	PqUVwSx+W8TBTDhf7hVO32WxW4OXu6sVBFimapA60bA815XanxsTYoIomVEyFftp6IkNJK0URmY
	BPbsLIhL4FUTpRwr8HORwlzC8TPnYCu9xSYdwl4oGmmBr4Md+09bQLXWBjkaJLUxgsd6vFlOwUl
	Q9iJe/QUUyaS3Gj7TshCaL6RW69ualx0LCgHLJNt4t62lsUO2P0eLkNCbVdRO12wBIBfS407E0E
	C9qOc/0CxX5hu8olickb9lLKpUFh4FuUYolgvzZYF8oGuDU6F7Gl1SzV1Efs48BDOUyNpuK9RRY
	MtOT82Znsvtol4hhy7Z5wmkFRvN+wRcFrKBWwYUBgZrB0eq1t3WP52e1dnqEA0tBadYzoYknEE1
	gVA4+Ib3YqeK1kztmbYZkCQ/lilO1xZvqVkaL5cyR5Bw3YQzqHllFnXWd2yshhF1uoLh4z7/CVB
	/Kd+EHnKdcNpe4=
X-Received: by 2002:a05:651c:3252:b0:3a3:7680:67fb with SMTP id 38308e7fff4ca-3a3768069c3mr10124531fa.26.1788614149456;
        Sat, 05 Sep 2026 06:15:49 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.21])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a37048de3csm15341411fa.2.2026.09.05.06.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 06:15:48 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: rtw89: RTL8851B BTC entry requires unpublished firmware 0.29.133.0
Date: Sat,  5 Sep 2026 16:14:36 +0300
Message-ID: <20260905131503.6160-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While reading the Wi-Fi/Bluetooth coexistence code in rtw89 I noticed a
BTC version entry for RTL8851B that appears to be unreachable with any
firmware currently available in linux-firmware.

In drivers/net/wireless/realtek/rtw89/coex.c, rtw89_btc_ver_defs[] has
two entries for this chip:

  {RTL8851B, RTW89_FW_VER_CODE(0, 29, 133, 0), ... .fcxtrx = 107, ...}
  {RTL8851B, RTW89_FW_VER_CODE(0, 29,  29, 0), ... .fcxtrx = 0,   ...}

rtw89_coex_recognize_ver() walks the table and selects the first entry
whose fw_ver_code is not greater than the loaded firmware version.

The newest firmware published for this chip in linux-firmware is
0.29.41.5 (rtw89/rtw8851b_fw.bin, updated 2025-11-06; rtw8851b_fw-1.bin
added 2026-02-13).  Since 41 < 133, the 0.29.133.0 entry can never be
selected, and every user loading firmware from linux-firmware ends up on
the legacy 0.29.29.0 profile.

On my RTL8851BE with firmware 0.29.41.3 the driver does fall back to the
legacy entry, as expected:

  [BTC] use version def[2] = 0x001d1d00

To be clear, I am not reporting a malfunction.  I have not observed any
concrete problem that I can attribute to this, and the legacy profile may
well be perfectly adequate.  I simply cannot tell how the situation is
meant to be read:

  - Is firmware 0.29.133 or newer expected to reach linux-firmware at
    some point, with the driver support having landed ahead of it?

  - Or is the version code in that entry not what was intended?

Either answer is fine, I would just like to understand it.  I have the
hardware and a debug build available, so I am happy to test or collect
logs if that would help.

Thanks,
Maxim Skokov
