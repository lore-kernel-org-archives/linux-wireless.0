Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA8F43550A
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790925974; cv=none; b=Rkf4iZ7Gn3Epdxdurl/oayXInY5TgEDF4kWzFEy5Vhp+n0S9we0VMIx78SKslvzQ4RcBSbxOfULTkJMCY4kaX2E4jYIIs2PSELPR6/xagL1EDM3qMQ8qhcP5dx5fkKns83R8EpntI+n2tJUsCDIBSXhNEvYNI1qJ9TAklRxcAWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790925974; c=relaxed/simple;
	bh=bCKVWw09fEeMa2E9A+KEs5NJ+erboHSTHW2J6PAbrqA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z1ioAKiMWfP+S1ZsZL7NX81+iMWTCa9HpSp7hHw9veGM8we8Nmk2mAhy6IdCSPeY37s3ikOaunzG8PY+uCwSCKuUmzr439Mnt7rUSOmYM8K32VCRXXvPxuvOomW89IrjKuqEnSZgvB5BSWurbHed93l4A1KeteNdlLYsEprMdd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CJCdC7Gw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CJCdC7Gw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Sn9a5GdxgCC+M1lrZDVmU8oFDwLcYHUSIpFbKIZSO4M=;
	t=1790925971; x=1792135571; b=CJCdC7GwH6BrcB9llR2ta5DpujvgnNN+UCPj0n6248xSB4g
	/cEbqhBkg54YjDlZWkfxvzwspXgudG+KF8MH6HrRKW/opHyhWcUIccoceNJK0z9K5GfRZCe2WGOj9
	2vh3ynBaTVJzvplLJKu81rrPSABut0c8Ul9his3kP22C1GUjiEJVN34r8ckkPMWCvoGjVIf+IIvN0
	sYdfcXjybt4WtSt4HkQSPIMoDaHDVHvGkrePzo0BZMdgiFj4FJ0i6mE6O7/D/gey3k2J3acRqlY0t
	PFYRuS6ipKkc2LjiNXLHjuielbpjnvuUyC6/S/Mh7WfZtDkXjutft+fy0O03UNkQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCXef-00000001GDh-1Xp5;
	Fri, 02 Oct 2026 09:26:05 +0200
Message-ID: <8f58e34fa9962d3967dfa792fa2d724db89e4452.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211_hwsim: add NAN Instant
 Communication support
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>, 
 Benjamin Berg <benjamin.berg@intel.com>
Date: Fri, 02 Oct 2026 09:26:04 +0200
In-Reply-To: <20261001162941.7e69a74a7ba5.Ib1a57bccf328a19dc55b914ccab73d023fe0876f@changeid>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
	 <20261001162941.7e69a74a7ba5.Ib1a57bccf328a19dc55b914ccab73d023fe0876f@changeid>
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

On Thu, 2026-10-01 at 16:33 +0300, Miri Korenblit wrote:

> @@ -263,15 +300,26 @@ void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
>  		slot =3D hwsim_nan_slot_from_tsf(rx_status.mactime);
>  	}
> =20
> +	/* (overly) simplify things, only track 2.4 GHz here */
> +	if (rx_status.freq !=3D 2437)
> +		return;

comments should generally help ... I see it removed below but maybe make
it better while touching it :)


> +	scoped_guard(spinlock_bh, &data->nan.state_lock) {
> +		/*
> +		 * Fall back to the device default if user space did not
> +		 * configure it
> +		 */
> +		data->nan.discovery_beacon_interval =3D
> +			conf->discovery_beacon_interval ? : 100;

That seems like the totally wrong place - should probably make that
default in cfg80211? Or is there a reason to believe it would need to be
device-specific?

> -	data->nan.notify_dw =3D conf->enable_dw_notification;

Some of the refactoring in this commit is just confusing, like this just
disappearing. Please split the refactoring off first.

johannes
