Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1432DB79F
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787372195; cv=none; b=osqHhHftHSyp2BD/t2QucA+pgvqZAarQLuL9vqhX2BiP5k2h5RKSqPiWmug9Sb1PgD8HkN+ijFZpfIAwZ2oEgnc1mjhD9yp6m0o0FpCJ9yMmDKGT1Z92LzA3ZkqfNGKSGD4FkBM/Jq9wyLukR+pThE0T66U/3tTXpD/Gdg/X7Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787372195; c=relaxed/simple;
	bh=hYHUvvosxIblggxt5IxGcMuRUG+plNbbzXWgQpj5Q1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahpSBTefqCmSsiXKdICKsdmVbUxIqaXlsfgDHXHB0yVyFuCX+h/lRMQjAG2s9M2Uc2ti3MEWxKDEvTMA7qS+InRCdy7IOt6sANXgXUcU3y8FF6Uk8XulkTHM/B2R8vy59Bpfx7HihMtEpFVfQwQK7lti30Svj+5+Nfq3INIduwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=go/dmsRQ; arc=none smtp.client-ip=91.218.175.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="go/dmsRQ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hYHUvvosxIblggxt5IxGcMuRUG+plNbbzXWgQpj5Q1s=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787372190; v=1; x=1787976990;
 b=go/dmsRQ7Mw+lVijlplkOo243DZPjS09QgkLe3JVmhC7vEN9sYcf8qf/i7v3xQiyhjVbuoWR
 1NF2e3/nKYd5xpwB3vSQ398MMtFCioH3L2YZIR85SZ0bLkC1fZE+hYJrxbhXh1VBWOh4kceUPRZ
 biVZje+vJmsHcRe5w5Q1/q1GgrB2VbV8qXQY3r0lVhI8qBW46Ppo3xYXelTBZZWgRaXYtAQW5yu
 FswkRUDBR02EqcqYo7vD4KUsPbPHP/4cCXow61Ke/FyKiGNhUwuyMdt8B3A99BXBgkR4Wp5+tTF
 n8ymq4de4C5BdC+ZwBIt6f1pnfcc+o33w42sfJBkM0JKg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 7aca6eeae61922e9;
	Sat, 22 Aug 2026 04:16:20 +0000
X-Mizu-Trace-ID: 7aca6eeae61922e9
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: moosager <moosager90@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Fri, 21 Aug 2026 21:16:17 -0700
Message-ID: <20260822041617.236931-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aocbq-_gRsXgFV94@fedora.fritz.box>
References: <aocbq-_gRsXgFV94@fedora.fritz.box>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks, tag will go on.

Interesting though, neither of your readings matches mine. Mine reads
the right value and takes a scratch write; both of yours refuse it. The
all-ones one is the card not answering at all by that point. The other
still has something on the end of it that just will not hand over. Two
different problems like you said, and your script is reproducing the
wrong one.

On the natural one, I would check whether the card is still on the bus
when it hangs. Anything from PCIe in dmesg, and whether lspci can still
see it.

Would not read too much into Windows, different driver, different reset
path.

Devin

On 20 Aug 2026, moosager wrote:

> So, when the issue happens on its own, your script (accessing register
> 0x54000120) outputs 0xffffffff, and even me attempting to write
> 0xa5a5a5a5 in a loop won't change anything.
>
> Instead, when the issue is triggered by my original script, your
> script
> outputs 0xffff0002; again, I cannot manage to manually write a
> different value to the register.
>
> We may be looking at two different issues after all, both mitigated by
> an error check that was missing anyway. I'm still inclined to say that
> it is not a hardware issue, since nothing similar happens on Windows.
>
> Tested-by: moosager <moosager90@gmail.com>
