Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210BB38399C;
	Sat, 25 Jul 2026 08:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784969748; cv=none; b=SwIt2JVoNxDnNkai0JppkLx+YYx/Xl1brmCil21bITZEZb35TlSZnzR2OFNUljuBG0FmOzKuO68Y7clNcso+rFVOE9Gim6SJHsjG9UZV4bGDX/OPbYt8Y/y0JZYRq4SfM2i9lHpodUR/e6iYT5Puu85RhWzmgx1ktndARHBlD4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784969748; c=relaxed/simple;
	bh=mCsgG9EM+tc1hBxlAA+tNvFMrZQIoird1bVvBjnf5as=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nJG7phIQua1bMNFaVP0/3Y+36YjVmsQuma9+HTpjDEWyTo/P8zybpgef4mDVa/kDcElNzIo5aW6v1BOkk0YMVKaVQKepPlfJlZbKuIzaNc5oH6IvffyGTLlchykZAE70hbyyoOcr9WLb/QTRHkjeYEoEq+PYbDn47WTHpXWHXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pNRJifCN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pNRJifCN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mCsgG9EM+tc1hBxlAA+tNvFMrZQIoird1bVvBjnf5as=;
	t=1784969745; x=1786179345; b=pNRJifCNwfJSSBGhp5+mHI12z9nFd1nIPitoszUI/23U79T
	YEoc68V9yJQcI7a2JaOs1xqrgmqMPdm07ggVPxxTY21jW2Cd3iTloEhsGb1GlK0d3VP0hEZtpsnKm
	/i53ahoIn25c92j07ciCVZ7i3tE937Ghi6zu9WCA7P3u6vvy5VMTHpIJapbT3YANFXyoOwbFVd/AM
	xLWieCj+F98C+fO2vwADoCb6A+Bqemdc//6uKqC2y/w7d0RhMfIc3WeCqEjiVKQPAj0az7YWez0Y8
	aVM/yWGvHByX9NvfS5xWSIjW3YA6V/9AnTLy1ctKbleVquTtyD1MKQh4iOoZuAsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnYAL-00000005HoP-2H0a;
	Sat, 25 Jul 2026 10:55:29 +0200
Message-ID: <9c4227befb03ff30c087a9d192bb3da879adc823.camel@sipsolutions.net>
Subject: Re: short description of GeoNetworking
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Andrew Lunn
 <andrew@lunn.ch>,  Simon Dietz <simon.dietz@plantwatch.de>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, dietz23838@hs-ansbach.de, 
	edumazet@google.com, kuniyu@google.com, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Date: Sat, 25 Jul 2026 10:55:28 +0200
In-Reply-To: <0f5b698c-6edf-4d8d-bc8b-a77af4be42dc@oss.qualcomm.com>
References: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
	 <20260722213437.3593569-1-simon.dietz@plantwatch.de>
	 <70e14ff7-fa2f-42a9-b880-a6adf5713c10@lunn.ch>
	 <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
	 <0f5b698c-6edf-4d8d-bc8b-a77af4be42dc@oss.qualcomm.com>
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

On Fri, 2026-07-24 at 18:26 -0700, Jeff Johnson wrote:
> On 7/23/2026 5:37 AM, Johannes Berg wrote:
> > A bigger issue with this might be that it's clearly a small piece of a
> > large overall puzzle - Simon, you mentioned a modified driver somewhere
> > I think (can't find that mention right now), which may be using the OCB
> > support in the stack, perhaps, but also isn't upstream.
>=20
> The ath9k driver is patched per the information at:
> https://gitlab.com/hpi-potsdam/osm/g5-on-linux/11p-on-linux

That's a far smaller patch than I expected :)

johannes
