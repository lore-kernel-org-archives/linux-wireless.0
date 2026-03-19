Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B872E7161;
	Thu, 19 Mar 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773943228; cv=none; b=Zi+n6fFKiDfbtyDalKpdrlT7UXCd45HtfUl004uFpmSrXuZyLLMeEykKDYsylvaqB4oPlIhsCWi5sWPd9e+EO1KDd3x5GaIq27ajSp8XC1BVWvI1aex+wEdPd54bFERpY2iFMncYaJrz9bPSYb7X5jVlYers0HWxX/5lVilByvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773943228; c=relaxed/simple;
	bh=16x3kujuoQ0/ptbkdv2b0rlJVt9eoxqxCHAwv16TQhw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E+lv7M9BMwe7Prf8lBLJTBKHEcetH8v8h7ICejZheczH8jgJg5zArfym4OjTqBzOMSZeqL2ajSEODz/lRDsi3RrX0g7dYAyCeqZ87f5YBpgfudRsb2b9HYFtwVPC7eh+pGFTjprcDWrtTqrpbqvGlkhbqulUyzeX4GKiGh92h9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CLNNvtbX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CLNNvtbX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=16x3kujuoQ0/ptbkdv2b0rlJVt9eoxqxCHAwv16TQhw=;
	t=1773943226; x=1775152826; b=CLNNvtbXwOnaYO0pRMCEKA7XdK2LNMusx+W1k39AAQXBeEp
	pPsgXsWnJ0LKl6ySPyfkDQQkZmKduXLZomhJYMisx6iXYD3/ndWW0I3xTmUDp1WTVmYnpfcFcA2ho
	7BHw0vsP8Ao7PuOGrhXKfju3vY5KyDI9S89nZxV8zy3nN4c9qmTbGQvLJ+aQydHCnHOhlQ3p1dgd/
	p7JY6y9pd4KnJ3oxxT/RRhzcwb8sqYIfLM7vDbrDro7mjE8vYo0yInpoTKcsZdDCGLIeYDCY+refW
	g/5agkSolmyoa4LhxM0X6r3ELMDFUddlkOgo8epNbqH8WnUR2IKg1hDdnaPWNaOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w3HfN-00000005h7X-2Zqv;
	Thu, 19 Mar 2026 19:00:17 +0100
Message-ID: <30eba12d4a256e55671746cb453d3f4f3acdf92c.camel@sipsolutions.net>
Subject: Re: [PATCH v6] wifi: iwlwifi: pcie: optimize MSI-X interrupt
 affinity
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Adri=E1n_Garc=EDa?= Casado
 <adriangarciacasado42@gmail.com>,  Miri Korenblit
 <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Miguel
 Ojeda	 <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 19 Mar 2026 19:00:16 +0100
In-Reply-To: <20260319173821.15470-1-adriangarciacasado42@gmail.com>
References: <20260319173821.15470-1-adriangarciacasado42@gmail.com>
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

On Thu, 2026-03-19 at 18:38 +0100, Adri=C3=A1n Garc=C3=ADa Casado wrote:
> Balanced distribution: skip CPU0 for high-rate RSS queues to avoid conten=
tion with system housekeeping. Use a stateful last_cpu approach to ensure u=
nique core assignment when skipping CPU0. This avoids mapping multiple queu=
es to the same core.
>=20
> Addressing kbuild robot warning: remove unused 'offset' variable.

You might do well to address human reviewer feedback as well, really
_first_. You're just digging a deeper and deeper hole for yourself here.

johannes
