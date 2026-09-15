Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758414AF687;
	Tue, 15 Sep 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490423; cv=none; b=N7vOEVHTEBN0f0DZFJnAcCmuiWmuaFALnoiK7TeZaFDKVYmqtARpuDNDxak65xzQfu1b046HZCeYmL60D/+LaPnh4gWyPnAIRVqt7FhqqPllQrGL7c2Yr4RUb3e5aFUw3GRVfB0TpeTUojAR44WzQjXhkE9vtfHoeIBmkzCqbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490423; c=relaxed/simple;
	bh=xXAr4gOumFXBHNqcbDK7LbEB0VjhfaPCnte+SDnxthY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VzQXy79w5gdpCHonzIiHliCSFwWqv14BEYGf7jX0LXu7qsu65kX/Wtalj7DqQ51d4K5SCEYnNcxR20ed9Exe6HPrwaWKd9JW9nfEqMvfXSSD5QEG5a12LyggUAkZqJqmVdZTLrimF4FYwFCXBUprVLCeQcSfnUptQydBT/0JaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=j7N4fD6I; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="j7N4fD6I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xXAr4gOumFXBHNqcbDK7LbEB0VjhfaPCnte+SDnxthY=;
	t=1789490421; x=1790700021; b=j7N4fD6IFlFg/1yxIM2hUAGPj6/UyVhxcyrzQTaSU15p2co
	K7NlYN0b294QWx914igofeEoU5YF89jRX45URY/TmINGtcEaN+fojuK/3r946MEPPOVqmDWKlSwGa
	+TulcN5rG8XalesxwgYsU9sEJfhGUL5jtj1SAwTmSVXHqHFcOqjw7/sM+7nDyOK0cNhhV/IcMQisZ
	o1UJFg4kTaUHKe0rNXDYG/iglNITi/pLl8vY/c5I+lzJUWcVcF6dhK0ZT0Uoh6rzS4RYJGRadVlVt
	jaTfwvmtEU8Ewj4jEI3uHz+t2+DxQ/Now3r8clPqOvicbHZdDk8PPdhpbzfFltvg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6WCg-0000000HEnP-08Ek;
	Tue, 15 Sep 2026 18:40:18 +0200
Message-ID: <5fd439ca0defb993d3b9ae199b2c2b85b13bd7de.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: brcmfmac: Set extsae_pwe parameter to Infineon
 firmware in SAP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, Girish Rudrappa
	 <girishbukkasagara.rudrappa@infineon.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	wlan-kernel-dev-list@infineon.com, bogdan.nicolae@gmail.com
Date: Tue, 15 Sep 2026 18:40:17 +0200
In-Reply-To: <20260914200347.1743016-1-arend.vanspriel@broadcom.com>
References: 
	<20260831061213.240270-1-girishbukkasagara.rudrappa@infineon.com>
	 <20260914200347.1743016-1-arend.vanspriel@broadcom.com>
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

On Mon, 2026-09-14 at 22:03 +0200, Arend van Spriel wrote:
> On Mon, 31 Aug 2026 06:12:13 +0000, Girish Rudrappa wrote:
> > Parse and configure the extsae_pwe according to the information from th=
e
> > supported rate/extended support rate and RSNX IE
> >=20
> > Parse the beacon IEs on start_ap() and set the extsae_pwe iovar.
> > Set sae_pwe to 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> > membership selector is present, 0 otherwise.
> >=20
> > The changes are tested with FW Version 7.45.286
>=20
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>=20

This is one of the patches the bot couldn't pick up (per my earlier
mail) - please resend.

johannes
