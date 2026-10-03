Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAFF377ECC
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791066904; cv=none; b=utMDwDoB6C6pMWkk2BQhkmbhbNyu/38T6MB5H3b8Qm7Wl3YnYVHgf0ZoTkJUq+nPHR7oxxmOpXP6K0RrvP1n7/0t+ULObbRguLHuiMAlzJa4QCHLnHFSrNqJTXjUuxuljXeI57F8d728AbwBYZvMGfWQBuIHHO/B24cN/OAwI0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791066904; c=relaxed/simple;
	bh=WBLKmUPF8EYw9bJVYI0MMpM0uADPMUH4CrimUsCKpyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UxB2PJhoJBXrqvLnTawSv/ITuU2q2k2yLKo2qf8y7mHFJuvy9+qkpVwXr8xTltvIR+5Bnv9B6UNzP/ey4ptfFmHhJN0YKkTk/lAR1hAX7YCl4RCeqvkwIBHcYRW6TAMm5XU8SQ/HlPfmrKukK9GaChhjEv9PiZtTXRz58X9P9m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=FnQC/j7N; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="FnQC/j7N"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WBLKmUPF8EYw9bJVYI0MMpM0uADPMUH4CrimUsCKpyU=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791066898; v=1; x=1791671698;
 b=FnQC/j7NbCZLMurqoch1vUp69e5aMWeMc7uDBCzxrcJ2zUn/De+6vW1bGxNRIAE7n4dtjpyP
 ChAZmtlkp6071joM9lAYUxkvnzZwoTjEBKG7O9JJoBIz3SGbQuF34VdKXrSNtcmhOUjV916p+DL
 doEjrt2oWmgipAu1gsWGE0y92VKPHr/Ivwky4TYgW3H2/5bXK9LB2gfmKW4/SMMVwUN4Pp5fODz
 IbfoXilkLRo+spXy7/Mh9N04fuU3PB3L0yXXDUZWow/GcgCWLDFBYeTQEa/jc5oYasVTlkvyVnP
 abqnMgAijMoCMHn3eCMtTtMpb3vqF2iiDAgI0po88CsuA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 365dd52d96661421;
	Sat, 03 Oct 2026 22:34:57 +0000
X-Mizu-Trace-ID: 365dd52d96661421
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Andrei Rusu de Castro <arc.au197@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: Re: wifi: mt76: mt7925: scheduled scan accepted but no NLO event
Date: Sat,  3 Oct 2026 15:34:55 -0700
Message-ID: <20261003223455.90881-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAE1+iCRfzzPpkjWKTtGe6Apeo-EBT-iZjwgwhB9jSVsz0fzokA@mail.gmail.com>
References: <CAE1+iCRfzzPpkjWKTtGe6Apeo-EBT-iZjwgwhB9jSVsz0fzokA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 2026-09-01 at 08:44 -0700, Andrei Rusu de Castro wrote:
> I did not retain the exact NL80211_CMD_START_SCHED_SCAN match-set
> attributes from the failing request, so the existing capture does not
> prove that this AP was in the firmware match set. I can reproduce with
> nl80211 tracing and a minimal single-match request if that is the
> useful next measurement.

Your scheduled scan works here on your own firmware, including after
losing an association the way yours did, so the capture you proposed is
the right next step. I would look at the request itself.

  matched to you   MT7925, in-tree driver, your June build 20260605184805,
                   a 7.1 kernel
  the sequence     associated, AP pulled away, ordinary scans finding
                   nothing, then the scheduled scan, as in your log
  the request      one match set, one frequency
  not matched      mine is USB and yours is PCIe, and there is no MT7925 on
                   PCIe here to try. My kernel is 7.1.0-rc4, not your 7.1.8,
                   and carries none of your local patches

  while the network was absent     nothing, as it should be
  after it came back               results in about a second

Repeated on two kernels and both firmwares. Same answer every time.

The request is the remaining difference. Mine was a single match built by
hand with iw; yours came from NetworkManager and wpa_supplicant, and you
wrote that your capture does not prove the access point was in the match
set the firmware was given. On this evidence that is the thing worth
catching.

One aside from the same path. With a match present the driver notifies
userspace six or seven times a second whatever interval is asked for,
because it passes every firmware event straight through.

Thank you for writing down what your capture did not prove. That is what
makes the match set a suspect instead of a guess.

Devin
