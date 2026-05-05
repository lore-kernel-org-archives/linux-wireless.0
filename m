Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D8821B9F5;
	Tue,  5 May 2026 10:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975207; cv=none; b=sdTujTpszK3bRo3QgrasxdfgSm0fVgGa1aTUdcvNqRuoPpl09wL3PxbpR39ybyx6Mczi7Sv8NEfIxs774kmtTp6lAKQdbKLemfUN6/oagXPnV3pYINIfR2FnG5sEDBnnhEFHgE5BOxsomhs4LiYdOpXMcnb7TwEEfAc0GemHQwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975207; c=relaxed/simple;
	bh=gFaYlaL4YkMpsWbcnTxCieY/znEYLvRPKhdzSywIghY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TtklIhRZYcD+Wk6FS58NK/Cl4nxFGtwQFHnimVUiLE6xB0oZdhtyD0lHtGD9ArzCIfJgCOjz33kGb9hNGES6Q3/RS267DIANoE8iMgVcguADw1iEnifAq1urt9XsZ4eTbyheZCx0iN+kyEQ4UiO4F2y+Ka7nUkvM1YyjycrI8a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CaIXBa28; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CaIXBa28"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gFaYlaL4YkMpsWbcnTxCieY/znEYLvRPKhdzSywIghY=;
	t=1777975206; x=1779184806; b=CaIXBa28MY8GnjOkF3aEw2YgQyRAaVY9EguKI7d5IyuDCbz
	MOq7s0n6FDw4tBDGtr+V1CXFFD5iVf3xIg4e4WOmgjqPiU5AteqI8Sn1vIbFFuRWG/ukm6a7NuqVt
	R0UcF0yp5OCS192jNG2zJ4P+GIAgdQK16/GEuXK232/xQXpj2kZG68dFS0TunXeaiTwMf86OQhUQR
	0wNKCG6WfXSRVneZOTPr1K+hgdI8Xv8q8P+ruz6hbIT7MA9hSWwyzr+OE/ReRCCbh1j/Mb1QSE440
	OtVFhSMo6+vrtibd9ZxxwSMq/01R1KRlEDis+svViO/IMFAZqw4azAn5j7SPzQZw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKCZP-0000000FxlB-1530;
	Tue, 05 May 2026 12:00:03 +0200
Message-ID: <4a80d9a16c37af6f35904b5298238f64f030c374.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] wifi: nl80211: require CAP_NET_ADMIN over the
 target netns in SET_WIPHY_NETNS
From: Johannes Berg <johannes@sipsolutions.net>
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 May 2026 12:00:02 +0200
In-Reply-To: <20260504135420.1178443-2-maoyi.xie@ntu.edu.sg>
References: <20260504125753.1154601-1-maoyi.xie@ntu.edu.sg>
	 <20260504135420.1178443-1-maoyi.xie@ntu.edu.sg>
	 <20260504135420.1178443-2-maoyi.xie@ntu.edu.sg>
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

On Mon, 2026-05-04 at 21:54 +0800, Maoyi Xie wrote:

[...]

> Reported-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>

Crediting yourself with finding the bug seems ... a bit weird?

But anyway

> Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>

Bot reports

 WARNING: From:/Signed-off-by: email address mismatch: 'From: Maoyi Xie <ma=
oyixie.tju@gmail.com>' !=3D 'Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg=
>'=20

so wonder if that was intentional? Maybe you wanted to include another
From: line?

johannes
