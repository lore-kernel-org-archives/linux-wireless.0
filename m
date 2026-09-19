Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1820625228D;
	Sat, 19 Sep 2026 04:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789790640; cv=none; b=Z8qGOTTBBxPEBvvPvY1Qj1n1JrQJsdFalPL0jUCLcgIxU/5re7bhEAxAoE+6xiBVOMh5yJO3k3ab5vsmQ9kknEjZV47EXEy62S9C7kKdBCz++BtbtqDQwzi606BYBPGWO1bPkBS0VGxd/yyZQTCYwghwbDf3vYR0sI4oc1FwqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789790640; c=relaxed/simple;
	bh=b8PGEp53iLDpRBWrkSewl4eG633K5VkhYEgvg9FZ7V8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQE3p+bPmS2Sep9bFz7f+Q6upOF/+TbYNuXd0hV+17VqZKUnNYp1DfyI+6nf/J1Dd4AHt2OlqdNM+AFNabh8AZ07WrHhJW5YYlf/AbTQISJep7JRb5YOa/6x+bB1xYOxi0eJD7qSHJ5RPRzyz9CjrsexYGe9Z2mDE0BCLhqZa9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Fhvwv0Fu; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Fhvwv0Fu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Nk
	TvpKMZ0Uo0K5UsWcfV+vu68SowmtvV0zwRBYT+4Fs=; b=Fhvwv0FucYcg/W5bZD
	emY3Sqhg9kmWYfgY/WbmyIqhmPhLEmZ673IR38HZrrIHaC/pHPlHxadONerBeUhc
	BhdR4VY63ZgaIO/EpNv1lPOf79pyMyU8JWBqyt0tpTktjkB0GXCb3YAYToB6ChFY
	F9msgvL2fm/inPg0CfgobR8v8=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wAXD3qTCa5qcskdBg--.16979S2;
	Sat, 19 Sep 2026 12:03:34 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: jeff.chen_1@nxp.com
Cc: francesco@dolcini.it,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] wifi: nxpwifi: bound debugfs output
Date: Sat, 19 Sep 2026 12:02:51 +0800
Message-ID: <20260919040253.590-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXD3qTCa5qcskdBg--.16979S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF13Wryrtw13WF1xAF48Crg_yoW3ZFc_WF
	ykKFy5JryUWasFgFy7CF4kZ3y3AFWkW34Sga429rW5Cw43ZFZ8Jrs5urZ7Xr1a9r4jyFyx
	C34qyFy8Aa90vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbQ6ptUUUUU==
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4RatV2quCZbIGQAA3H

Bound two nxpwifi debugfs formatting paths to their output buffers.

Changes in v3:
- Split the histogram and debug-info fixes into separate patches.
- Rewrite the commit messages following the feedback from Francesco Dolcini.
- Move test results out of the commit messages.

Testing:
- x86_64 kernel build with CONFIG_NXPWIFI=m, CONFIG_CFG80211=m, and
  CONFIG_DEBUG_FS=y

Heyang Tan (2):
  wifi: nxpwifi: bound histogram debugfs output
  wifi: nxpwifi: bound debug info output

 drivers/net/wireless/nxp/nxpwifi/debugfs.c | 31 +++++++++-------
 drivers/net/wireless/nxp/nxpwifi/main.c    |  5 ++-
 drivers/net/wireless/nxp/nxpwifi/util.c    | 43 +++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/util.h    |  1 +
 4 files changed, 48 insertions(+), 32 deletions(-)

-- 
2.34.1

