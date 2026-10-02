Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C664F3EC82A
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 08:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790928680; cv=none; b=vECsDh+u+Tzf9CiGpwXB5biqH6XDQNl3CvA4DS2rnC0EhrKMV4DXIrng7Nc1PbPlsmdExmOy5xr277DwG6con10sxxXVh/c4hQFa+xTmC44mA/R/Qp8zbUk/pvGIZWgkQ+4wl/j0V9qpsIPCSzqytOnL9mg9m0m0fZ16FnpfbtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790928680; c=relaxed/simple;
	bh=o6faLobPXkT6JFH9GbOtfbtupjzYn3omEKafpWXB7zQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aLd6c2JBJ+/i/ZkJ87TWePOyxh86GnLFOiO7rBVYceDfQVy2pAPCUF0/lVSeZ/egGSfat7ETIX38tg3PnYcWv3Xjuk9/wbAv5+RZ7oB8fd/vSpZ97GEKo7b50AdO67Rb8688kzVQvzPN3Xba6cXE/a7PXn76BGjicANdpUeincY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=V5jdiebH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="V5jdiebH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=o6faLobPXkT6JFH9GbOtfbtupjzYn3omEKafpWXB7zQ=;
	t=1790928672; x=1792138272; b=V5jdiebHr8YgW2zeV4N9Ie5Wl2bO4AjMC+1itHn0vljEmnc
	kintWQuheZ75hr82eGaDhSyQ9i7BtKWi69B1j7olye+jXxU77ul1rvDp8v27WI8hb3/RjCP8uYx21
	eU0WBziG4R4imawqy8lHEAufjKQlyWrdqH+azBn4ZUcAnVnEjVaBIUuEhJboatfRxkUcG2A9OlKKP
	Wddzck/HgGHr3dB/u8rzSO+gFPEvOmN71em7YscO/G70//0RdARKzsh1bRaRL+kuG5i/ENVw+rgyy
	TT8oIGKlPzBCfZYLsWhEvgRikbF311gcCVzmdMJqMWEDNsnpbWQH0VRPJksJvt6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCYMB-00000001I9S-2Ub9;
	Fri, 02 Oct 2026 10:11:03 +0200
Message-ID: <a998ca94b8dcac70562fcb3a6b7e11b9bfc87920.camel@sipsolutions.net>
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Date: Fri, 02 Oct 2026 10:11:02 +0200
In-Reply-To: <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
References: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
		 (sfid-20261002_093135_409872_DAA7268A) <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
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

On Fri, 2026-10-02 at 09:58 +0200, Johannes Berg wrote:
>=20
> Of course if you're using rx_ni() now then you could possibly arrange to
> call ieee80211_rx_napi(hw, link_sta, skb, NULL) with the correct station
> looked up beforehand, and entirely bypass the question, doing whatever
> you want with the frequency?

Oh, Benjamin says that doesn't work since we don't use it for non-data
frames - guess I should've read the code first, somehow I thought that
if the driver gives a STA we just use it anyway.

johannes
