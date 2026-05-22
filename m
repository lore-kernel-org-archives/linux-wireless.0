Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E03DD875;
	Fri, 22 May 2026 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779449397; cv=none; b=LFmzrea6KFa+F2+2JgGo67/uAsp9S/Xcav0B+Hx5pPzLqKFMBFaSsNgQsKZAMOowsZvm7ThfsJ3tufNI3c7MDCsxqAp+nTG5z6d7PnqXW80juWbh/y1FDYB88y8/i9nZJXu536jj2ZzRi1dos4Rr1PWu/RPVPS8KuQdxACMdmPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779449397; c=relaxed/simple;
	bh=puURoolkY/9ruPO3t2AAd40jRgq3jIawFfjHsIrbt2w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Smty4uwy+2e3pCV7ZwDdzQsdmAkwD9QZ2bX8l0+/OcSsge+f76i1H1fCEeTWCkUvqnK12piXOgSNAny7p0VDhSCksJCpMA0rYpXf1LmTIYrRD9itQer6kLKKVnrsyamMQ0KVBXNFWJ6Ara81zWzXSPJEMmUfvyILQi99Z6KyCxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: improve stability on AR9330/AR9340
In-Reply-To: <20260521232445.261915-1-rosenp@gmail.com>
References: <20260521232445.261915-1-rosenp@gmail.com>
Date: Fri, 22 May 2026 13:29:44 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875x4fptqv.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> Setting a couple of registers on these platforms improves stability.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Could you please add information about how you tested this to the commit
message?

-Toke
