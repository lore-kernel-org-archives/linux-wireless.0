Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2043D6476
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123981; cv=none; b=kMIICuFMwXXZiZ3GQJn5QIf+2t+A+5Kw661SP4rLYygSvTVB6PBngLGd1mbprSHd0GdKv+7X5DhSNkRA2iX+N3t8RfgLR1XPc+bO9FSTUm+aE3RVgQ4jGJeq3mEjKDAvDyDaDH2H5Jec+pVJpFkGgV7ZDDXoHZumqtghzDIDF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123981; c=relaxed/simple;
	bh=Cws+0NDICZPD15JlJ9X+GWp6y05FJnP2b8RQWOo7SSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cy7mzxcBUFKcRiIxXghAhaoppn7mX6wlwzVihcVFcbkTjX6oTEvlTdy4G17cCzeNKTSyEZ9MD8thxHqLFipPbGzbenNegYaam2dvSdfAzu4JNvBeRzwHR+W6HMsrQ1hFKr4WdRiuRP41d2xufsDFZgu+YtreAwnbW/pk76RgxKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QfnueIZF; arc=none smtp.client-ip=91.218.175.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QfnueIZF"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Cws+0NDICZPD15JlJ9X+GWp6y05FJnP2b8RQWOo7SSw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787123977; v=1; x=1787728777;
 b=QfnueIZFwVVRjoYvWZreB7lIjINwxxjeB6XxLXbxL8CoNTsc7crjsXv+jtb9/LdFlYOXxDFV
 lIMq2JZ2w6wIOM87FS9eg+5rBk6/MdeyDqTzmjOjIKyvlsQKKFaIc3UuHL12UDU0MmHX10UQBlP
 Y5cwvL+Np18FWtfRAtin9XA4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 4d382aa58da65fd2;
	Wed, 19 Aug 2026 07:19:37 +0000
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Wed, 19 Aug 2026 07:19:31 +0000
Message-ID: <20260819071932.19596-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <257b9af907e84e439ae6a9fd55bf3f09@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev> <20260814105327.6687-7-luka.gejak@linux.dev> <257b9af907e84e439ae6a9fd55bf3f09@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

Thanks for the acks, and for catching the wrapper.

> Actually, I didn't request this wrapper by v4. (Also I don't prefer a
> simple wrapper like this that hides kernel API).

You are right, and I misread your v4 comment. You asked me to move the
chunk into a function and I produced a one line wrapper around
queue_delayed_work() instead, which hides the API for no gain. It is
gone in v6.

> I'd move this chunk you are adding to a function.

Done. The conditions now live in rtw_sdio_8723bs_reschedule_tx(), which
decides whether the work should run again and says why, so the handler
loop is just:

	ret = rtw_sdio_process_tx_queue(rtwdev, queue);
	if (ret > 0)
		break;

	if (rtw_sdio_8723bs_reschedule_tx(rtwdev, work_data, queue, ret))
		return;

	if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
		break;

While rewriting that I found something I had got wrong in v4 and v5, and
it is worth pointing out because it was not limited to this chip. Both
versions had an unconditional

	if (ret < 0)
		break;

in that loop. Upstream requeues the frame on a failed transfer and lets
the loop retry, so that break quietly changed every other SDIO part to
give up after the first failure. That contradicted the scope claim in my
own cover letter. It is dropped in v6: the two errors this chip needs to
retry are handled in the helper before that point, and everything else
keeps the existing behaviour, so the other parts are untouched again.

Best regards,
Luka Gejak
