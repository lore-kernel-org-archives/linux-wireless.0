Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FEA4503E0;
	Fri,  4 Sep 2026 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517686; cv=none; b=oASDIGyJEsxcd4pO2FSLodjHNd1uJP6tn2qCjQY/WwjrbP41LpIodFw4VpmuJ3aqGM7JAF2ZWjHK+TSRlKo2qEtYKnI1OLI16PA56M9nVPxBF/Sv71HjM0hYxB2uQgiOH2O0bVQrUTo5e8f3gtmZ00sV0taW87AVpUTTzZfcRUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517686; c=relaxed/simple;
	bh=ojquED1tm5UGips0a2zqyjrFk8HTyBfzfPTN08UwYbg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Mp6ocDFIecV1fxt8wXOPBHcUvm9Wkdc81jOsrXPoTx2h6zke8lU2mRnfLMe1gttvhxvFzweZ4k3OUjSnTg6W1Lr+kKMLBmNmHS2UseRgkpL1nmLH4QDbGDkdUYoLnkk1L41dCgk/jJ650arMzzmd0SnEbOxKiXKzQgoUZirnqgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Pengpeng
 Hou <pengpeng@iscas.ac.cn>
Subject: Re: [PATCH] wifi: ath9k: validate WMI response length before copying
In-Reply-To: <20260704011405.55089-1-pengpeng@iscas.ac.cn>
References: <20260704011405.55089-1-pengpeng@iscas.ac.cn>
Date: Fri, 04 Sep 2026 12:21:16 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wlt1tizn.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pengpeng Hou <pengpeng@iscas.ac.cn> writes:

> ath9k_wmi_rsp_callback() removes the WMI command header from the skb
> and then copies wmi->cmd_rsp_len bytes into the waiting response
> buffer.  The response length is expected by the waiting command path,
> while the skb length comes from the device response.  A short response
> can therefore be read past the end of the skb data.
>
> Record malformed short responses in the WMI state and return the error
> to the waiting command path after completion.  This avoids both the
> out-of-bounds read and the false-success case where callers would
> consume stale response data.
>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
