Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C5330F816;
	Fri,  6 Mar 2026 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772785265; cv=none; b=MctpYth+FEMJ1PvltV/nWFLDHcAH3hQcDpWNFAJ+8V0lmJG0iogpYX4N1YRIy81xN2Pqk9OvF2zRKd2eIwH0F3diH++nZYSzlN1BoT1MppGVeNLREnGpdSgDzA+tVup0xROLyRhNCnOIxCoOKckofL5aaJHGQvEn6urJu/Cn1Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772785265; c=relaxed/simple;
	bh=0qM+3WQFyUmhLvLUhbsQ+RqQ/O15DzfcFnsVHQoKCFU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BBVaOiae2Z5/KFpHEHFCdqK3ygjpK4NhZlc5s+AfGDwON2haJn33PrNPdylJDvLjBI2iWe6Ck7PWFJvpDp2+ex+pnjcOHMNBmkHgRD36eaErglsMI+nvechvskoGgDS0dXb1McPtBSMAx0F6CebfeD5FHLSP8GlMDq6YdxX7Png=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tcL5tUsG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tcL5tUsG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0qM+3WQFyUmhLvLUhbsQ+RqQ/O15DzfcFnsVHQoKCFU=;
	t=1772785263; x=1773994863; b=tcL5tUsGUdLO2roEm4clWpE+YhzPAEigbUSEsHAFT96paE4
	dcYdBWzxft42fsFAfvaTQtJQLuS7ID3wWPk+/V6Uv8uDTqny+Jsw7Bzetojw+lwB1P1bRMy6IngGH
	ogAo8gCAy+gBMkbEjsbtUy1g+KsDh1gnHwGUBNQLU88xxxIl1sbbejdb36MT9bfbbL+tXrF0/vlPC
	thb1MqztG74VKLVXUjshZ/j6QgWqJvRh7SOwU/tFJMJp3FbKBa7NTyLOm92qw3fa913znW8Q/L5Vs
	SgVWEvGB6X2TTQxeA3vA7VHb+siSBlew6JR8Wcrew4KA9hAjIvSyICH7bQ6II6aA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vyQQZ-00000009yel-3dnS;
	Fri, 06 Mar 2026 09:20:56 +0100
Message-ID: <b71d0932b10b5c446681cef588cfcf6f869f3fca.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 23/35] wifi: mm81x: add sdio.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>, Krzysztof Kozlowski
	 <krzk@kernel.org>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, Arien Judge
	 <arien.judge@morsemicro.com>, ayman.grais@morsemicro.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Ulf Hansson
	 <ulf.hansson@linaro.org>
Date: Fri, 06 Mar 2026 09:20:53 +0100
In-Reply-To: <sze5g6binniqbqzwvn4nx5qbytsxu3f2rne7wqtdsmlgzqcq6c@4rwtkq7nyptu> (sfid-20260302_073104_005505_754782C2)
References: <20260227041108.66508-1-lachlan.hodges@morsemicro.com>
	 <20260227041108.66508-24-lachlan.hodges@morsemicro.com>
	 <20260227-spotted-rugged-moth-3fdcbe@quoll>
	 <sze5g6binniqbqzwvn4nx5qbytsxu3f2rne7wqtdsmlgzqcq6c@4rwtkq7nyptu>
	 (sfid-20260302_073104_005505_754782C2)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-03-02 at 17:30 +1100, Lachlan Hodges wrote:
> >=20
> Ultimately the structure of our commits is up to Johannes since we are
> going through the wireless tree, but since we have patches that
> touch different subsytems that also needs to be considered. Open to
> suggestions :).

I think what I would like you to do once all the reviews settle down is
send a pull request which contains just a single commit with all the Co-
developed-by: etc. (similar to ath12k). Of course separate from commits
that touch things outside the driver itself (I think that's the SDIO IDs
and DT bindings), so we'd have a couple of patches:

 - SDIO IDs (now patch 33)
 - DT bindings (patches 31 and 32)
 - one big commit adding the driver (all the rest)

Mostly just so I'm not making up a set of fake commit from all the
patches on the list.

I'll take a quick look now, but I'm still holding out hope someone else
might too, and either way even for 7.1 we have a couple of weeks.

johannes
