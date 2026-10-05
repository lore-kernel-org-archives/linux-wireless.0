Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D582282F01;
	Mon,  5 Oct 2026 05:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791178137; cv=none; b=iqzmWheT6pb6uD5MAyGbTGhoUD54uzRDBUN4WZ7EsloHGavgsV3nupdfcRD/UFpL02QxOXGbP5jXhC6f3eK4fvrqCiBYnu+Zhbcv0bTdml040TsambYhWnrdQRIaO3KjTzxc9r0u+wrrPNvx2mIBBTckTJoY9sk+gF+nXv021s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791178137; c=relaxed/simple;
	bh=6s5ZiJW9H5BxZ10Xc6+uFdxmz3iBFZeiiHPyR668OT4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ypsa51g0BA8SpJ0O1xVeU1bwM52Cuv+a2DAc/3kZ6Tce0QmTJQln+58d9paZ8A9ioUWkXYuE3HAQ0ba45XSA0q0twD1ZjDeWHOoVrHw7vzXRD2HJ2vrYhStIDmg0gMo3cyou5q/QRCkl3x027sur7szYWhcBSV1FHRj1GG3tbzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lUxdyouf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lUxdyouf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Gmv/BREUz+MsqVB/to1nDdqKmhVJMCtJ+1Miv/c9cNw=;
	t=1791178136; x=1792387736; b=lUxdyoufjy6KXBwlRVA7HBexM8U78TwEHR3QxGa/Uka5fLZ
	GFKjacjR4tX2G7QqI1swxmwmMVV7Eha02xWfkKS3NfNoLbe/IgTLub42T9Lr9FV3hY34M/8V4AiQY
	3KiNWiRXzA1pg1bFxx8GsSiJ4tMW8rvCV57Yyv2J88NOV8qDqouqSVgV7gKe8Vgic6fcTTDLYvDZ1
	i6I65YjR5u3GtgqI2I8b5R2AWdVShOWmD7LkTBre8eRY0TEruBPjTRQ30mFcINlVlAEQLjqrcAtAW
	O1dzEv52g5qkLG0GFYXKKhQunZNU3F36Jfm4ePlvIReuT352WC37MGuuw/hGAc+w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDbFr-00000005197-2XfA;
	Mon, 05 Oct 2026 07:28:51 +0200
Message-ID: <1130811ccc70721c60e66c3038bf1ec517af1cb4.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for
 commands that don't want it
From: Johannes Berg <johannes@sipsolutions.net>
To: kernel test robot <lkp@intel.com>, linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Date: Mon, 05 Oct 2026 07:28:50 +0200
In-Reply-To: <202610051243.rHmDLV0g-lkp@intel.com>
References: 
	<20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
	 <202610051243.rHmDLV0g-lkp@intel.com>
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

On Mon, 2026-10-05 at 12:18 +0800, kernel test robot wrote:
>=20
> > > net/wireless/nl80211.c:244:7: warning: variable 'wdev' is uninitializ=
ed when used here [-Wuninitialized]
>      244 |             (wdev->netdev && !net_eq(dev_net(wdev->netdev), ne=
tns))) {
>          |              ^~~~

Yes ... noticed that too, just slightly too late.

>    net/wireless/nl80211.c:238:27: note: initialize the variable 'wdev' to=
 silence this warning
>      238 |         struct wireless_dev *wdev;
>          |                                  ^
>          |                                   =3D NULL

That'd be pointless.

>  > 244		    (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))) {

that line

>    245			wiphy_unlock(&rdev->wiphy);
>    246			put_device(&rdev->wiphy.dev);
>    247			return ERR_PTR(-ENODEV);
>    248		}
>    249=09
>    250		/*
>    251		 * unregistration blocks on wiphy mutex,
>    252		 * so we don't need this now
>    253		 */
>    254		put_device(&rdev->wiphy.dev);
>    255=09
>    256		if (!wdev_id)
>    257			return NULL;
>    258=09
>    259		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
>    260			if (wdev->identifier =3D=3D wdev_id)
>    261				return wdev;

needs to move here.

johannes
