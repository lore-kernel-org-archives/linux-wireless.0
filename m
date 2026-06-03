Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB6824A05D;
	Wed,  3 Jun 2026 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780498285; cv=none; b=HLXgfaEcs7EDwix+34WwBNbwilUgXFfyUq3J/jZlraD+wy7ZaWi7hOPLLf6vhXdIpjZyA296yXIaOl2mS0dUbLuIg+4Bew8kXrPtEW2yU5fmOu0Vvmji5ctEQw9+FHBTUWNa/rmI9scy6ARorEeGgWSDjpYzAP80iJ/OkUG6uGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780498285; c=relaxed/simple;
	bh=xgf/uSJdMuvtHpdV+BBZPxUDDiDUOaDapAJlKtyFE+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agzsxLO+5566BWqHIaZ3jq8Xus374ZME2tKL+4wN6zLuxRcR3GfcNoIcmYKw1jtzm64vJkkS+1WNyB4F77+Q8Mtyk3+7ScMSl5EBFk/Y73BHmr39DDrchmQnv0Dmbzr86UHQSH5EcPf+XW79emVTBDnnTuQHJ/+9V9u2F9rnvsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSICvxH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSICvxH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77351F00893;
	Wed,  3 Jun 2026 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780498283;
	bh=6kW6ptgyg5H5Ykwdbp8DQZ2euT25CNIXLSKPhd7nzg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XSICvxH3AvCsXhr/oIpKcbA9WVCvTjdM2xMNi6kuE4XSIKILLjgJxn03F+c+KnjC8
	 zW1lv+i+veWu0Hgug8Sa7//B6wAUVKRoTuQ9mFVU7oakoWOqni79uRJHYDe4Z5abcv
	 H3lcm3LKnHW56YdyA37zMDBJQTV3PY6+7rTrov5eN4X56dPcI9BoI/7Y7lhRkfO4n+
	 K6OfPoqo0Lo+Dvs9FZvQxRUdVj67cDyGUJ0XfI1zGPc6oBDQm3Z+g7hZpGL3m17/VC
	 yTBPuqe480+6J8vEEVm4NIk6Dbb3cOD5Ua5brzLIbJRluMPd/MwAKCm21YY7fp6ooT
	 6vTPH35peH0Nw==
Received: from johan by xi.lan with local (Exim 4.99.3)
	(envelope-from <johan@kernel.org>)
	id 1wUmwD-0000000AYYj-2wiC;
	Wed, 03 Jun 2026 16:51:21 +0200
Date: Wed, 3 Jun 2026 16:51:21 +0200
From: Johan Hovold <johan@kernel.org>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 0/5] wifi: mediatek: drop redundant USB device
 references
Message-ID: <aiA_aYcTPizOPhtT@hovoldconsulting.com>
References: <20260430083335.215239-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430083335.215239-1-johan@kernel.org>

On Thu, Apr 30, 2026 at 10:33:30AM +0200, Johan Hovold wrote:
> [ This is a resend (with trimmed CC) of the five Mediatek patches which
>   still haven't been picked up from [1]. ]
> 
> Driver core holds a reference to the USB interface and its parent USB
> device while the interface is bound to a driver and there is no need to
> take additional references unless the structures are needed after
> disconnect.
> 
> Drop redundant device references to reduce cargo culting, make it easier
> to spot drivers where an extra reference is needed, and reduce the risk
> of memory leaks when drivers fail to release them.

> [1] https://lore.kernel.org/all/20260306085144.12064-1-johan@kernel.org/
> 
> 
> Johan Hovold (5):
>   wifi: mt76: drop redundant device reference
>   wifi: mt76x0u: drop redundant device reference
>   wifi: mt76x2u: drop redundant device reference
>   wifi: mt76: mt792xu: drop redundant device reference
>   wifi: mt7601u: drop redundant device reference

It's now been three months since these were first posted.

Can someone please pick them up?

Johan
