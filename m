Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513912BE80
	for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2024 18:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711046281; cv=none; b=jtxMK79K4KGjpjH337MTkILd5NvZf13Cm/JeDJaiQST7Eq4QVX87/nnMt/bajfynEV0uFaPdvOs9jWrixhTtfapm1cgR7MllGPyzPVwYBhaNNyScUrlkRN1DArlzQGvS53H+8BkGUyuuK9ErANXFfhtGhXBHTSxsTob2AfD/YOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711046281; c=relaxed/simple;
	bh=PmaLNnjt0ffkLNKIF/utEbZtmaKN13emtGRqxayKoD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=E4v7JiN+EBXLJLwKsGxK6KExouqB2jCfRq5XIcoz35ewDnUGKnv+9YRnXkgpQ6fHIkliVWp+55gDQyje4tajfBIhIIrIXbD8P/M+bHPbCrA7C19wslN50bszsPlZn5wGqYL8gxTQzNWu67yWFlSIXFX8lC+Q3MEj0H/3/vcDSSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b=wvVSH/q4; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="wvVSH/q4"
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1711046277; bh=PmaLNnjt0ffkLNKIF/utEbZtmaKN13emtGRqxayKoD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=wvVSH/q49hA1hFKQOuu2VnZ57+p5KFXM6LS/FQZ6CI49VDRytU7ND5wSMWUVyUP7Y
	 UWxO+Jd6tm8NjMCkov/WrlJGC9kBJBpDHG4J2KAPFnKKl2JF1EImRBdNkxWtLxpdUC
	 uBPN7oYWG0UGD0mbx9CC1ORRrSjZg68V9zetEpzzi5raD1CTl9j0mJ4dToZbkXXJYA
	 84GHdvc460WrWfHc+j1YU8tcdNQM2V5EptnmDJIWp/FEtLWw9d49s0k3E0gDpJ2VyH
	 jIoJkOHjN7GPEiMAD/OSPtpeZ7tbSmVu/kR/9UV/S0EqzovUqinNZiXAlRA+V4hPx4
	 4EzS6WEnDJH0Q==
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wifi: ath9k: eeprom: fix sparse endian warnings
In-Reply-To: <20240320170656.3534265-4-kvalo@kernel.org>
References: <20240320170656.3534265-1-kvalo@kernel.org>
 <20240320170656.3534265-4-kvalo@kernel.org>
Date: Thu, 21 Mar 2024 19:37:57 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zfurfn22.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Kalle Valo <kvalo@kernel.org> writes:

> From: Kalle Valo <quic_kvalo@quicinc.com>
>
> Sparse warns:
>
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:82:9: warning: cast to restr=
icted __le16
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:82:9: warning: cast from res=
tricted __le32
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:83:9: warning: cast to restr=
icted __le16
> drivers/net/wireless/ath/ath9k/eeprom_9287.c:83:9: warning: cast from res=
tricted __le32
> drivers/net/wireless/ath/ath9k/eeprom_def.c:138:9: warning: cast to restr=
icted __le16
> drivers/net/wireless/ath/ath9k/eeprom_def.c:138:9: warning: cast from res=
tricted __le32
> drivers/net/wireless/ath/ath9k/eeprom_def.c:139:9: warning: cast to restr=
icted __le16
> drivers/net/wireless/ath/ath9k/eeprom_def.c:139:9: warning: cast from res=
tricted __le32
> drivers/net/wireless/ath/ath9k/eeprom_def.c:140:9: warning: cast to restr=
icted __le16
> drivers/net/wireless/ath/ath9k/eeprom_def.c:140:9: warning: cast from res=
tricted __le32
> drivers/net/wireless/ath/ath9k/eeprom_4k.c:79:9: warning: cast to restric=
ted __le16
> drivers/net/wireless/ath/ath9k/eeprom_4k.c:79:9: warning: cast from restr=
icted __le32
>
> antCtrlChain is an array of __le32 so le32_to_cpu() needs to be used.
>
> Compile tested only.
>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
