Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163370;
	b=Pn/Vym1ovoSKMPe/0XmvDxPcTWgv4JLnYm6NtWE9+eytU4HuwDScPoLwWhtFPdpFrk67
	 PXl9SR/d42j9xFJMCOZjUQS/VSmlZ7UAW8fXWRB/PC7aCVVEkL0pGcUR1fzelL/2kiOrS
	 XJsb+Ry+7xZbPynmrUkM33z8BwjG5I1nyjCsMnyEM7WU69ufZBYCdMhSnFSPDIEGLJLzC
	 iXL3BLocuGNbkitr96l7ffIZKHjkpB1IZf8FE4fEXgn0nFLI52eN0TY1BOgxhFRxH2Tor
	 k9Je5C0OioRz8yTcoH+0AU6w11TpTf8zJCkB0YdO1YS4KSXomo+ObdkdUyIVmJ5ck/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163370;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=dsDowGSYoxGu9+irhx9RkJvgVFEZ+QUTEu+MxkYXLP8=;
	b=pC3yZLCzrkTSZzE88ojSpK0XiW/pZlMdLxm2hY+aUz42z3C4qiHrJ40gYMw6RvSX8rt6
	 W0V0KK/Z4PFoN+ELTbGj2d9Ms9LsTr5jzu5RzrH56M4d5D33SG8pzIvlg0kT7A9khMyUu
	 WY1lFqpfxB61tzgzhli5EJiyNoSs3Xa7rvkFBx0LDXLQl6vld+vr3MapKfL3/rxOm2Fd/
	 D/Kvr6mW0LGFyIVozwAKgnJw35ptcei7CQgiOBB3jDjqDm8JZ8rUpKJw8++I9nViZcQrX
	 OjWHbCfM3hjGENmoN6AJhnt4a3ippFaBDjt/4mXf8rNtqPwWNMhg82GE3y2Cb2UOujA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LSCU8853;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350E606A31A;
	Wed, 28 Oct 2026 04:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7350E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LSCU8853
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ds
	DowGSYoxGu9+irhx9RkJvgVFEZ+QUTEu+MxkYXLP8=; b=LSCU88535R04f6KjMb
	luo92xKgQsUqDoBy2OJOEPkdqLc83u8+fNZugrlwWDMROiS0ygmiXSxITa+2VZ1O
	evpNdQPTjCtxoT4Ff5d2SmpLGFLGSbQmtcE4CLpfiYD74L0+XrJz5rs9jFgOo4sU
	RdK31PnSbkcm+ocfG2txELcHs=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3P1NkgOFq_DBWDA--.43191S2;
	Wed, 28 Oct 2026 12:56:04 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: ipw2x00: drain IRQ tasklets during teardown
Date: Wed, 28 Oct 2026 12:56:00 +0800
Message-Id: <20261028045602.111668-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P1NkgOFq_DBWDA--.43191S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrAr4fCrW5GF18tw4kZF15twb_yoWxWwc_ur
	s2kFn7Jr45X3ZYv3W5CFWjgFW5GFy5Wr1rWa1jqryag343ZrZ8Grs7Zr92kr4kKF4ayr98
	Zr9FkrWfA39IkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUsjjJUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgVMhmrhgGW5MwAA3l

The ipw2100 and ipw2200 interrupt handlers defer device processing to
tasklets.  Their teardown paths free the IRQ, queues, MMIO mappings, and
driver-private state without draining tasklets that may already be queued.

Kill each IRQ tasklet after preventing new IRQ scheduling and before
releasing the resources used by the deferred handler.

Jiale Yao (2):
  wifi: ipw2100: drain IRQ tasklet during teardown
  wifi: ipw2200: drain IRQ tasklet during teardown

 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 6 ++++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.34.1

