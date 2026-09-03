Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF673B4EA9;
	Thu,  3 Sep 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456927; cv=none; b=qDss5KJPiz6D+Xes3Nj3J6k6+YU+MixC8idaT8sQ1mhb4aca6WuxCBbwqBeXFpiOXRSkSnLs0dU6qUKlX5iAKNePME5oU2qFpw1cpLYBSy0H5kue/34FYPDtwayvnq3WNvfvEwOO6bglcDHu2lHDD2YEFkLO5zGW0E67L9qXPNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456927; c=relaxed/simple;
	bh=yX+j9z6eB49t/s9t6jCzVPCZ1hSIC019jroPd0A4knk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kr4Bd8POz9BWuHW0wc74CL/Cnrx/R2slKetqqNdNr8e6Ajl8x5BAs3epGfBT+7EQC/idHiMnHhUcdV0ngJWYgQU62xVO1NqBRX4Fl5YC3CViij9PfEg0YXrlnXZO+CTSaONAk2+r55MvM/PlGaiScefCqEnjCjo1H7Z0EHAuX7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nJNGYoU0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nJNGYoU0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yX+j9z6eB49t/s9t6jCzVPCZ1hSIC019jroPd0A4knk=;
	t=1788456925; x=1789666525; b=nJNGYoU0gTurhzkWCnjag9PccFoXGyrqGEAIBgzCA2gMkMi
	YlhBqkCfZIvW6UE0h3KsNKm4e7wEqkLXO4E16bsYx4XDPt991WFCOaTkw128FqLlm//YBbIfzQbg2
	3PQTBFjPY+mKHvkzLgoAk7X/o+2uJGIrJRqPla3v6+b4O8lwacwnSsQtEpFBrJWVVS/SSWqKZqbl2
	5pwNy5UTcJyag1s2pWi1ifjsRAOyWGFjjDlYcmp7hxEZSXX4sjvrljd5CKeY8muZlPTv0p7s3O79w
	MJBVL1jLAhWUQ6OX7TTEg97X6BWtFDZD2196XEgZQPK01/XM60+IKsOflUrYsE3A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2BLP-00000000JS0-0bFG;
	Thu, 03 Sep 2026 19:35:23 +0200
Message-ID: <22c0379159aaaf58c8d7a9dd36cd97dbf1a9e10b.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: skip reconfiguration when the last
 emulated chanctx goes
From: Johannes Berg <johannes@sipsolutions.net>
To: Nerijus =?UTF-8?Q?Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>,
 	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 03 Sep 2026 19:35:22 +0200
In-Reply-To: <20260829101532.1471682-1-nerijus.bendziunas@gmail.com> (sfid-20260829_121548_636837_D7BF5AEB)
References: <20260829101532.1471682-1-nerijus.bendziunas@gmail.com>
	 (sfid-20260829_121548_636837_D7BF5AEB)
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

On Sat, 2026-08-29 at 13:15 +0300, Nerijus Bend=C5=BEi=C5=ABnas wrote:
> Drivers without native channel contexts get the emulated ops, and
> ieee80211_emulate_remove_chanctx() reconfigures the hardware with no
> context left, which ieee80211_calc_hw_conf_chan() turns into a channel
> change to the default channel. A monitor-mode retune releases its
> context before using the next one, so every retune costs the driver two
> channel changes: one to the default channel and one to the channel that
> was asked for. Nothing is on the air without a context and the next
> context sets the channel, so drop that reconfiguration; the radar flag
> is still cleared for the next configuration to carry.
>=20
> On an AR9271 (ath9k_htc), where every channel change is a full reset
> over USB, hopping across the 13 standard 2.4 GHz channels with an
> unmodified driver showed 2006 drv_config CHANGE_CHANNEL calls for 1000
> hops with the reconfiguration and 1006 without, a median hop of 123.5 ms
> against 92.0 ms (p95 183 ms against 105 ms), and 99.1% against 98.3% of
> injected frames delivered on a second card.
>=20
> Signed-off-by: Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com=
>

You're expected to disclose LLM usage.

https://www.kernel.org/doc/html/latest/process/coding-assistants.html

And please clean up the wordering everywhere before submitting again.

johannes
