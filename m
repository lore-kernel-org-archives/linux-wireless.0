Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7373905EB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518297; cv=none; b=WzVvFCB59/P+FF5XTEu1FVeXF7UZ552+gVH2vJlSpzBVSP3rPQNP/A0hK5cNDjZsxRY3IXrfA6hP94NdmuAjS9OiYtVIQXZwmVUWQnYK+Tlyqj/Y59BZ8zQrE+qf9dxOsE23dtldKZkoAMkkYQvfh8PuBYsXGbxFTgB2leurPXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518297; c=relaxed/simple;
	bh=vvzO1PvgCuuJoZgM/Ij9G7fuC55BlPYKyVHMiI/jsyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EFh4T2i/nmQMfOXZYBEe+k0b3zA2QK9DNCbBgHS0U4bUKGS/s7e3jxoIHAnayAxrSFcVtR0BMIAGz9CUSfCb/G1OpAwn3kmX5wnT2uZ/6pcwWdPNL0aNbAYqF18f3IYYvMSQc93Hq8ZPbsNry3BogMCDylYHH7TaBlafLBadAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gkhWaL2f; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gkhWaL2f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ohGWrXfHWMg4JgWw+mktaBplBpkoMMHgTBE4CxY0ANs=;
	t=1788518295; x=1789727895; b=gkhWaL2f2n4FbBjcgraGdRGdhTs/2v8DtsCTMb18eoty/AV
	Ea8UnE7awt4QvGnvlqtf7bBjnfJEaSTkcSvtjXkJldIrlwOzLhwy+L4ZEHqgpiqAo7Q4MUe259aiV
	BzAQK0Jc2sXALI1LWrtv6miFKV+CjJTRo7GMhkzyyl04FHWd7H/fEBYyGtEpDz+F/h73Q/+pAPL1J
	gq2eJFr39gf27ehKCzzZ+P8RhVGLWTgLaQH1Gp9qtRjyhribYNvn1fCA2wh69d0BNYvq4mSF2C56B
	/PRoH+8exqch8aTKRavAiAUNzKTB0dJjqGxrZM+f7uQ9ZYeG4YutUKL4Rwz5wpSQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2RJD-00000001L0H-0AHO;
	Fri, 04 Sep 2026 12:38:11 +0200
Message-ID: <47c4ba195ae49552538ea65f4f13de7d3dced266.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>, 
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Ganesh Kariganuru Mahabalesh
	 <quic_gkarigan@quicinc.com>
Date: Fri, 04 Sep 2026 12:38:10 +0200
In-Reply-To: <20260820052426.3177309-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820052426.3177309-1-aaradhana.sahu@oss.qualcomm.com>
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

On Thu, 2026-08-20 at 10:54 +0530, Aaradhana Sahu wrote:
>=20
> +struct ieee80211_bss_conf *
> +ieee80211_get_sdata_bss_conf(struct ieee80211_sub_if_data *sdata, int li=
nk_id)

not sure I think this function is all that useful, but

> +{
> +	struct ieee80211_sub_if_data *bss_sdata =3D sdata;
> +
> +	lockdep_assert_wiphy(sdata->local->hw.wiphy);
> +
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN) {
> +		if (!sdata->bss)
> +			return NULL;
> +
> +		bss_sdata =3D get_bss_sdata(sdata);
> +	}

at the very least that part is pointless, and should just be a
get_bss_sdata() call?

or are you saying you somehow found a VLAN existing with sdata->bss
being NULL?

johannes
