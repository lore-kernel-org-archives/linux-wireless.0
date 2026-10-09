Received: from smtpdh17-1.aruba.it (smtpdh17-1.aruba.it [62.149.155.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14745C6ED
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560088; cv=none; b=XXedLYl28hsphEqMh6ymzjC4Miyb8TNCAspstqKsemLepQW391ZZnL5BF/3Kg3BD6szPIPIS1+v1Su5hpDthMXKHBrq6Q0EP4DVb8mBgPfWA7RNBNxsrKaEGBz6aHCMKnZsj8CExV6QwkZcVQNYj3Xbkb4n79qT5tKumDIPfZ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560088; c=relaxed/simple;
	bh=aAAzy8Xpfclxr8sbhy1tW1Gg28Lv/oUjU6H6kpBjtZk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=R4YatGAXHgx/nWFrrf15tzXIhQ3WcAauo0Lk32EF79e/mkdsrLr3GkoHQLk36wHmu+HVxeow2cFc6OxIDjcYVreyE9Hy9nozL9FBrGmq9Mn/UOtdPtN+n5hC0MiPuX2rD9YJK/bw/ItHrUSE7w28+RW74z35SuSbOah253c+QVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=mTxwehMz; arc=none smtp.client-ip=62.149.155.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="mTxwehMz"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id FCZJxb5c776R9FCZKxHpWK; Fri, 09 Oct 2026 17:31:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791559894; bh=aAAzy8Xpfclxr8sbhy1tW1Gg28Lv/oUjU6H6kpBjtZk=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=mTxwehMzOj+Ck8+BPeDPNACESeAEuzxq+hJUTk+/b4+z5npRP7dJmUGIQda0xVd94
	 2Tjh1s0yD812QPjjsKSsyGXrdNVcNycndd/huq1Dyjr7xzYLvvDrdDJr1FxVwyRfW+
	 mEuvpI4Hub9qMpqQiiLakLxHBol2G1KxUpJxyVWLQJdeWkJe5QJqTnmzYwEBcjLMOq
	 0EVNt40+QKuqppkZm7fv3alrpYWLscy4OnnnNYlTQiA29SDpc69aqXvZLHEVZiTr6U
	 x9YhNVJZB2Ln1sOZNoKEjPCJA/hUUoFEFX8CdKNfxzTmkw0PYUDhagO6LzZ3IPGVJ/
	 hJKeKn3ImZRUA==
Date: Fri, 9 Oct 2026 17:31:33 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: b43: ac rev1 captured packets with ampdu
Message-ID: <20261009173133.0e534ec2@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfPEcsmLD5XZdGsQIP8Hr8oY2Ggz1/0k/ocMpdkVu35TcNHDFFW1jYuIiUV5SWj3D9OdeVNjsFxP84iPQ3zjVqrlixSPYCo3jlzdywMQtmyhZ7+6VzSpg
 ZExBAsYSaFe04ppcwHLlnBGRZRqJyP/r2+SWDP2jK44dfYi8czpp8XMmblTSi66mTkyad7tNiMvS999wzTqORjQmJabGPckhJ3m5ftL38gksQhClWDgx/avE
 JOXKksPXDifH8Mks4TGdknkUJMWGN4HpWbDbO2R38pU=

Hi Andreas,
i captured some tx/rx packets in transit using ampdu with my vd625
(bcm4360 3x3), some packets with 2 HT streams and some with 1 HT stream
at various bandwith, all 5Ghz, if you want to look at them. They are in
my repo under router-data/vd625-agcombo/{rxtx-1s-h20-40-80,
rxtx-2s-ht20-40-80, rxtx-1s-ht-ampdu}.
I still figuring even-length ssid problems and testing ht modes.
Hope to finish soon to then tackle ampdu fully.

Have a nice day
Alessio
