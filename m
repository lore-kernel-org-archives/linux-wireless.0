Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F05442138;
	Fri, 11 Sep 2026 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124243; cv=none; b=tpOHZ7M2DhbnaUi002N07K6cwrPt2GieeeiURsldEuhVn+Bm2iciooKw3jjLbDLLbFkOyGXXNDEQFTOm/ZLRLkXpN7EjYwZSXplWBE7jv4Lw9Tryq9KfakI6n2R0J7yw/XGQ8amaan2m1cOHFkUugS6CGum2QJO6nnosYS3Yzy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124243; c=relaxed/simple;
	bh=vY0BYj3Cvq506tT/AUql0LzIdW426FPWMGNMAFl6ihI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ati9k5jvDO+9D+6FshkbMLUEUGNeao+WSfSSVJnrRdyYQVxdcvrTZQz+RJ78x0ipRNXvmm/fzkCYkiCtS/nifz/lwBtkZoV+ehKFXR6IKa3gQfo0FC/oZaYaiF72g+2OlCJBJ1RGYiYh5iEyUFZCmhTPNoiFr3q9nuJS5Pk90Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: free clone buffer on fi->bf
 overwrite in ath_tx_setup_buffer
In-Reply-To: <20260904212357.85611-1-rosenp@gmail.com>
References: <20260904212357.85611-1-rosenp@gmail.com>
Date: Fri, 11 Sep 2026 12:57:17 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mrtocaya.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> ath_clone_txbuf allocates an ath_buf for the last stale subframe of an
> A-MPDU and stores it in fi->bf. On retransmission, ath_tx_setup_buffer
> overwrites fi->bf with the newly allocated buffer without freeing the
> clone, leaking one ath_buf per aggregate retry that enters the clone
> path.

Huh? No, it doesn't - ath_tx_get_tid_subframe() has this:

		if (!fi->bf)
			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
		else
			bf->bf_state.stale = false;

-Toke
