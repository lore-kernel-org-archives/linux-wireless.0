Received: from out-178.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960D431A50
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055401; cv=none; b=ZtKXBXcq2AmN+p97n7eokyDPh3kbfYYZ0cSw74nDHha8Rx9J28Zz//qOYiz2D6NvY13lcoHm/Y2GOV5HwGL+YPqUNx24PIhzyZ3uSaT0Nl7+NAguMi0vofqb6Hjvd9bQ9jkrTOJfJHE6H/NG8Ev+jbmjyTDFSpc2IwysCbroCxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055401; c=relaxed/simple;
	bh=+Em8aOJxMnQY7SunwD6mWEnnsR83v0NBgGih8rJg6PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM78yzrAt/QyDa1gDCkLomiNXVRdWOQcbRr4nUaMMxvmRHEtchsgQw8QT5iZlg167w9MQiMzeQP2hK+oPJEaV1XWAObpEtJEAW4tfvNI9olSDRm7vaNQ3au/mAUnzpoIueR1GvQ33kCZSLRWqilrISHky6fjyUeFyXIAmqLZDDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=QqB9lMlP; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="QqB9lMlP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786055385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aNV4uXbDodbnruGyVrOp44eaeJJKSwZaU6AGbof4wsU=;
	b=QqB9lMlPa1c1nl3NBIENn5wAVdr6S9U40sA8wMtH77kTxy1zvQv4QyOVwVe5ixmb9iNvs9
	j6uOtu0UstMJ5ZTK/EUdNZe5x1wxCzwAIG7fxalHEYe0H7g4Lz2gCdkGikE91uXRZNE8PG
	/GanVfi0H75NqcAjiT7amZUU0B7uCFIHNVGD4sXtwGO3P/zl+pf4Xid7ecuVW4BcwZ5KLt
	26h2CpmpQoPIfJBnGH21zh4HW5DcK0O2hevKLhnVNMDavuPIA1ErS84LP1tdymBAe/bpKx
	u20EJ3urRn8JxcD+NURI1zXZyMpqDxQ64YIXid41+COH3Q1I22MeDUX+1AACKg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Kun Wu <kun.wu@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Litien Chang <litien.chang@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>
Subject: Re: [PATCH v1] wifi: mt76: mt792x: fix memory leak in USB TX path
Date: Thu,  6 Aug 2026 15:29:22 -0700
Message-ID: <20260806222922.30384-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260805073812.1433126-1-eason.lai@mediatek.com>
References: <20260805073812.1433126-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

> 	err = mt76u_tx_setup_buffers(dev, tx_info.skb, q->entry[idx].urb);
> 	if (err < 0)
> -		return err;
> +		goto err_free_skb;

The first hunk looks right, that is what mt76s_tx_queue_skb already does.

The second one I think is a problem. By then tx_prepare_skb has succeeded, so
the skb can already be in wcid->pktid, and nothing takes it out before the
free. mt76_tx_status_skb_get walks that idr on every tx status event and reads
the cb off each entry, so this looks like it turns the leak into a
use-after-free. mt7925 asks for tx status every quarter second per station, so
there is usually an entry there.

mt76_tx_complete_skb would cover it instead. It marks the skb DMA_DONE and
leaves it in the idr for the existing timeout to reap.
