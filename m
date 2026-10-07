Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08082481AAD;
	Wed,  7 Oct 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365849; cv=none; b=Pq40tlNTsKwCLEHE9DZZ7edlb11cDqmaVciU55E6on2hYJWXb8b3H3Ew555BnWdk3DF7VVGHTN5yhxvvX8SqlSlw2egG5XN7sB4JCa/Ofw++zJBvppv8E12cZznuzHkEw//cVmLJ0OzAqFsyPbBvmFnDGU+UiGxFVemNdKfFlRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365849; c=relaxed/simple;
	bh=f2JXT+MHfpwNcVy+Cu2UmZ2nFKZ5RPQubv1NHR7hOm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5/h5KtnP8j0wLtJKGR/E9xN7GNSTbs5a06giM3sc/3HmOBHlLAisBkV/Ft43keKFa8YUF1xRV8RlcPvyMGI0ySS7+RJbzCKRow5vyIFabFp0nmFEn6V5z5LZZ6hKGgDxg96AZWVeHt3zyL1Hr4awxUqvUKqHWM9hnffO3oriyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b=b6mWtmZx; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b="b6mWtmZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791365833; x=1791970633; i=f3lix.dev@gmx.de;
	bh=f2JXT+MHfpwNcVy+Cu2UmZ2nFKZ5RPQubv1NHR7hOm8=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=b6mWtmZxoqPlV5xEQeBu92q8W1bJiZ8v4u9ZgW5BT0x8pxLNVlhBUOOy4j5EpPc1
	 x+7nZWKNEJOEVdy1FAKQ2rmv6mHU8gBmiQBs3bR3hFsIcX621/sv5sVvF2NLU1m00
	 A05/tb2kRFgfo6DSjdnNONTivcCWGlJzZSyQN1yJfDmEJLb2hLTSfKoMZD9lSwv3E
	 1YDbBHB9Rpqvq6l14evsjfSTf69lEqB84l1dfNyZ8A5CoGxW42DlNnjMHeJJVbILm
	 dNhEY8p3/1uFbV8mLTHUMT6U/Z86DX6syrSNT8A6JGBZyYpTpDkrv+AQ9ChMhWSMH
	 fKb3zQauhiDlJzTZpw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvmO-1wdg9m3gCE-00l1bd; Wed, 07
 Oct 2026 11:37:12 +0200
From: Felix Hoffmann <f3lix.dev@gmx.de>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mm81x: validate YAPS receive framing
Date: Wed,  7 Oct 2026 11:30:13 +0200
Message-ID: <20261007093013.17116-1-f3lix.dev@gmx.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <lrsghye5vfzs5o4pljrbm2ubfcxgc3mkcpyc2sbutsq6td6qug@36liwxdx6j5i>
References: <20260910201030.85862-1-f3lix.dev@gmx.de> <lrsghye5vfzs5o4pljrbm2ubfcxgc3mkcpyc2sbutsq6td6qug@36liwxdx6j5i>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:V2GzszlTBFIthwqGnuYWkV26gv8Typg2SY5M4Pv9VtOuWphPP9o
 L8L31mkdPeV9Zyx9IDC4W/XKWI0rSEd/k7zmAYpLd8hp5eu4wgF6rODEKBrXyXvGfJVTHIv
 Jfl9Iox/LRfKMZfEhOorGtX3OYzb6DfPPBWSL02onFcNBcbNpev59sCbJrVUXXD5F8XDi/Z
 fHmZcJPIGoh31kzte7N1A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MQ2NG/dkevI=;rtGULF8M/rhczC0PyekY9oILiV2
 +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

Hi Lachlan,

Thank you for the review.

Yes, YAPS_DELIM_GET_PKT_SIZE() makes the intent clearer. I have changed v2
to use it through the signed pkt_size local, so encoded sizes below the
reserved page remain negative and are rejected. The upper-bound check adds
YAPS_RESERVED_PAGE_SIZE back to preserve its existing encoded-size semantics.

I will send v2 as a separate thread.

Thanks,
Felix
