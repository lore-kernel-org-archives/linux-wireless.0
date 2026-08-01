Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88EE3624B3
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 10:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785581715; cv=none; b=HVwuJS6p2Eh0yYYl0XyUHCH6Lnl88vrl+7PZX8bm9a+y/4kMlz6PSmju3hb7k1IopLbh1002I5zQ2EZZvV6nwjPh7SWJsrUb3rCnBR0ChSuz/IXjqAbeCQCmvds+x0muRpJAYRpo8U76UNwTroTpu0d4McPwlkGeM+tJpG7IKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785581715; c=relaxed/simple;
	bh=9jRh2qLRofnBugWCiHHXYuLn1UndiukDt+Oq5g2mm3c=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t/98kPMVcgAssAoSlQKV8hCuwwruTwn+ZwPC5LsUcofg8b/vIar2b+Y97v/yyrQ8BPiBrzmx7kQBeQ+Ag11eZ9w27CPrAN05R5RMCpSDGhPiRNMUlKfebD9/gjtaT0kY/4/0Feg5IdhZjo/faEAvivWRX8qWSg/A5opF6HxYjtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u0WYmAu8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u0WYmAu8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+PLNfw03G6aqT81clUL+aXOr5iEQo0Y59EvsSTXQsvM=;
	t=1785581713; x=1786791313; b=u0WYmAu87bJv116SnWQPiVireXflS2mle2jK2bw2J7JAdNC
	4WwTRIBOlh5bDKfeohiXf6Jvo32wXfSVymS2ZlARNkLNvu5xOteyFVA7iKQ4QwmBgqcoKqe09ldow
	q3Q6p3kGwfss0icmafqqD7HbOCqzxcAgN0C0BZixr/G+N7h1xXrHr2iBlU4Cu6WAyArftYUqTkiJH
	N/FFffuBhxjuOF1hXQGjPByOPBdninelKIciREky5o7DE9I+RQkmofHtpoRmVfSdBYi0x/kddZ8Hh
	3xyTFbHnjgPGdhMMI4Nxb4KDecsebsZzmgcPvne9aXB2DwHqDZSpHYMtquBUlB3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq7My-00000000hzX-250m;
	Sat, 01 Aug 2026 12:55:08 +0200
Message-ID: <a2972934ab38857628e7aa71d8886c74b9b90b40.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 1/5] wifi: cfg80211: add Control Integrity
 Protocol (CIP) APIs
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Date: Sat, 01 Aug 2026 12:55:07 +0200
In-Reply-To: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: 
	<20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-07-31 at 15:40 +0200, Benjamin Berg wrote:
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -3280,6 +3285,8 @@ enum nl80211_attrs {
> =20
>  	NL80211_ATTR_FREQ_FIXED,
> =20
> +	NL80211_ATTR_ASSOC_CIP,
> +	NL80211_ATTR_CIP_CAPABILITIES,
> =20
>  	NL80211_ATTR_WIPHY_RETRY_SHORT,
>  	NL80211_ATTR_WIPHY_RETRY_LONG,

No ... but anyway you need to resend.

johannes
