Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YlWhji/n"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB5FCE
	for <linux-wireless@vger.kernel.org>; Tue, 12 Dec 2023 01:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=AKAoD3uDMz34onWlzxNrICjDI79e/wHhbjx2C9z6ckg=;
	t=1702373978; x=1703583578; b=YlWhji/nNRb2JsEuksytXA1xQgC4bUMZ3gpvGeJx+NJ4ZpW
	cVbg3nHhGHrI5ot7CMg53WX5Vs1lY+Y3xIom2R2UfeaI7+jk5m8XbkcbA6X/doEtct4zh5qbX0LPE
	MDkWaIVDlxV5iGkPgFY6Z2QcPuK3UVXI9a/aUigDyiZXEz4XvoePOiy/uvBZ/WrUsi/A03NhF88+i
	iHiSXuP5WYj6BlJtFWxSx1OVaqHjFLjfjbJyPXrS6pTeN59jkCaWzDjH6nf/xu8i2iErulhDse2Ln
	hDiyfuRYikR2RtxpJ3WtbPc5OyZcGcfZupnGM2j95H60GO7xPyapXfXf9ljArP7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1rCzEk-000000084CH-3QL3;
	Tue, 12 Dec 2023 10:39:35 +0100
Message-ID: <71ab1f7295860699713a018c69503f63d903a0be.camel@sipsolutions.net>
Subject: Re: [PATCH 06/14] wifi: cfg80211: Update the default DSCP-to-UP
 mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>, Gregory
	Greenman <gregory.greenman@intel.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 12 Dec 2023 10:39:33 +0100
In-Reply-To: <20231211085121.8a1c7d1f0034.I50aed38be78ae9aea052938e2cb6b5800010ecd4@changeid>
References: <20231211070532.2458539-1-miriam.rachel.korenblit@intel.com>
	 <20231211085121.8a1c7d1f0034.I50aed38be78ae9aea052938e2cb6b5800010ecd4@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 (3.50.2-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

>=20
> The default DSCP-to-UP mapping method defined in RFC8325
> applied to packets marked per recommendations in RFC4594 and
> destined to 802.11 WLAN clients will yield a number of inconsistent
> QoS mappings.
>=20
> To handle this, modify the mapping of specific DSCP values for
> which the default mapping will create inconsistencies, based on
> the recommendations in section 4 in RFC8325.
>=20

This breaks ap_qosmap_default_acm ap_qosmap_default test cases.

How should we handle that?

johannes
