Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.140
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863261;
	b=nEXt//ek9gq3F5P8150RbBVLrykYiAEhb6Tc6udL6zt1plxCwgVWmuMs+lUDK1BtdfQf
	 k4bWZzkCVlEe2DYvKN/NjvdqEpTdgpxZ87aqqpEG2Z4WGzDK8RznF5bmw8W5Eb8XmC0hn
	 xh3anJKKGAiCBlyoYq+LjV5zqCU6Gsp0zLGxX2LHtWQWSSWwbYH1zK/wMyUaLTQCEgVkJ
	 s1zbERProl/MaxH7fUMVqxc5sX+0braWNCbZMRxCFthTlyU3lorMg8KxqIFPRC9IWS/fh
	 04iHIJovwALSpfKxjrJbgzXqE294QWlCrhuWo1EINjgtxsE+oym1rwsqFIbxKqcfWTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863261;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:Content-Type:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XG6cnRAbbHNvFhEVqHFZ79h+iqHopMF6Uylvq+7tYkA=;
	b=fd1UQ4IEpiA2++kRFjBk10J5tgmv34qSQPCNn035oZa3giAMqttSpTmHESMV6qgDycbo
	 b9tQJPGrXduasTMLZGK8jvmmcUpSsWfPaLnIdefQXMsYWtbM3el6BiGAO0Ykne5AVpEME
	 exo4M7rd+MEXIlab5Ds/YNc2GIVjl9fF+flddYWYXTDtQWkiYZuZM49PrE/kzRklfdSQM
	 XjvTwz9pHFOuyvZ8PjrQf33VKI1o4oF9o2vcD29OFFzylO7GR0oxR0M0BoQygkdbaSjIo
	 rVWjP/06x2KuTKRukh6kKlrYiutSIes9S1AkgRNT3UjLeEr5xvLmlHm2/kxb5Llcu7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=MhhjmJFK;
	arc=none smtp.remote-ip=91.218.175.140
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F32606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 17:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F32606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=MhhjmJFK
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IOdnh/iOpzPwwmVekHNpQuVJzZXM5PNT/QMupjWWisY=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792863257; v=1; x=1793468057;
 b=MhhjmJFKIuoLLaETQEoU/49g4bght+FitduSMCfamFv5OpM5DLHq7oSmXucvtPsD4u1LUg1l
 uIfZ6CQuoMmLLpjNTwe3KIhKkJBPSl1bvkPvIsPLutiEojV5SEel2nP0REvAH0VIBFBgLzSl30N
 5A//vwCCH/IRrGIDPrOQwiX1H2c0GOtsCkzwJxHRrWio5Fp1fgUS+6s4nInEMJHoTpyQU7mNEra
 YpY5tCBTK5ReOvjMWqhgjJ72PXn6LGfyC6RPr4Sbur5Ud82fluKHH2HkhSjBH/w0IQ4rSldHKNc
 uJVAtcaQPuUSb33GcXkXq+yKtViInxuKz3BzTzjrAAAMA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6ffce3468e7d6d81;
	Sat, 24 Oct 2026 17:34:17 +0000
X-Mizu-Trace-ID: 6ffce3468e7d6d81
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Chris <hoopyfrood42@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH wireless] wifi: mt76: mt7925: get the survey airtime from the firmware
Date: Sat, 24 Oct 2026 10:34:14 -0700
Message-ID: <20261024173414.10559-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAHaeJsSfoTxJhWVCrELCiLZr1zD42LGJUvrmf7oSzRQpwh6-jw@mail.gmail.com>
References: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com> <20261023180554.7266-1-lucid_duck@justthetip.ca> <CAHaeJsSfoTxJhWVCrELCiLZr1zD42LGJUvrmf7oSzRQpwh6-jw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
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

Chris wrote:
> One thing on offset 20: in monitor mode it doesn't look like all of
> rx.

You're right, it isn't all of rx. Your numbers made me curious, so I
tried it here with an A9000 as a 20 MHz monitor next to an Alfa. It
seems to come down to how strong the signal is. Share of the time:

                                         offset 20   decoded frames
  one strong neighbour (-22 dBm)            2.3%          2.0%
  only weak neighbours (-73 dBm or less)    0.0%          3.6%
  my upload, monitor on a side channel     54.6%          7.5%

Strong signals land in 20 even when the monitor can't decode them,
including spill from the next channel, and weak ones are left out.
That would fit what you saw on 5 GHz and on channels 2 to 4.

As a station the A9000's own downlink does show up in 20, so I'd keep
it as the receive time.

Thanks for the long run against the Wi-Spy, and for the Tested-by.

Devin
