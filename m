Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AAA51476A
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057489; cv=none; b=HAZCQl+RDU+X4QQuEawrAG8M7dKOyoxqn7KLgC6UAFExhrROfCKRABPhiO0RtKCo6kJOkbdxDvazyW0/Lh/PhKM4dqVVuOyNbYfYjJakkKfWuxzi3wJWqBrqrycuGQYczQUfK5OOlwNE9oHoRTU1U1o5pVQJbtYIDdVZYKD9LTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057489; c=relaxed/simple;
	bh=VFvZYJV1/OBFj7JugwEwg8zsXHZ1lbWbCBbHfX69Vlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt2vcFW5sClw5hvVSI++sr96bNRpCMQDmHus3d4GcsCg46kyOnAUoewWtc+UElWaBafTwbnhG8rbqwLKEa5XhSjsttSdUFBx5GejKKc4xSL4BMNo3dqD7PEh2afOdSzEaowNo9fbjzdGQMKTHhD68+R/tGhNWFWUppMN+vONRRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=EENOY38O; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="EENOY38O"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VFvZYJV1/OBFj7JugwEwg8zsXHZ1lbWbCBbHfX69Vlw=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789057480; v=1; x=1789662280;
 b=EENOY38O2m+LeQNnx6PV7pPB4Q4JEaQzzhr0i4z0l4aI91zXduEQAvk8iEzjSOqXgCG6MSAu
 L9vIaZJX/Kx5vHit0PSbQt04dTk97KQ/cNd1+HQqpUNHJr8Tke7n1Uq67hH5PEyYt3/JNquYLr8
 p2efMPPMKPNi8ka4j/0SDlTULIei1fie253frqKh1mTxG/9zhKMehWViP5LJPTIv7HAZYrnIhbf
 CwZKmCDx1RIFWlcbDAf513sqo/TVLy+u7LB80CunWq1yVNHVKtPwdaOpPpyYSMuCvpjgmwpylMr
 sCuaeW9yyf8O7L2Qpe+VfC6bmVarhjZyAVNbefiKWEa5g==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6aaf7fcbfeba6e11;
	Thu, 10 Sep 2026 16:24:30 +0000
X-Mizu-Trace-ID: 6aaf7fcbfeba6e11
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Vladislav Rysin <vrysin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [BUG] mt7925e/MT7927: RX page_pool buffers stamped every 16 bytes, corrupting skb_shared_info->frag_list
Date: Thu, 10 Sep 2026 09:24:27 -0700
Message-ID: <20260910162427.33627-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910134748.75684-1-vrysin@gmail.com>
References: <20260906162742.15333-1-vrysin@gmail.com> <20260910134748.75684-1-vrysin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vladislav,

My mistake on the vmcores. Sorry about that.

You are right about the ring. I had what I needed to see that myself and
had already noted the descriptors come from a coherent allocation. Your
first mail said the stamped pages were scattered. Those two do not sit
together and I never put them side by side.

I got the shape claim wrong too, and it is the one you could not check.
There is a second 16-byte structure, and a loop that writes only its word
at +12:

    dma.h:136      struct mt76_rro_rxdmad_c, four __le32
    dma.c:184-185  for (i = 0; i < q->ndesc; i++)
                           dmad[i].data3 = cpu_to_le32(data3);

Your stride and your offset exactly. Not your writer though: it puts
0xf0000000 there, and the queue flag it needs is set only by mt7996. So
the pattern is one the driver itself makes, which seems worth knowing
even though this instance is not it.

Your point about both buffers landing at 12 mod 16 explains the identical
registers better than anything I sent.

Same card here, still in a machine:

    aa:00.0  MT7927 [14c3:7927]  mt7925e

Send the dumps and the drgn script whenever suits, I have drgn 0.2.0 to
match yours.

Devin
