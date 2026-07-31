Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B835340260
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480381; cv=none; b=XcN63tKS34g7GgnfOlTuAXQ7Wz4L3QfuVBa/pwCc+U9nJGyVpMUkCyeyrDtkDn9M22HjHhdEuJkgpWJLKaAne1/KA2rlGflW28DzvGV/g0euSOzG9rkSNy461hUiqALOlEvxRlTitDQDJNwmTbuGSOAVgZ33LPavnpWa24ztJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480381; c=relaxed/simple;
	bh=mP5w+iKROe78K4kAjFW3YbfxKeb5AiCoVYVXXpGjaVw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uj+omwNKT6E8bUqAoGqcRRZC1hKwJTZWibL6nyNBIEKtJrj9pH8QYIDQFYbFrvsSXwovuzqrqvdDNUexftdY6hcYXqwJvH18DXaJwwQTZ63KQmMrIakXSzlc76P9isnmlAZHUw0NhgQSY6BvjEqtUJ5RwxMQoIPGpG65+L5qpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=tb2As3w3; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="tb2As3w3"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso384425a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 23:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1785480379; x=1786085179; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=svYZRSE64djQB563tIUBn48eNZ7rjVNyU2LRIPP8WdU=;
        b=tb2As3w3m2Ubg0RXmgz2h9YGjUPVpTLFvp/dkWbgrVbBxN9bmDLsTxxN7eFVRD83zP
         zNt/+5MbbTC8cJjBtXVQYIRZWp1rZzyJMisMQr+5j7684h1frp9AGM1ew+M2JseyU8dc
         DFI4sFHbejW/Z/GxlsMP0FKMzvmcw/b6Dd6zPEnAIPVKfz1kVP9jWrXTt3ZnmQDbpCdw
         BpHZHyoidgAJ1AthVEnc6p4hAyMTZ47Aft9TJ9aIX3IQIQ7Sf7i7Nuvc36oOe0YG/OeV
         SxVlc5Atr5oDUZ0HAr2EpOrECUd+encHOmluTs1zPP9gOmP2nEDMP7txTTJmH4voKFXI
         NA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785480379; x=1786085179;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=svYZRSE64djQB563tIUBn48eNZ7rjVNyU2LRIPP8WdU=;
        b=D4vziRlCNvTFrSNRXqBzKigBY64GUQPVKbA0cKdS6sIS+pruw0N6Q7rYXT/CqRYl4A
         eJQE6M+knsbYzww2P+3hXRe+sTH279bTYqGGE88QRKFWZmGXtXxwsfsuw3CgsohZOZOY
         6xQXTNSL9hG84XiB6JpDh0jhLKr+KRw47HjQIF3/V/SJgCeiFCKmrTIkBt6/Qx9HQeJt
         J0fYEVIk/E6ZZw7n+OfeWS8cJq/QK6nEOn+gT262BKV4PTckUMMJz2PGBadt0oEwVC0f
         7cOj5nHZA3lRB6TttZnWTBR2l9ZRCSNZzLjGIq28wPSpam6vnznPpT0X+nC7AOnQIZls
         FebQ==
X-Gm-Message-State: AOJu0YzvWnZuVBZX5Y/tbf/REhOTpeN3sh2v5JPtDLEQE53uMR3RJOMh
	bMiQEE4RNJpfFoPtdWneLmo2wgDCw+J7iOscW6XPhhnOymXMuPfJ41nI3spgTbf0LHc=
X-Gm-Gg: AR+sD12snDLRJnhxsgE3YqdEK1SjwKFunij+ZJNFiTwYyM2t+4zRurfh4tWYAM2IWVJ
	rw40WuyCgP8SZqdvSAH9/Ch2B8+DrylZPvZcAcEJ/Yclr69kQuMiA50v5LM3feMq4YHW4r4wMN2
	3h+l+2Eq6CYx2brpkkcFe58mAR2H8db5aVyHq7BZThf9QQMwQbKvkrsqpK9gxCDeP2ia9kuKOyB
	H5JLZO+xABisZhahXawnusOtTcA9i+SiZHYviLahEWLBK6S5Hs74OTwc+ILnp+jG99oIEaZAMmS
	SKcPCS6ql+wQciNkxFWz5KDr53kss/ckabfFZep6TZQwTRfRuzt/GW3KFSlBbkfjvVtHJrKwE98
	o2I4mEUGMq+D7tRYp2lRogiaRc69QeqvU3cOqU5dKmxjJoVSIg80iuHH/wmYoGx6LgIgTod9ous
	d6zO0CxJrOrH5fTrq2CQeyVabwQn0P2TotRJNnomJrrS5SF/Xs6IqRfe/ooAuVes/2DWBgFty+l
	9NsHQfBPzesII216iNwJFt9wDJdwMrjGnOPd5bj0ZOwnsKmxsmmxhXTNAjS
X-Received: by 2002:a05:6a21:3941:b0:3bf:82c5:ed13 with SMTP id adf61e73a8af0-3c91b319392mr819485637.38.1785480379312;
        Thu, 30 Jul 2026 23:46:19 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e18e107sm2210429eec.27.2026.07.30.23.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 23:46:18 -0700 (PDT)
Date: Fri, 31 Jul 2026 16:46:13 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com, lachlan.hodges@morsemicro.com
Subject: pull-request: mm81x-next-2026-07-31
Message-ID: <3wboegj7eyorursqi7gftc2s3jqtrfi5fv3k57eoqrr5arxmnh@2jextspacknp>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This is the first mm81x pull request, so just a single commit for us
to test our workflows using b4/patchwork and all that. Obviously
in the future we'll collect patches overtime like other driver
sub-trees; though I'm sure our pull request cadence will be much lower
at first.

One thing to note is that the tag is not signed, is that something
you need us to do? The docs appear to say that it's really up to the
upstream maintainer.

Let me know if there are any issues etc. Thanks.

lachlan

The following changes since commit 4a0bd262df757b25fc4e2a53c947317c119ced4e:

  wifi: mac80211: fix per-STA profile length in cross-link CSA parsing (2026-07-28 16:04:16 +0200)

are available in the Git repository at:

  https://github.com/MorseMicroLabs/linux-wireless.git tags/mm81x-next-2026-07-31

for you to fetch changes up to 333f7de560e1196034b67db16916b10a0c529e1d:

  wifi: mm81x: prevent timers from outliving teardown (2026-07-31 15:42:49 +1000)

----------------------------------------------------------------

wifi: mm81x: updates - 2026-07-31

- Just a single fix for synchronously shutting down timers to prevent
a UaF.

----------------------------------------------------------------
Linmao Li (1):
      wifi: mm81x: prevent timers from outliving teardown

 drivers/net/wireless/morsemicro/mm81x/mac.c  | 2 +-
 drivers/net/wireless/morsemicro/mm81x/rc.c   | 2 +-
 drivers/net/wireless/morsemicro/mm81x/yaps.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
