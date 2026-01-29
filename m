Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D02D9797
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2026 10:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769683266; cv=none; b=eW7WefhCeybyHJDbPnJTYzg/wbCZcYFnwd0p/27Exs/L5/Dr49vU8BFZZmHJxbJUGB4GVskAuUs/Gf/pjRyTkuclT7WwqBQm9LYdq37XFJqAYRxYtYubI4BG3UffmtKy0KMqh9MjNUBc3bl6SBLQb5Genmn0JjJ7Yj2FPbWu1XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769683266; c=relaxed/simple;
	bh=5gS+mk6H5qA35ox1CI6N5NRIMShZMymiRsgLtTzp4Pk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IL91J1iHFN2zBiFupH5aHmdXxyK2pINwHEpgXm2qqMjRUwiCn176kFah7+0lCQJ4+3NSXZLN/KAyv8fjQdLGN7HQhMg72CxqGdCYKRCrTrjA4E/nP17RFfjrOhHtg+bznbOZ0smCwNzwpXiVGY9bAfutadQjW+fIARy8hPmFN4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XLLWLcTA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XLLWLcTA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=DHzIka3ZUXPiAJVGhescLz0uxJDSQy65Ksgz41NgL8s=;
	t=1769683265; x=1770892865; b=XLLWLcTA+Q0FLYSRDeSv+OVONFF4lb8QM2PBOrwuYcWcedI
	cEf381Cn7KwmJscS82ti+ntBkZmDfz3Ybn6FSay1z1HV9dG5HO4tg9nZGl0rqHrOGyqswxXvJe4iw
	Jv9aVw079LvQufapSwn87JJLkLhzQsWs7YWBafrTgJVkNcaOkTVVBQLt1bkjfwnnaT6jDKAiLGSzO
	2BHSJKWZVlJZ4AyuZa2n/ZQbQZIMk1M1D8sjQesfzVA60NmPQEwFx36KmqRSY54dHeH3C7cKEeCUw
	P5kybYP9A+G6OE03T4DvDT8bDgeUB759o0J96LqeMKeWeFcEaVpNz2KfB9FbU9aA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vlPSP-00000006n8k-2CgK;
	Thu, 29 Jan 2026 11:41:01 +0100
Message-ID: <57afadb2cbd7e9ef2d15a50ec688e62bf8b0e11d.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: use wiphy_hrtimer_work
 for CAC timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Amith A <amith.a@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 29 Jan 2026 11:41:00 +0100
In-Reply-To: <20260128064856.3667270-1-amith.a@oss.qualcomm.com> (sfid-20260128_074905_226433_BD0D407B)
References: <20260128064856.3667270-1-amith.a@oss.qualcomm.com>
	 (sfid-20260128_074905_226433_BD0D407B)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-01-28 at 12:18 +0530, Amith A wrote:
>=20
> @@ -3851,6 +3851,7 @@ static int ieee80211_start_radar_detection(struct w=
iphy *wiphy,
>  					   u32 cac_time_ms, int link_id)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	ktime_t ktime =3D ktime_set(0, cac_time_ms * NSEC_PER_MSEC);

ms_to_ktime()

johannes
