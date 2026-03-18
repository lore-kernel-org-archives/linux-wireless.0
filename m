Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC4317C220;
	Wed, 18 Mar 2026 07:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820383; cv=none; b=NxeXJzxM7cqlLLMVtqD1NXgDSxEtU/77GNws6phuXbgeisq1wKbU0EMG2Gb6VZz6qTfadbeQiMmQT8qJIETjXDVFI3zBJOsdaz/eYKZhHMPwNv7DWYO0Uds47cfyo4wM0iQGD3OxqxUxCWYCUNlxBmlH3lGhSpaEQfyQ3J947kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820383; c=relaxed/simple;
	bh=iUmyObubGDhCCaY8aMDS2fWr3diRcYq2mTdl5vsLjME=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qu2660qXsYSKwIoHhXS+jDkp2KszBI3d/IbReVZfkubc/aF03RaxBHKltjUzgOeZB6gHYAWbFxqMKHz1OO1wp5DupKznT2n2sNifM/RqQpSRNo2oDdR08KgsZpjzEKLOoI0wAbcDqtTru87syVNN1YAW9FSvgOFbgOfg2u2bbck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XqN/kPcG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XqN/kPcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iUmyObubGDhCCaY8aMDS2fWr3diRcYq2mTdl5vsLjME=;
	t=1773820382; x=1775029982; b=XqN/kPcGFAA1+oCCnv5U5t49lQx74mcURQzpTRfDI8eIekK
	4DHI/RhyO1HhFfszIQkBIe/CNK8wqbNC9YW5dhoA5IcYwTSFLs4bzc2SKM9k6ZRfwVeq4vRgwWfSe
	vVqt7K7ZcfYKpzQMjuJRLdbyYXcR70A99JqvgaXsDz9zq9ANPdTETIaiMHnviOWqFcHiorbrBtyjd
	zB71zjm7Jsjr8K9egzeN4h6/JS3RtzX3tWhzHtPhelLnV0OiRCw0FAw+WUGyA7V5wjuHh3wBK1BhR
	zabgaQdCjfgCl1dg35u4i6rxfNGmCg8sdltkLkJbSTKdi225CQ1tVdEeq6fRDW9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w2li6-00000004G34-34NH;
	Wed, 18 Mar 2026 08:52:58 +0100
Message-ID: <6eb04d4729c562ffebd29e34c83be63996c886ea.camel@sipsolutions.net>
Subject: Re: [PATCH v4] wifi: iwlwifi: pcie: optimize MSI-X interrupt
 affinity
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Adri=E1n_Garc=EDa?= Casado
 <adriangarciacasado42@gmail.com>,  Miri Korenblit
 <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Miguel
 Ojeda	 <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Mar 2026 08:52:57 +0100
In-Reply-To: <20260317193252.13763-1-adriangarciacasado42@gmail.com>
References: <20260317193252.13763-1-adriangarciacasado42@gmail.com>
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

On Tue, 2026-03-17 at 20:32 +0100, Adri=C3=A1n Garc=C3=ADa Casado wrote:
> Balanced distribution: skip CPU0 for high-rate RSS queues to avoid conten=
tion with system housekeeping. Use a stateful last_cpu approach to ensure u=
nique core assignment when skipping CPU0. This avoids mapping multiple queu=
es to the same core.

You need to break lines ...

I tend to think you need a better reason to skip CPU0. Last time you
pretended it was actually going to be faster, now you pretend there's
contention, without ever really getting to any proof of that?


Also please read what I said before:

>> this is wrong since you really then should allocate one queue less,
>> rather than mapping two queues to the same core.

johannes
