Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D2B24501D
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 04:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013004; cv=none; b=a5HuZYwVLPPDNgEdYqp1CfWB8NTxCKH3W7cnfvwNUwlBYdNCwdOF6N/8bOf+XG3H6KBLnwh7G8rPKcYJa9rIbOZqEdOyN+OqVDd1IAuzZ0GBPDZgnrCjLBkn0Ad3aMmQ3FeU8gOMvqI8BL5Br6EYv+KVqTEcALQ8l9g6zwwaRRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013004; c=relaxed/simple;
	bh=lbvxtcykIJwtIogVynSJj3/4Jq4fRkJULtxZiJdq2dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HugL03XGsI+Yjx5W84BdI9S3/pJY6Rldcu6XPmChnL3vMsxeCmKOGFo1D7n1b8zjljll9Yxjl6nphrthclZ+yN13Guhi1j8KKrtglV3xAd61B/SexbL+Bz8QL81eWuno889ggKOgHwnIVe8mqkarfiEDqhiOijJBAIhRlmjawyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=foR4xy5E; arc=none smtp.client-ip=95.215.58.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="foR4xy5E"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lbvxtcykIJwtIogVynSJj3/4Jq4fRkJULtxZiJdq2dg=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789012998; v=1; x=1789617798;
 b=foR4xy5ElpcXCsSbvVtflR+B2kOAZ4kGzZhPdQcFD5BHrwiNQcEqOvHjiLm9684hqfnMyDMX
 dC7knNMpNAvySk4CQvLvgKWpIGIHwJWLLx8sOcOVOsuUfUsK/wOAavXCenrhGfD9GcOptwLUliv
 jyQuYOJsY9yb+qq/1M+IvGisO3r7o5yfgEEUjGTL3NF3ZqiGa7QqizHN3Ewwr3kLxb/YgaZWsYp
 MdCEPXafypKipgPcs/5mQjL2h2SfhAeWkKICt+zA0cThD9JEKMKPITks7KfnBWPlFfTww1M19jB
 poonIYfgVjHZLvokGOlI/wll/+wn7nFgMzBel7xUHam8w==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 30cfd1317c047806;
	Thu, 10 Sep 2026 04:03:18 +0000
X-Mizu-Trace-ID: 30cfd1317c047806
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Vladislav Rysin <vrysin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [BUG] mt7925e/MT7927: RX page_pool buffers stamped every 16 bytes, corrupting skb_shared_info->frag_list
Date: Wed,  9 Sep 2026 21:03:15 -0700
Message-ID: <20260910040315.27847-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906162742.15333-1-vrysin@gmail.com>
References: <20260906162742.15333-1-vrysin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vladislav,

Thank you for the two vmcores, and for pinning it to a single field.

Your arithmetic checks out against 7.2.3:

    buffer size       2048
    shinfo at         buf + 1728
    buffer at page    + 2048   ->  0xec0
    frag_list at      shinfo + 8
    rx ring           1536 entries, 24 KB, six pages

That last line is the scattered pages you found.

The shape you picked is the only candidate in the driver. Nothing else
is sixteen bytes with a word at offset twelve.

The constant is not worth more of your time. Those info fields only get
read by the 7915 and 7996 parts, and this driver never looks at that
word.

Devin
