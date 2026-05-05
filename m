Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD5833064D
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996507; cv=none; b=c+YFrTH1BqcnLdDD9paLVl+3ZojvMYOmApjxzb2L6/dwW+XeYZfYspXW6lj11IdelrXo6zLgpts8aESwEy9ygrMug6PtHT9rz6p6qZm90ldIS5DoXIfofLTCsNMjhJOq0AbY/WfDHA64QNniCVm+nex5iI85T9U7qSvblcfY/zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996507; c=relaxed/simple;
	bh=6n4ik3CuMygwkwevHNEYERsi6Y2be74Yp1WMrT5GG9o=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q9w7fSIQNA3j4uWqru8OlMQrtUM7qbhIFVoOJQ5tHVAasjLr12C7GblcOEEGXjunXD08+UMdyXz8sEvgnaZMTXtYQxRN3MaE5GCqeCZtkUmEI8Y2YlWp3O+LJj8TV2UXnAKMmP5QRiDU8IXN8pQeO5lyGohz7sNfZ9d172lgEL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LH9S20wa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LH9S20wa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=bILeBOWfPslZv/a2xl9omIf483SrUQhVhUlYaZU9eQA=;
	t=1777996505; x=1779206105; b=LH9S20waHzuexRuI9j4BiATlmgFm9PkTbR7UYwv+7Sm7qpI
	q0LESYZfUnmTmjzjQpjRRHK13JiX5b7LivzBlfID2+lEX1NPXTA96Wkct0NnOF2icsMuykB7GZYQB
	ttOtWTvehflvHtViJex3obqGxaDX5kH99XYrgltieUNPMzhYzdQJ4QcZbgGvzAil+/1bwNZsvWerl
	Dut9H0JNZWT57NoO/01lMawjWAIDPoattRCpZyGmbiTLqAGt67z/LivCr2LWbvDoJ8ol6tK+1Iuqb
	nb7pgNMUE87HsTqnCMSNFFlNyK7vjJhTd2TYhxqzGguGG8ZsE/4YofOCKh+NbwGw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKI6x-0000000GVLH-17ee;
	Tue, 05 May 2026 17:55:03 +0200
Message-ID: <416a4b3cbf8bfc2fa17c14a347f31bbaf2a5376a.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: check stations are
 removed before MLD change
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, linux-wireless@vger.kernel.org
Date: Tue, 05 May 2026 17:55:02 +0200
In-Reply-To: <d50bc7a2-352d-43ff-b3c7-b5b13ce7112b@candelatech.com>
References: 
	<20260505151731.3d7cbb8b952c.I4ce7b536e8af26d7b115e82fd733734446cc56a4@changeid>
	 <d50bc7a2-352d-43ff-b3c7-b5b13ce7112b@candelatech.com>
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

On Tue, 2026-05-05 at 07:17 -0700, Ben Greear wrote:
>=20
> > @@ -307,6 +307,9 @@ static int ieee80211_vif_update_links(struct ieee80=
211_sub_if_data *sdata,
> >   	if (old_links =3D=3D new_links && dormant_links =3D=3D sdata->vif.do=
rmant_links)
> >   		return 0;
> >  =20
> > +	if (!old_links || !new_links)
> > +		WARN_ON(sta_info_flush(sdata, -1) > 0);
>=20
> Maybe WARN_ON_ONCE to keep log spam to a minimum?

Maybe ... It's never really _supposed_ to happen though, and if it does
then I doubt it would happen twice, at least not in close succession,
since it flushes here. It's a trade-off between the extra state and
potential extra warnings, so not sure the _ONCE is worth it here.

johannes
