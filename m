Received: from mx-832558f3.phiality.com (mx-832558f3.phiality.com [45.146.253.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617F548EE
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.146.253.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965305; cv=none; b=dRdKQRUH37g9MZOsB9zJnoAW07hsruo3Wsks8IPzJRCabjMUPf56OcKXgcd4O71QpbxAipbDLFlxRnWABmAC1TTxYSD00QXMAxKwgB6KuPBsFYFIgY2WKqQ+7dOscAbtZlBpiKgEk9zqvLTqR/sS4C5b92AbNc47S0QPIYgBcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965305; c=relaxed/simple;
	bh=vt6kPWsfNbucRJ/idqE2zoIvNWu7NbZIDveYTBK4mlw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ZJXhQdxTAnHfvr9pifMVdCN9nWxyys+F4QYGKShOjms4AJxJ7ylWzer+BQtU+mkxjl0Qmm0n1UoyZtXJkgsGR09S+9aGDyJcAZn1rL3pPhgPjVKD9dWt2r7jXEmm5TyikNsdE26YSk7exdNRVUGZpHHEVFsFCYm3Sp9raiu3hC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=phiality.com; spf=pass smtp.mailfrom=phiality.com; dkim=pass (2048-bit key) header.d=phiality.com header.i=@phiality.com header.b=mk3buiaJ; arc=none smtp.client-ip=45.146.253.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=phiality.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phiality.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=phiality.com header.i=@phiality.com header.b="mk3buiaJ"
Received: from webmail.phiality.com (snappymail.mailserver_default [172.18.0.5])
	by mx-832558f3.phiality.com (Postfix) with ESMTP id F191816015F;
	Tue,  9 Jun 2026 00:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=phiality.com;
	s=mail; t=1780965303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vt6kPWsfNbucRJ/idqE2zoIvNWu7NbZIDveYTBK4mlw=;
	b=mk3buiaJGwqajBqgb50psD2ryXf+m2JZZOTwPoqtnIF26ricjXx+/wpqU62j+SkNZwf2bm
	UvfYMw0MuplVSnJC0vAnrBmdRovRx7wZmumGHkbMn3+Kmr5ke597kzy9OolD4Z0QM4GUFE
	BACyY/W6gsP2dTnQMinb+p/euGifCZRY0kWTOCgqpkn3WonHDAvmvUG1xR3nqNc5kjwerG
	ts7xrH4kMaX1YZaT6rEQ/x8oEWOZE/B124BbnKPgrAc3Gt7BkTueJ6MmrbAKSsoRFhMTv5
	9AZ6cDMEFH5A0ABL6dXoQkeGM034QlD9B4YlmLBTRmJT9WQlbX7rN0MKveH6xg==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 09 Jun 2026 00:35:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Filip Bakreski" <phial@phiality.com>
Message-ID: <ba8109de16240cfcc150b90ff6b5a20fbb629671@phiality.com>
TLS-Required: No
Subject: Re: [PATCH] wifi: mt76: mt76u: use GRO on the USB RX path
To: "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc: nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
 sean.wang@mediatek.com, linux-wireless@vger.kernel.org
In-Reply-To: <aib-n_sCzWOjXFE1@lore-desk>
References: <20260608044109.31730-1-phial@phiality.com>
 <aib-n_sCzWOjXFE1@lore-desk>

> I guess we do not need to add them, we can just reuse napi_dev pointer =
and
> napi[] array available in mt76_dev struct. Agree?

Agreed, I'll drop the new mt76_usb fields and reuse dev->napi_dev and dev=
->napi[MT_RXQ_MAIN] in v2

> I guess it would be interesting verifying if threaded-napi provides bet=
ter
> results.

It does, on mt7921u a threaded NAPI servicing the RX queue averaged ~588 =
Mbit/s vs ~424 Mbit/s for the manually-driven NAPI. Suspend/resume also t=
ested clean.

v2: https://lore.kernel.org/linux-wireless/20260609003224.132191-1-phial@=
phiality.com/

Thanks for the review,
Filip
