Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09257246766;
	Fri, 27 Feb 2026 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772189400; cv=none; b=T7WdEOUO27M7WTQhnaQxWlvr9+bVejZJxs0SHtjR2nEW3OFJK1z17CNnfdovl43QVNLA+hM/twcqVQriSMfKcUXdMmdeDbhNi3m26N3LCTcIIA0rcL3elvn1S+chesE5qdA2BO/AreHodyxo/5e9wzbytPVaI/7zR4KZA4AKw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772189400; c=relaxed/simple;
	bh=UsxUuuLQrAAcjsMa8muaF1eF1Co1Z4nZbKN7JE/Zafs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=px0ayut3AH2zvE/HLIRvuY9x1UBxmn8Kz6qsxPEJp5Wua67WfG7iU9c+VzjgZvvIrwqZ8M2zxvtcIEFTSnoPolwx09Dh3LFM2B0C72N0eqUqMIDPgoaP1kJnjkIANS80RVEiquLsArEtBAzbB+1Xn6MfLj/IkXPByBxAJQEpvVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0pWASns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0pWASns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8DBC116C6;
	Fri, 27 Feb 2026 10:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772189399;
	bh=UsxUuuLQrAAcjsMa8muaF1eF1Co1Z4nZbKN7JE/Zafs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V0pWASnsxcrjyMo82n0h/bjBPpNEvwA+nYb29qVxOYDAgqsbaNGwFSJ5sHCl6gS9t
	 0z7NXHh3uTVZFkROWp3ygvmMwdSszs9zaYLpm5Ir8ySQtJQMeTlK+b3ADnLdsN44W8
	 mMW+kVjpp/2weRWdYnDxy810v/1r1MitmclrZvJRNTc+P8Sefz3x4pjsanfc82utPj
	 vX/St0sk4bdTNHMt7JRKglezKBfq+zSGKuWRwbSpaGfqsQ/OB2gGs5wfchC3UeKHEf
	 pk5b5rGJM9qvaGzIcxvHdgHIr5KmmwC0iZlMGzVjxuPQeHTzapId0r7CcOGhSt9pfA
	 PoSNJN1HSEyTw==
Date: Fri, 27 Feb 2026 11:49:57 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: johannes@sipsolutions.net, Ulf Hansson <ulf.hansson@linaro.org>, 
	arien.judge@morsemicro.com, dan.callaghan@morsemicro.com, ayman.grais@morsemicro.com, 
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 33/35] mmc: sdio: add Morse Micro vendor ids
Message-ID: <20260227-boisterous-bobcat-of-pride-ae0af2@quoll>
References: <20260227041108.66508-1-lachlan.hodges@morsemicro.com>
 <20260227041108.66508-34-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260227041108.66508-34-lachlan.hodges@morsemicro.com>

On Fri, Feb 27, 2026 at 03:10:43PM +1100, Lachlan Hodges wrote:
> Add the Morse Micro mm81x series vendor ids.

Without any user this is pointless commit. Organize your work in logical
chunks. Define alone is completely pointless and redundant. After
applying this patch we should immediately revert it, because you added
defines which are unused, so just bloat.

Best regards,
Krzysztof

