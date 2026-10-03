Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29116388869;
	Sat,  3 Oct 2026 19:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791055659; cv=none; b=sBlF6bnHcCgOgqxM8z4w3FVWHvZkia8pkb/5KxDYNTOdoMusuX+AsF184Cw8hYKrk8yhgKlcElKEJ5YYidzsKNE4N3Qbw4Wc4N0zeCUclFCRgawysELa+O1IrEoRkF32pW0aSZG2RKTxEKRqq5PnaE83x18QZTLtxATor+T8yv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791055659; c=relaxed/simple;
	bh=/Ge3J85o1/ztGJsGkkYj8SQaqi42y2pRzpCgssFGbUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PpBfUvgnoNw4eTbfkrJEPAu6z9H2xOzMqtvxLDfVaNUhNe6nvdRh5+liEzyUn0DJsDb5TPi5t85o2+FGxIo/tuT8xWXnlvoJ2ygyC2henFYATHLgNUlH6Gw+hHqwxjFrfW/EpWS3bmmJQmskdIr+SJ9GQ6gI/uRUNampKn3xlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qvX5wW48; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qvX5wW48"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/Ge3J85o1/ztGJsGkkYj8SQaqi42y2pRzpCgssFGbUg=;
	t=1791055656; x=1792265256; b=qvX5wW48IdHe8V2xc0iGwHltazskgiwULS3/0myEhIt0a+/
	k9bEWshXwhIc1KfepIOrp5pZRK4/xzMR4B3SiU+zu3ebqnG05QvehTn23uQEZkve8Mg0px4BTzF7f
	5JR24PVffvwsDkcvgqGX9+Uwh82ZQEyJ6xMZWQE2SIkDgJVbZLpilLyZd0FbaOFUMPs9OxRPXU0s4
	1ey4TQ3CMiMMwOHyjQx8HRcu0xVsCR/z1k5g2SzahKmrzsnGL7TaHknNJCsQz1QSVEK9T4YVLuMyM
	Q/uAhCBoA1CsV6WvZJ8JF7O8MQx9LGel5xgpuXL2XpADGQEpRFfIvzAUb971o8GQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xD5OJ-00000002wPU-3lBf;
	Sat, 03 Oct 2026 21:27:28 +0200
Message-ID: <fee55129b41fe578c1a58a6181f1e9a775032480.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: nxpwifi: fail the firmware download on a
 poll timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Mehltretter <kmehltretter@gmail.com>, Jeff Chen
 <jeff.chen_1@nxp.com>,  Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 03 Oct 2026 21:27:27 +0200
In-Reply-To: <20261003192256.78255-1-kmehltretter@gmail.com> (sfid-20261003_212304_062454_B2A5A628)
References: <20261003192256.78255-1-kmehltretter@gmail.com>
	 (sfid-20261003_212304_062454_B2A5A628)
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

On Sat, 2026-10-03 at 21:22 +0200, Karl Mehltretter wrote:
> nxpwifi_sdio_poll_card_status() returns the result of the last register
> read when the requested status bits never show up. That read succeeded,
> so a timeout is reported as success.
>=20
> nxpwifi_prog_fw_w_helper() therefore skips its "poll status timeout"
> branch on a timeout. With an emulated SDIO card that never gets ready,
> the driver logs "FW download complete (0 bytes)" and gives up 30 seconds
> later with "FW failed to be active in time".
>=20
> Return -ETIMEDOUT when the poll runs out of tries. mwifiex, which this
> function was derived from, returns an error in the same place.
>=20
> Noticed while looking at a clang -Wconditional-uninitialized warning on
> this return statement. Tested only in QEMU with an SDIO card model
> written for this test, not on real hardware.
>=20
> Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
> Assisted-by: LLM
>=20

Don't let LLMs write commit messages, they suck at it.

johannes
