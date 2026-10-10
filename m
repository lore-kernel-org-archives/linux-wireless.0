Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74890296BCF
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 04:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791605824; cv=none; b=HA25Q3XtacDzqaVZs8Q6CkR+WbbGDdMgy77Bx9Y+jiRqpPsS8004rPmzRwxR54n8vuhCCwODydVk+7I16fA9ayAMnYiGZvE6sOMqoticRL3nIUS7azIwzUPx7yX6Bv2rj2ikt/qqzBGHxziuKqZ2DEPCaV5O1YoGWt4uAl2eW2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791605824; c=relaxed/simple;
	bh=haM+oprHc1aKT/c0NODG5npNSDk4EePTr/bx8eMHH8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GlW6siiYYE7FXFauw1HDQ0Nrnpvzb5P+LeX/b7PcUiiOIvfQxjjEecZUsfHFLGX/k4W+Os6+wECXvN4opA/2mXLPoVN+QgFNiCplzQk/08KVZqAK1Fv6WmHUEkJ8uxyY5qjApvy/Op8v0whSkh96evRznjf1ZiNrTRIbq92mfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BQiYs18l; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BQiYs18l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=haM+oprHc1aKT/c0NODG5npNSDk4EePTr/bx8eMHH8I=;
	b=BQiYs18l7eUPtM+osdFtU/F+s+PGHam3R/7e8H6Bo018chatNexTdd6iVTQ3Pi
	DhEMGpi5ObY9Ipz0/YNMQCKe0hwS5X1Q+SasZyEVmai6hsj6mVDJRoyRbf4fRmYp
	Y0aeO+mmlg/JuTCui2+10h0MNNn2AkEPr0wVUxbtkjtv0=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgC3nIUzvMlqSqM3Dw--.47717S2;
	Sat, 10 Oct 2026 12:16:52 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com
Subject: Re: [PATCH v2] p54: validate firmware record lengths
Date: Sat, 10 Oct 2026 12:16:47 +0800
Message-ID: <20261010041647.589-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgC3nIUzvMlqSqM3Dw--.47717S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF18Kr1xWw45ZFyDWF17Wrg_yoW3CFbEg3
	yrX3Wxuw4fJrn7tw4akrs2qF9093yjyr98trWrXF1rtayrJFn8W34vyrnI9rn0yrWaq3Zr
	Jrn0qr1Y9r129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_NtxJUUUUU==
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4hRJ8mrJvDQGngAA3+

Hi Christian,

Thank you for testing both the p54 PCI and USB devices and for providing
the Tested-by tag. I also appreciate your detailed comments on the record
length units and code readability.

I have revised the patch based on your suggestions. In v3, the
BR_CODE_COMPONENT_ID check directly requires its one-word record format,
and BR_CODE_COMPONENT_VERSION uses a local struct bootrec_comp_ver pointer.
The version record check is also expressed directly as six 32-bit words,
which reflects the unit used by bootrec->len.

I will post v3 as a new thread to the linux-wireless mailing list and keep
the further discussion on the list.

Thank you again for your careful testing and helpful review.

Best regards,
Heyang Tan
School of Software
Taiyuan University of Technology

