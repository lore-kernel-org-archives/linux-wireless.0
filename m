Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112053B2AA
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504927; cv=none; b=W+TRqXcP9ihN9q4IxuRKKAzUMCOnvXnSWLgWS5Ve9ZwQZ6UqUqfhDkYI2MhldJARWvPgyUHg9dBih/Xe6jruPrXAoALMbaqIxFZsH+aGomM8LdBBMYcKQLPtIlDUVenaroRL+2VqeScNtd5HYO3RGuCw73WEvuEKVphMxBfd7Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504927; c=relaxed/simple;
	bh=XYkLNO7HOKkslGvDyFyT2FyCYmtkIKuB2ZDMulF0bjs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eozZqS030x+wHG8VBGkxDi0nFTM77iU3V7kvv7ClaJx2tL4rP8Z/l+ARB7tLoE2vnzH1dxbdbCmhukvrKuwSl1IF4W/fjQahq2ECChSO4YDTHWZS79qviXX+yIwNKKvDyf695wxun0cFKfF/Z1Oi2AoA0dgVS6NOHO0/peoFFwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=jflKPvrd; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="jflKPvrd"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ab066bef7dso709605a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 17:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791504925; x=1792109725; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nQugvwRQzb0C/dfuTv9AnuNxPj2TmZ1Avc931pEEIk4=;
        b=jflKPvrdV99rbN0K7EGGRdKLFZmP18clsE8g2DG5X8ZYeSO4GBC8jly8aPhk8An9oQ
         1FX3W2rF0IG79Hmsp9Ioi/i2gx6berS6strCIWVujuf7Yi/gtyxruLm3LIKfRHj1mmtP
         psujRltkabiuQRCnXAdkYnepMM9UDD5rCsVXUiEhJUm09HWUejlMsH+ElZ2wRmvNKum2
         sk7+MyRmObVALd5QJs/hhdworaaQQLC2Y1hxcCPeYBURSWqklEgQOwMCACCSsr1vB0js
         dzDSGr9A8WRNSxf70vCI1XGrNdUUg+1IY55+PqEdZr/T1LEUHs3T0VnOE1ltINYxokD0
         30fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791504925; x=1792109725;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nQugvwRQzb0C/dfuTv9AnuNxPj2TmZ1Avc931pEEIk4=;
        b=GvCGw1lrB/dme7+l+fbj2WDbh4keaiyjOPTpO5wY8sDTKRMIgCKt48/y6DIQMSEheg
         38UGosvClCyv59uyqDANoQt/bW3dyri/+3OsFYfVdHCv2PBVlZII1QiibsrM10zp3n3l
         vUuXXYvBjAuYcqeEHa/fcU+ZZpHb9kJVf4BCoBE/2tmV0oPCl6mzkvrj+3b3+MuJUDKH
         EE4HzFC9sEnMaB30ZT90cz731LDfxAO4M8jlzZblozeXMOsa9NYlT0gghSN3ayUkwt6s
         JN+/zvztLEiHzJi/1wLJGGtPfGgyYjCXclkvl1LzkqGBXhNxXCXZyo4nBtZykHBbA4cI
         NP7g==
X-Gm-Message-State: AFq9FYJgp0VUyL1KyBd+k12oTV4D5pjCmOteKPQoaPCRwiMbGBK12g/i
	pyBLVh+PfIUV2NIGN58+umPtKzzp6ytYmMLQcN700g47s126N+e6oML96/WdN4vgybg=
X-Gm-Gg: AYBFou0jm8Dc9AOm+efRJKTNGsHoka9BM8gEBF4CU8asQIiuBA+qGKbWDT9UigUJ3bw
	Dt/iqvtlRdJbULdJvbZiJFgGO/JlXv276dxv0P8Ih9hjb3m1PCCcZaCYSoKoOavwPx1sqVGUSWo
	YXewpo6SbWCPthqlInXU4fLlquWsuwxuq4IXV5otaXSrUaXWwEaFSB1ESveHy622hKWs17DAcyr
	nxMJATBlnuqCflWQPy7GRHH7FB0JsRDAM89vM0VWBnn+3Fx5pQ3TkgwWCrzFn/+C2QZFw0QLFRj
	vqxZ/SMa949xOGsfYBZGbeybB1ReJhdlMLM4UnALACa3/TkKoXodjMBRD7CGhaRjVkJFkPQfutW
	9nc/P6F82UhdhrpGiB/KgR4cHgiLzYZj5N8ppm8nDloC7VTAJTSLA+JpMB53o+8o1BclT9MIvL7
	ZV9W+RIG+8ga6uwHKPhfZLSzNa+FAih5kGil0s5xaky3dJoEjMEiANR+8Yi/9JD5kSDnBOph3+Y
	cFz65v2ikFuovsD/MuWYgvkzbnOlxConkls3i0TcZrkPClzPGNTIMzuAKV1i4O7DQMizHM=
X-Received: by 2002:a17:90b:3143:b0:3aa:548f:eb77 with SMTP id 98e67ed59e1d1-3ab3ac95141mr401973a91.56.1791504925326;
        Thu, 08 Oct 2026 17:15:25 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36f73e7fsm956292a91.0.2026.10.08.17.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 17:15:24 -0700 (PDT)
Date: Fri, 9 Oct 2026 11:15:22 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com
Subject: pull-request: mm81x-next-2026-10-09
Message-ID: <5nsu7ql74yxvf6jy6t7rmo36h3qhfkmuwx256gngcvzo5xc2lt@opgrvjbyckhz>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

2nd mm81x PR for 7.4. Monitor mode support being the main thing,
but also we now pass a station in rx so atleast 1MHz primarys work
while I ponder on how to deal with the 2MHz situation.

Please pull and let me know if any issues.

lachlan

The following changes since commit f49defea7668d8c68ec19fa085ef3da6075561c7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 11:02:44 -0700)

are available in the Git repository at:

  https://github.com/MorseMicroLabs/linux-wireless.git tags/mm81x-next-2026-10-09

for you to fetch changes up to 7e6689cbbf9e6040e4ce38656a126459aa994f68:

  wifi: mm81x: validate YAPS receive framing (2026-10-08 10:36:12 +1100)

----------------------------------------------------------------
mm81x 7.4 PR #2
- monitor mode support
- rx improvements
- fix persistent NO_IR flag bug
- misc minor LLM fixes

----------------------------------------------------------------
Aamir Ahmed (1):
      wifi: mm81x: validate n_channels in disabled channels response

Felix Hoffmann (1):
      wifi: mm81x: validate YAPS receive framing

Lachlan Hodges (3):
      wifi: mm81x: provide the station to mac80211 on rx
      wifi: mm81x: add monitor mode support
      wifi: mm81x: copy new sband for each module

Muhammad Bilal (1):
      wifi: mm81x: check bytes_remaining before reading delimiter

Samuele Yang (1):
      wifi: mm81x: start beaconing on beacon enable not interface add

Yury Norov (2):
      wifi: mm81x: switch to use fns()
      wifi: mm81x: use hweight16() to calculate bit index

 drivers/net/wireless/morsemicro/mm81x/command.c |   5 +-
 drivers/net/wireless/morsemicro/mm81x/core.h    |  16 +++++-
 drivers/net/wireless/morsemicro/mm81x/mac.c     | 297 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 drivers/net/wireless/morsemicro/mm81x/mmrc.c    |  34 +++----------
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c |  14 ++++--
 5 files changed, 273 insertions(+), 93 deletions(-)
