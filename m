Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086283859CD;
	Thu, 16 Apr 2026 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367324; cv=none; b=IJeHQaEMm9m5IpLivXrygyXrAFjgRQNRBdtaWqgkl5sYOS6xeAI8s+liK3Bg6MKru/XaUqfWMygasWcDJy5bjVJjaLDcvs0OHqsdrXar6Mnh2NU6Ene0k0O6BXL5YWTBoBcrlu19vMN68Wj/px3p4XDD3Zcg8pSYWFWI/aq+zgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367324; c=relaxed/simple;
	bh=RqjpDfzr6mWsC58JDYwLA0IHSoBSW3XysjQDAAjlM+Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qSdmeF4ZfZ/9ERl7hqvtPJs87pWFeWHA+ZUdBWH1ozN341UPJBdS6ssSx67egHp13R6P3m3y4l99r9MxY7p1IdUi+Cur4aUKOCWvDAMarZWcWadhUvStoU+6PbAze6WjT7kJoXlblfpvu5iL4tZ9jkN7w4gXJL/sljt4meXrKz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: use kmemdup and kcalloc
In-Reply-To: <20260223224445.27352-1-rosenp@gmail.com>
References: <20260223224445.27352-1-rosenp@gmail.com>
Date: Thu, 16 Apr 2026 21:21:54 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87cxzybtil.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> Simplifies the code slightly by removing temporary variables.
> multiplication overflow is also gained for free.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
