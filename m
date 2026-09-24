Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F3A43F4C0
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236608; cv=none; b=sD46xOd3MGJ/6Fo4oEJ4WIrYZI8Lhtu7FFC9nmOmcOp0tYd+RLKT2sV4QHLzf2K1szGAsD5BZElgNocEjgpuDFYZBCvO9Mo/cxOlHDkDgVBCtJNTHj9L5H6Vp5cMtMKNOni25wYm2b6tlUU9zvuQdV9K0Zk7q2H4ObqvO6gemcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236608; c=relaxed/simple;
	bh=/TFhBRaHqGZ4NvfjtaGaeSCDvwIU976ZRm5BEDj8Fro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9dOCdKrDbEROAkbl7BJRZWgeTTZgpxmys5xictYHN9SQeu4Xwnvj8tL2OIpCs5VBw0dKERoHyF23362qvRDAF6oK1oJpD8tHIuOuUCzQzBN5jxa6y9HNxA2EnT7+1P49qq7XMyv/aj40l3TbryjsQYkZ6j6f3j7vFECcYO5fEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=C1pL3SX/; arc=none smtp.client-ip=188.68.63.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="C1pL3SX/"
Received: from mors-relay-2501.netcup.net (localhost [127.0.0.1])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4hr5kn12DMz6JX0;
	Thu, 24 Sep 2026 09:56:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1790236593;
	bh=/TFhBRaHqGZ4NvfjtaGaeSCDvwIU976ZRm5BEDj8Fro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C1pL3SX/mq8E51xRDcnRhHxkJ0HcdIpa8b9Ck65vMj722c912KjH7Jvdj1lMNQPIG
	 r50sjICcpkhHgjvX0qUCJoMEn8xiteVns9O93P/B0gG8D8ixTvuRtzdAUKoTtDR1ok
	 4zhWE74pZOxZX0BXdZjZ2AcMetMAAkQpsS2XSD643XiQsHc61HWtvW4RC10gtJZyM9
	 Z70J6BhxmbKainT0598Y55PZUsjN3dRsAm0EJrEoJyg4Q+mdQyEMTw4TGsIY8qABsF
	 SgqX2kf+2kYuno8epshSnUA792y2Edtqxp49WBKmehsYjiD80s76IH7EMjB8KWtgwx
	 ZfY7q+FLIb2VQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4hr5kn0Jdrz4ykm;
	Thu, 24 Sep 2026 09:56:33 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hr5km3Zxmz8sb3;
	Thu, 24 Sep 2026 09:56:32 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 719AF5FA13;
	Thu, 24 Sep 2026 09:56:31 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <30af27bf-202b-48fd-9b7f-b05e68757ee4@leemhuis.info>
Date: Thu, 24 Sep 2026 09:56:30 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] iwlwifi AX200 (cc-a0-77): downlink capped at HE-NSS
 1 with, firmware core24.70-49 (77.8dbafb52.0), 2x2 with 77.f39cc7f9.0
To: jiyu <yuji1899@outlook.com>, linux-wireless@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: 
 <SY8P300MB05515915C81B8D9E50D83F64DA862@SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <SY8P300MB05515915C81B8D9E50D83F64DA862@SY8P300MB0551.AUSP300.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: 
 <179023659194.4151773.10876639730678461774@mxe9fb.netcup.net>
X-NC-CID: rN8nvm6jsEq3N/dziQRynEHRpFO7X6e3hsAnmkVPOn4K9vZrTbY=

On 9/19/26 12:34, jiyu wrote:
> 
> (Please keep me in Cc - I am not subscribed to this list.)
> 
> Bug tracker entry with all logs and both firmware A/B runs: https://
> bugzilla.kernel.org/show_bug.cgi?id=222031
> 
> Summary: an Intel Wi-Fi 6 AX200 [8086:2723] (rev 1a) receives only ONE
> spatial stream on the downlink while transmitting TWO, but only with
> the newest cc-a0-77 firmware build. The kernel and the iwlwifi driver
> are unchanged between the working and the failing case - only the
> firmware blob differs, so this is not a kernel code regression; the
> same kernel (7.2.5-200.fc44) reaches full 2x2 with the previous build.
In that case you want to report this to
https://gitlab.com/kernel-firmware/linux-firmware and ask for a revert.
Please post the link to your report afterwards here.

Ciao, Thorsten
