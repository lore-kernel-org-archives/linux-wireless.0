Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A45377A8E;
	Wed, 14 Oct 2026 03:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791948738; cv=none; b=nJIaU/53ZapU1c6hc7Zaxkw4B2DHegSH0oMbf/owKDCOrs2BYVh3qU+SG3r//UDkoaVrRmQNdBsg3Tut212bDtH+R0wfl5fuDfLGnQzpkSWIUDWyolIwziE0j1ucFRiSywBoYPhHPcgL9W+UMjUBB/akioFC/tvLBep6Yun4V6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791948738; c=relaxed/simple;
	bh=le0PXZT+RYzwKhdoUuMggNeNTKLNUgRM/e4Ry+hDeDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YY4ZRtLMFwcqgtBAWf7BP7pTnJMLtGjqyX5XmR7gvozft1OignrI0L9wwDaM4LgJY2o9hHhLp8z+CHGv2dew+jxDXD7FL9ZW2viHuGiUvOSHadHKEg1ebEQHmCHsqbPqfnoqati+TJVQqCrua38RdHm+jXtBmCDSniOtu4izSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NnymO4G7; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NnymO4G7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=le0PXZT+RYzwKhdoUuMggNeNTKLNUgRM/e4Ry+hDeDA=;
	b=NnymO4G7KwlJEltux5wQc3+k0ZI2JA8KtQsM7Z2wBaqeNzDkabtuzOkjocAmr9
	rWMIEq1G7/m+0yuDnnYYknyKeZhwiCvPWr6fYl008aqtcbiJnTdHblYqXU5AZUjZ
	rUIqPCcmNX8cT+H3fCwyKUoDDz0NF7hyzcOFF0VYmJVxk=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBnTaq4985qyYEaEg--.58096S2;
	Wed, 14 Oct 2026 11:32:10 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@gmail.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] p54: validate firmware record lengths
Date: Wed, 14 Oct 2026 11:32:04 +0800
Message-ID: <20261014033204.1985-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBnTaq4985qyYEaEg--.58096S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1kur4DWFWxKw43Xw15twb_yoWktrcE93
	90vwn7uw4xA3y2qw43KrsxtFZxG3y09ry8Aa48ZFy3Jwn3Ar45Gr1rK3s0yr1kXa93GrZ8
	KFnIqanrtw1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREZjjtUUUUU==
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4hp6JGrO97qyCgAA33

Hi Christian,

Thank you very much for reviewing the v3 patch and for providing your
Acked-by and Tested-by tags. I sincerely appreciate your careful testing
and guidance throughout the revisions.

May I also ask for your technical opinion on the security classification
of this issue? The malformed firmware records could cause out-of-bounds
reads in the kernel firmware parser, but I understand that the practical
security impact may depend on how the firmware can be supplied or replaced.

In your opinion, would this issue be appropriate for consideration by the
Linux kernel CVE team after the fix is merged and included in a released
stable kernel, or would it be more appropriate to regard it as a regular
firmware-parser robustness fix?

I understand that CVE assignment is handled by the Linux kernel CVE team,
and I am not asking you to make that decision or take any action on my
behalf. I would simply be very grateful for your technical advice on
whether contacting cve@kernel.org after the fix is released would be
reasonable.

Thank you again for your time, testing, and helpful review.

Best regards,
Heyang Tan
School of Software
Taiyuan University of Technology

