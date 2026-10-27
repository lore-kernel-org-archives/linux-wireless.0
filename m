Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793123340;
	b=OfNFydgeZp0xka+A3ng1eDrK3elUbsFQbeaIiqrWQs+AN0cU3FpwSZAaywAt5m2vCH1h
	 9Yx+FZ9gzQ41IQINOiOEDe8TeJOzcGgn0asYyLP94OOoFch3HP/ucZZlzv6ZUHDq9cLO1
	 pC9aPQbD7Lp9hsOul+tOTLOyjQI1y+jbAaP0FPI0bU3uLaAKA+IUoPhqLJ0dyTBnhrki4
	 IJ8GnLS23YNJtg50ABfgZvCwLfj4TDxgrg40rsife0IJL4G/wNkasdumcqzCAeHHG0f8C
	 K9zq2IWdKRqSFnm79MM66vSBXutIMKiGT5yRzCg1D98M+35GZWSJnQGX4EqttPDdkDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123340;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=twafQJfOQkKpvCH5YSC+Q3g4dFjr5vGHGUf9efuo2A8=;
	b=1+wj7WOlRWBysfbejViWtC5LUPXfbZUsS1ilhVqXA17DzpIt+2rIcu0b4BbkS1a3mqwk
	 AX+uo00MVh7VzEXUd0TpicOhWU1eT5YM9nNewndT8W328HIDJOQ0uzoUxVPL1brwqSJJh
	 sT4jVFHg9TIBAAiQl56fbwPnvwtgJEkoIO9r6ojDMh+xC3KmlYtuSAN5TkplrFtRUq5rB
	 AFi7aRq0SZT/evDzBTOfLKHrad+3wlYi1b6xeq9UJYcCUhCA/Wlo7qEVqsshfUmhqFySP
	 mFL5+Qy5fL103hmGrePaMVJnhwc4IVNl4X1eW44WhW/XllsHCB9IwIL3ZV00H6Br4CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="ZjECMj/t";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C6606A31A;
	Tue, 27 Oct 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZjECMj/t
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=twafQJfOQkKpvCH5YSC+Q3g4dFjr5vGHGUf9efuo2A8=;
	t=1793123339; x=1794332939; b=ZjECMj/tMUhBxV+S/eyBBooZYSXe6xjEB/Svt/O+YTDeWjO
	Ch6FGJdGWVQL6s1mvzt1Ex4I2Ov5mQj7tGcnOJK5qZq66qbsjYmVEPUlNVNIFx5FWoSXjWArnsBwp
	UGPY1wY8h2wgD9U3RGuiih4RK53fzNAdVLDzCj6xPkAlAPXIqHj7+ke02T1N8NyuuMQut9xT5tUPz
	v4QzKi40n1y2c5kkMz9OKNIMtmABVAdKZcE/t2WghtHpZDvfn2tsi9TozPjtr53ThWHT0YLK48/F7
	59m21ri8l2gDWIzTeSd61BBzPrYPE0JEBHBfpsuCN1z2bpGC2d9eZSiwqkQ2nRxg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLlI7-0000000DKAW-3WrT;
	Tue, 27 Oct 2026 18:48:55 +0100
Message-ID: <40ca69a1af962adc946467151583ed7cab630eab.camel@sipsolutions.net>
Subject: Re: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-channel
 320 MHz regulatory flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Thorsten Leemhuis <regressions@leemhuis.info>, "Korenblit, Miriam
 Rachel"	 <miriam.rachel.korenblit@intel.com>, "Grumbach, Emmanuel"	
 <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
 Linux kernel regressions list
	 <regressions@lists.linux.dev>
Date: Tue, 27 Oct 2026 18:48:55 +0100
In-Reply-To: <41b46ae9-09be-4930-85d7-778e0003a361@leemhuis.info>
References: 
	<20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
	 <20260930122439.08094e4c344f.Ic0a4bf544fd6ebaf1fc62b40bf463bd289e58cf0@changeid>
	 <9a92165c-93dd-42a1-b61c-b494008f45b7@leemhuis.info>
	 <IA3PR11MB7213131F7C0C0D8D69A0A80E6BA3602@IA3PR11MB721313.namprd11.prod.outlook.com>
	 <41b46ae9-09be-4930-85d7-778e0003a361@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-10-27 at 15:06 +0100, Thorsten Leemhuis wrote:
> On 10/27/26 09:07, Korenblit, Miriam Rachel wrote:
> > > -----Original Message-----
> > > From: Thorsten Leemhuis <regressions@leemhuis.info>
> > > Sent: Tuesday, October 27, 2026 9:55 AM
> > > To: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
> > > Cc: linux-wireless@vger.kernel.org; Korenblit, Miriam Rachel
> > > <miriam.rachel.korenblit@intel.com>; Linux kernel regressions list
> > > <regressions@lists.linux.dev>
> > > Subject: Re: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-c=
hannel 320
> > > MHz regulatory flag
> > >=20
> > > On 9/30/26 11:25, Miri Korenblit wrote:
> > > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > > >=20
> > > > When support for the MCC update response version 8 was added, the A=
PI
> > > > change was implemented only partially. That version introduced two =
new
> > > > pieces of information about 320 MHz: the global capability
> > > > REG_CAPA_V5_320MHZ_ALLOWED and a per-channel bit, BIT(12), in the
> > > > channel flags carried by the response. Only the former was picked u=
p.
> > > > BIT(12) kept its previous meaning in the driver, NVM_CHANNEL_DC_HIG=
H,
> > > > a leftover from old devices that nothing used, so the new bit was
> > > > silently dropped.
> > >=20
> > > Just wondering: what happened to this regression fix? It from what I =
see seems to
> > > sit in iwlwifi fixes branch for a while already, but missed both 7.3 =
final and also
> > > the main net merge in this merge window. Did it fell trough the crack=
s?
> >=20
> > No, it will be sent once wireless tree will re-open for PRs.
>=20
> When is that?

You really need to stop pressuring people. Everyone's overloaded.
Heaping more on doesn't help.

johannes
