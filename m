Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107AE440A1B;
	Tue, 28 Jul 2026 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245602; cv=none; b=IlM7xITQtF9gSaLhbGDp5M3jnpmFUmTrj7wt3aZluZcQhjUugQS+Yc8yfhHqxye+pFfDNCNL55iWro1vhK++zvBC81PuVAand6WZ3fD84tBrvgDAiO8ORPiH5QiIRX1qHCc+0mteqjcyGD+02ZfgITxzi69ee5N3ZdABd0qcJjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245602; c=relaxed/simple;
	bh=dB2FD2Jt+xkoNf/RtiVrCRMFYq/vWUrEwA0teaOd83Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=elj3jMukeGsgC4oTn1zJOoV0SKBSbVGFC4yA3GEnUGh5E5jiMSFwvSoEoGuPN/KPDRMMkuVJDahiVZX3KkIwhass0cuj9SqceQdrnIKOZy35Jzkm+DH0zPywWD49SXpa3zHARc0mTXbOlOmYMFzE127LPj0U5VEscJbOB2vkncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hLcPH0z0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hLcPH0z0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lcfasX9W7wKm1g9QAzFmF3G17QASXNE+AZBdsiDciYk=;
	t=1785245598; x=1786455198; b=hLcPH0z0BbeWQOI1glRgxIK6jerJqEfmYOWBc6+XtSQV4U+
	dy7AdHS/5OLtEWqQMGvVIHak8/vir6QAnLYdFFsiafmZwBqx7s62aGQjROS22Y/AdEcnSFaUefIBB
	L+sFc72Js1FyNdLsCLwW3EZf2JaU0b9uTxb9BmeApFqa4+pW0VWZQuG81NZQvNnGAcI5KBSStuXnQ
	H4MAEV4KzS567tD97beJOPpE26SUriWuRKZc1+biAg84/13hp+Unj5kv/FxNoNO12uUWN7gaBG8Kt
	le9BxgU9qnBCPWhj0cfsvnp69sD8LDSrkqRf/nQfhzd+Wh77utd5rhv0PsEFxR2w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wohve-00000008qgB-2KeT;
	Tue, 28 Jul 2026 15:33:06 +0200
Message-ID: <506265cb26a402a10c82ed347f599a478f1d5d73.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mac80211: validate individual TWT params
 before driver setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lachlan.hodges@morsemicro.com, lorenzo@kernel.org
Date: Tue, 28 Jul 2026 15:33:01 +0200
In-Reply-To: <20260723010928.76551-1-enderaoelyther@gmail.com> (sfid-20260723_030941_667975_B860D0C9)
References: <20260723010928.76551-1-enderaoelyther@gmail.com>
	 (sfid-20260723_030941_667975_B860D0C9)
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

On Thu, 2026-07-23 at 09:09 +0800, Zhao Li wrote:
> ieee80211_process_rx_twt_action() validates a received S1G TWT setup
> frame only through the control byte and 2-byte req_type before queueing i=
t.

That's not _quite_ true?

static bool
ieee80211_process_rx_twt_action(struct ieee80211_rx_data *rx)
{
...
        switch (mgmt->u.action.action_code) {
        case WLAN_S1G_TWT_SETUP: {
                struct ieee80211_twt_setup *twt;

                if (rx->skb->len < IEEE80211_MIN_ACTION_SIZE(action_code) +
                                   sizeof(struct ieee80211_twt_setup) +
                                   2 /* TWT req_type agrt */)
                        break;

                twt =3D (void *)mgmt->u.action.s1g.variable;
                if (twt->element_id !=3D WLAN_EID_S1G_TWT)
                        break;

                if (rx->skb->len < IEEE80211_MIN_ACTION_SIZE(action_code) +
                                   3 + /* token + tlv */
                                   twt->length)
                        break;

                return true; /* queue the frame */


But it's all highly confusing.

> An individual agreement can therefore reach ieee80211_s1g_rx_twt_setup()
> with twt->length too short for the full struct ieee80211_twt_params.

And that element isn't even fixed size either...

> The individual path passes twt to drv_add_twt_setup(). Both the tracepoin=
t
> and the driver callback consume the complete parameters block, not merely
> req_type. Do not pass a short individual agreement to the driver.
> Broadcast agreements remain unchanged because they are rejected locally
> after accessing only req_type.
>=20
> No in-tree driver both implements .add_twt_setup and exposes S1G
> operation, so this is a robustness fix rather than a fix for an observed
> crash.

I think this also isn't true, because there are some drivers that have
add_twt_setup, and having S1G isn't a necessary condition for this, in
fact this particular path is meant to not be used with S1G but rather
for TWT setup with HE (or later) devices.

Nevertheless, I'm a bit wary of adding this as-is, and I'm not totally
convinced it's a super urgent fix we need right now (-rc5!) even if it's
an out-of-bounds by (at most) 14 bytes.

I'm tempted to feed this https://p.sipsolutions.net/3956a9bfc0ab31b0.txt
into an LLM and tell it add a validation inline for the element size and
move the parsing to the element parser like we do for most other frames,
but I don't really have time to play with it right now. Also, it'd need
more information from the spec (this should be in public versions) about
when each of those fields is present and when it isn't, and the struct
ieee80211_twt_setup I documented there only covers the individual TWT
parameter set field format, not the broadcast one, but I _think_ this is
right...

OK, I'm just going to take this patch into wireless, as ugly as it may
be it seems correct, even if that's far from obvious with the code
patterned this way (not your fault)... we can do further work on top
later. Probably will edit the commit message a bit to not overclaim the
lack of validation though.

johannes
