Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9359F358388
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2026 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773040494; cv=none; b=EXteL2rWZ3AI/x2JaDWPGK8v7alsQrt7yxDJBmMBhQEZGk6/FS2hAScCqdjaXpUTg2Vns3yhi8R7BqiOZ4mpHD8p93w6A7dBMqOQvfoK9EE9uLA3u6M2555GkSy91XY8uegbGsJHZ/ig0N5o4Veity4sbrNZPkJOnhmy/dnpBRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773040494; c=relaxed/simple;
	bh=fQtCg1E4gywRyW+f+q7gtidVJPYFZ6aJHCw7HTP/Cqg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oe5ZdwFFF7fNne2s3X/vWyVg/bGvVvVHbBLeC0Sh35UYX22ewwZZkHNXa1cGlFyuocATOfRcsI0yyiVM1xiwTaxGlzkcLTRvBhyLAto5zSJIjUQ/u87HKXO4kYimmV+dMuUhnLGNkqeUpSTSwT6c34u79KON5PjMjMWCg7G+wmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZgYniRzF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZgYniRzF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=shCFOHqRz0MUL2tLM7/k8p/MJVtM80+TpAN4iwmzsxM=;
	t=1773040493; x=1774250093; b=ZgYniRzFizN/kZQXFVZWn6Kx70rw0oWgntjKrI3j6xbRSuu
	I2M8ZsLI3ZXd5/IUUMMgpzQQS4tTXsU77FdfWeH7Wcc7V4x6Rh8Ft00uyC4hEpPryS17EHyG6vWW/
	NJQP849TmzmVXeLLJucF9EUyzGXUCUdXFnCd84QF97id7AsUQSa4DoUpDj7B31dzE/a4nhE6i6vzr
	fRba/VzJHn5V9KMLWAl1U5vKiox0ttV2bH42s6XqKD5+9lgqSsqTdAiXPXtoWZjA2BqKJ6+KX8S43
	hm2IC3h0TPlRFPUX56oktGEperUVif0YDx6V6YS9YB/ZuwDobfw6OhsGaNiOTZQQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vzUpH-0000000Cm4W-1Kgy;
	Mon, 09 Mar 2026 08:14:51 +0100
Message-ID: <be1c90f6be71f6118590b0add4d657cd79d2ea2b.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Remove deleted sta links
 in ieee80211_ml_reconf_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo@kernel.org>, Lachlan Hodges
	 <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Mar 2026 08:14:50 +0100
In-Reply-To: <aa15YDx5G7WN-nsH@lore-desk>
References: 
	<20260307-mac80211-reconf-remove-sta-link-v1-1-efe58070cd36@kernel.org>
	 <jv2kdsru66rktkm6bwq3ww5wshubjtv36le5xk4ziedocc72gp@psssohaoamus>
	 <aa15YDx5G7WN-nsH@lore-desk>
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

On Sun, 2026-03-08 at 14:28 +0100, Lorenzo Bianconi wrote:
> > > +	rcu_read_lock();
> > > +	sta =3D sta_info_get(sdata, sdata->vif.cfg.ap_addr);
> > > +	if (sta) {
> > > +		unsigned long removed_links =3D sdata->u.mgd.removed_links;
> > > +		unsigned int link_id;
> > > +
> > > +		for_each_set_bit(link_id, &removed_links,
> > > +				 IEEE80211_MLD_MAX_NUM_LINKS)
> > > +			ieee80211_sta_free_link(sta, link_id);
> > > +	}
> > > +	rcu_read_unlock();
> > > +
> >=20
> > Could use scoped_guard(rcu) instead?
>=20
> I do not have a strong opinion here.
> @Johannes: Which one do you prefer?
>=20

To answer the literal question: No strong preference I guess, given that
there's no error path here this seems fine, and the scoped version would
just add another indentation level.

But you really should just remove the rcu_read_lock/unlock anyway, it's
not needed since this holds wiphy mutex, which is sufficient to access
the STA table etc.

Also, I think you need ieee80211_sta_remove_link() to tell the driver?

And I realized another thing - this needs to destroy TDLS stations that
were on the link being removed, but maybe that's a separate commit.

johannes
