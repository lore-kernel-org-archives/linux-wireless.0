Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA64524AF1;
	Wed,  9 Sep 2026 11:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951788; cv=none; b=pGQ0dUqHUAyvhTwdeX2P5x5w8S2YmgR8cKklx3oEHV44Zdp+tR3Dz5s9yfxZaXe9wYkiApP62d9wMr9IBaIQ43tFqSW/8l5Vb9AwFeU5xua7SlBrj0s8tKExWUQ5jH7IIbaHOAw51hCjZ5I6qBqbVumnlgmIMebrt1BOKZLfWUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951788; c=relaxed/simple;
	bh=xPtNjebmWao5CLbrpGRMOZzFmvsyGBIy1SYRm8Gl0kQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eNvho2JzDCbmqQ5qc7lrOOceblPaa0ZPOjkrNalB3gHuWNMn2dVoaPAJcuQNKmQkm0McjGppsZ9gUSIihvVzaE3XyqzYGXAm8TD5iNjRbqTV2HWDvLeU61HotmBl7xVKV2Hx8QFZisF0QPN3bHBLSDQsb46CycJx/Zj+8wQI/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Nerijus =?utf-8?B?QmVuZMW+acWrbmFz?= <nerijus.bendziunas@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: refuse spectral scan control while the
 hardware is disabled
In-Reply-To: <20260908180308.788642-1-nerijus.bendziunas@gmail.com>
References: <20260908180308.788642-1-nerijus.bendziunas@gmail.com>
Date: Wed, 09 Sep 2026 13:02:56 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878q5ag00v.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com> writes:

> The spectral_scan_ctl debugfs file drives PHY register writes, and
> nothing checks whether the hardware is up. While the interface is down
> the chip is asleep, and on the AR9271 those writes go over WMI to a
> sleeping target and hang the firmware until the device is re-enumerated.
>
> Refuse the write with -EBUSY while ATH_OP_INVALID is set. The reset
> control already refuses on the same flag.
>
> Assisted-by: LLM
> Signed-off-by: Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
