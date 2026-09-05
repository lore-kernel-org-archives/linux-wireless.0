Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBD222597
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 06:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590266; cv=none; b=R76iWPhxXMIZMj3GcGtB+MR+oSa6eWt4tETbpBjsWkCIKlrXJfu3b9MERO2Bv0VbN8IwXTOy2oqPmi62DlTPZj8GrQrD1hhFHQ8zpyuxrIasb7q6zTz7tJGo2BBkohDpzQTTQ7nz34/sIS7x9nMR97S+IraTl7u3RMNMrHujeWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590266; c=relaxed/simple;
	bh=cmF1m54I1KPcW/jkQRB1cp8VQdUqqng6NmllgisHAbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpcFNsWNUJlE2/fvWHdYNa4SDi2Tvv0dcFgSZzctCm4ewMROPyEGVOXh1btpcm63Ek/N1Qy8m/lgAjuhC6dtTr2oE8BitlkmROKAPNV63FZ2UCxkI0TjJZdHFcWz/PcgbkR4OoBqEpo6/8HYrjVl4LcDR+hFx0JprEbnUBEK3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=Y9AFtuxv; arc=none smtp.client-ip=95.215.58.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="Y9AFtuxv"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cmF1m54I1KPcW/jkQRB1cp8VQdUqqng6NmllgisHAbI=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788590261; v=1; x=1789195061;
 b=Y9AFtuxv5gzYUbv+JZSp8nu6PRWhSgY9ItpG83p78tk91PLZu/nFZzosghI38EdYJHoaCJvH
 1O2/4Xwju5rESfQ5cn2h0y/mGKYBx1+2Ef7sK1BePRFe7AEWEv7B/9+UoxXcdP7hIqopPHsYtAf
 uT1o2vHK+C9NLlbJMaHBjxKRGu803zM6rr1cnGDohghe0xsac6bdCHADr0rEcAEBgEksK+R8YDh
 /iSQbQqa6laC+Op/ee6t+jUH4dpuodsYut69wM+8IjWxBdFBgnRHQqFSCZT35dPT/J1bOFQrzw3
 SQJ/NNCXnUpjWn0tnGgGEnPsZHNJN1n03esUUFEzbZNRw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9c3f7cb43324628e;
	Sat, 05 Sep 2026 06:37:31 +0000
X-Mizu-Trace-ID: 9c3f7cb43324628e
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Pablo Diaz <pablo.diazv@pucp.edu.pe>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: Re: [BUG] mt7921e/MT7902: firmware programs near-zero Tx power for all 20/40 MHz rates -> assoc fails except at close range
Date: Fri,  4 Sep 2026 23:37:28 -0700
Message-ID: <20260905063728.31929-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CA+Hv-VqrxKWETcegx09-=v7udVO0Rk1CY9nPjw8sDK3mzgw-JQ@mail.gmail.com>
References: <CA+Hv-VqrxKWETcegx09-=v7udVO0Rk1CY9nPjw8sDK3mzgw-JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 4 Sep 2026 13:58:14 -0500, Pablo Diaz wrote:
> I will build your patch with a print_hex_dump added to mt792x_acpi_read()

Much obliged on the assistance, please build v2. The first one rejected those
tables and this version reads them:

  https://lore.kernel.org/linux-wireless/20260905013551.24635-1-lucid_duck@justthetip.ca/

PE also puts you on the FCC row of the geo table. This adapter will not
select that row.

The kprobe result points away from a shifted parse. A byte-shifted read lands
on assorted values, not the same one everywhere. If every range comes back -1,
the bytes behind them are all 0xFF. That is the template you describe, before
anything fills it.

Filled, v2 parses those tables. Unfilled, v2 rejects them and no limit
reaches the firmware. Your hex dump settles which in one boot.

Devin
