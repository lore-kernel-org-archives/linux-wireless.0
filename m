Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B254FDE7E
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017198; cv=none; b=q0k05NF2ma9kMoP394t3xslBxfK4qGzNqnr5PkPzbGYobsJ5nbS8BdMRDlaxeQHItt1nwpB7KeSxXrkj3X8c+Fe3X+6vkFfORF8NuwagitO5Py1VMwwQZfiYV+33L59Cq2QzYx3c40mkYYIcXgQNFSSxf3BniRywNlbo/5SrpCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017198; c=relaxed/simple;
	bh=gyYhEY7i5WQFYL/d1k6VvAklj9dARA8Fl2qaaE6N1a4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oEgzufyKiNsArNeVWqIo4CbJLLJj9GM1bTQOelBpaCpaEMHw70iIsB8K57piGttiGiF+jRnmt4gCUAdS0UfYEhueGiPyprPkXXbqRmO+kp0DWp43IjMJJhbT/Hw45aSx1/st0erqGJhnNMdtjiNzgrTqpruw0UEjGwnjM6no6jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pqv2zYiu; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pqv2zYiu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gyYhEY7i5WQFYL/d1k6VvAklj9dARA8Fl2qaaE6N1a4=;
	t=1790017196; x=1791226796; b=pqv2zYiuo15MQre2zbdC5Hw0AMTJUUawVWtdD4HVK+JXlV1
	EVkaNpBDzDo/7RHX8BdKk2zlA6WXjOe+Qc/f+nfdfZ4Qv8SWcbRac9mL5KsSl5s2CC1t78jSdrML2
	XbTz4PwyeLbIG3IQvMOUfTLl/453JqYw5pjXKn2hwSi0UcZpY+SD9DfFP8E4sEKdTP4DWR1k7qazE
	HDeQtPQmvLBb6Mr5izyn2d8/QFo5IvYFDbGek0CLoE7++KJFCbyrQBxGRkHB7wMZh6nYHNFUBXtEO
	viTEVoV3lH4QdHKIFcPsplLSBxRyu5pgw7+Sj4GAF6xPfSaQrIOJtAcsZeCLAu3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8jF3-000000060zd-26oF;
	Mon, 21 Sep 2026 20:59:53 +0200
Message-ID: <289eaefe3389894758d3ba1b3d24aa73aa630d91.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] net: cfg80211: validate monitor
 channel set against radio usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Rory Little <roryl@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
Date: Mon, 21 Sep 2026 20:59:52 +0200
In-Reply-To: <20260921184605.2699-1-roryl@candelatech.com>
References: 
	<2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
	 <20260921184605.2699-1-roryl@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-21 at 11:46 -0700, Rory Little wrote:
>=20
> - Handle error return from cfg80211_get_radio_idx_by_chan

Yes, but did you do it correctly? I don't think so?

> - Fixed subject line

No? "wifi:" instead of "net:"

johannes
