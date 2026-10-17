Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCE3AFB18;
	Sat, 17 Oct 2026 09:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792229618; cv=none; b=kPhvX7ji9170EesSL/ewF20Z+6rQi7h3eENTwyQO/L63FmmF3RHcCGQ6OuvBKekcisTnr9eGQ3DGGgVrl8N1sekzbvuEUQWImigvVCddXi0hKCtXmPRSBivdtR+IFm0IYNgLC/7jUAKGGasNt2lp/gDFva4K2eigCq58MdfUD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792229618; c=relaxed/simple;
	bh=JNk/jEhUnYIWFSc3J5De1EcVZmfoIjXCVyaScwDTK84=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cElFVSVqdWFk6iItm5CA9jVPQszn2ztYfLzIwoJUGfT/zw2riQAH9MnpqFF0kzNUrYaOwK8X0YB8YhCXak58hJTshHqbFCmmSG3LrsWyeaK6D/i/xfNpNrdBqJJWNrMRL/LOjUWsXbuOCOWdiUn6jJQZadqQxCiUKXSTi9OZrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=wU0jBuaq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="wU0jBuaq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JNk/jEhUnYIWFSc3J5De1EcVZmfoIjXCVyaScwDTK84=;
	t=1792229615; x=1793439215; b=wU0jBuaqlZs4UyG7zFKP3jpXiv2G29/epgQbYKFWSLCKWNT
	45QRx289aj7JJQJWUP4r//kpZ0XUuuaMRXyTVjSBI+C6zsepM7rGCgnePOu/8jO58Vrkm+K8q69mL
	1ORqSiyvfHIeQgwTyLm7EXzDyLs1YTC32VN+GH48pt8YldQMvyJLV8ctdmHRsNkOgVkARoutsEdNN
	FVVjKpL1p1vQjg5+lA2IyYyOze/uogPlF1H+9NUH2Qsl2CjyBwj8YsohpInRnhBZEiAVHuBjE6A6+
	fpkI+xjNPhRyCYr6N5fx9b/AYfqbUv3WABdqeHVuPPNblbVsN04/5zMGRTs2DrVw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xI0n2-00000007nvr-3T1m;
	Sat, 17 Oct 2026 11:33:21 +0200
Message-ID: <1c8bd087a5cfd54fbe2825f2fa19a7851357ba86.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fix MLO station firmware crash
 recovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, Jose Ignacio Tornos
 Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 17 Oct 2026 11:33:20 +0200
In-Reply-To: <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
References: <20260804175004.1761075-1-jtornosm@redhat.com>
	 <20260804175004.1761075-2-jtornosm@redhat.com>
	 <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
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

On Thu, 2026-10-15 at 13:51 +0800, Baochen Qiang wrote:
> I don't think patches 1 and 2 are the right approach. Guarding every call=
back that can run
> during recovery with a RECOVERY/CRASH_FLUSH check doesn't scale, whatever=
 callback we
> forget today is the next crash report. Besides, such guards don't help th=
ose in-flight ops.

So I can relate to that, but ...

> The trouble is I can't see a clean driver-only fix. The driver knows the =
device is gone at
> crash-detect, but it has no way to tell mac80211 to hold off until it cal=
ls restart_hw().
> in_reconfig would do exactly what I want, but it's only raised inside res=
tart_hw(), which
> is far too late for a device like this - by the time it goes up we've alr=
eady taken the ops.

mac80211 has the same problem? How would *it* hold off rather than
annotating every callback from userspace, debugfs, ethtool, sysfs, and
the rest of the kernel with checks? *Maybe* at the boundary _to_ the
driver, but that's bigger than the boundary every individual driver
has...

> 1. Do the whole recovery inside the restart path, i.e. move the whole thi=
ng including
> state reset, power cycle and firmware reload into the driver's .start() r=
eached from
> ieee80211_reconfig(). Then it all runs with the wiphy lock held and in_re=
config already
> set, so the sync is free and no new API is needed. The downside is we'd b=
e holding rtnl
> for ~1.3s, which I don't think you'll like.

This is what iwlwifi does, but it doesn't take *nearly* as long. :)

There might be a chance to disentangle the RTNL from this given the work
I did recently on disentangling it from cfg80211, but then on recovery
*failure* we have a problem with cfg80211_shutdown_all_interfaces().

> 2. Let the driver raise the barrier early, right after crash is detected,=
 e.g. split
> ieee80211_restart_hw() into two parts behind separate APIs: the first sto=
ps queues and
> sets in_reconfig, the second just queues the restart work. That way ath12=
k can do the
> time-consuming part outside the rtnl lock while staying in sync with mac8=
0211. This would
> also need a few op entry points that don't currently check in_reconfig (t=
he scan entry,
> for one) to be filled in, otherwise raising it early doesn't actually fen=
ce those ops.
>=20
> Does either of these look right to you, or is there a direction I'm missi=
ng?

See above - I don't see how we'd really implement the latter reliably in
mac80211? Sure, we have a bunch of in_reconfig checks, but ... I
wouldn't really trust them and I'm not sure we can guarantee them given
the surface area.

johannes
