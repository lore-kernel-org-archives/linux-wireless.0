Received: from mx-832558f3.phiality.com (mx-832558f3.phiality.com [45.146.253.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A928372662
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 10:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.146.253.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781002638; cv=none; b=NfdEMObuomXIVzNbGEFtGSt48Z4d1qL/p+OPUViHVzByTVP4ormnS51321dD2byrWnU6wx6VpfK9u7QuiowlApYPLvHcobk/SeBkOKh8FjGLJEnEQ6c0gSnpq32Mbut5apM5U44CrrOeCQlkBPdzDdmypuoL+lAiwKU8g477No8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781002638; c=relaxed/simple;
	bh=5GGOsStKNuUwhHyumdt4xOGiL7yAZGtpcI+rDluTEcg=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=EUU1gXEbs2KYuQk2O9bzjpjqx0w0O3W06N0lmDIxokyDV3YqX5tLwk/n+yk2iIwQfRcwyUdAnsZlw+LqBT5aZOi4rK685xy2eQ2ulGO+5yL5JskAmx37UHovI17etbEF9T8+7atlpemFC8QPNCw8wRbHBMO9bf3UckuOSDglRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=phiality.com; spf=pass smtp.mailfrom=phiality.com; dkim=pass (2048-bit key) header.d=phiality.com header.i=@phiality.com header.b=q7poJfGQ; arc=none smtp.client-ip=45.146.253.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=phiality.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phiality.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=phiality.com header.i=@phiality.com header.b="q7poJfGQ"
Received: from webmail.phiality.com (snappymail.mailserver_default [172.18.0.5])
	by mx-832558f3.phiality.com (Postfix) with ESMTP id 0ECCE1601C1;
	Tue,  9 Jun 2026 10:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=phiality.com;
	s=mail; t=1781002635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5GGOsStKNuUwhHyumdt4xOGiL7yAZGtpcI+rDluTEcg=;
	b=q7poJfGQDNl8jODEAbkJVweYmE/g1prm7pNCAPUF1H1ZsI+HwWRyiUZ8HesE+QUruuc2BL
	gsp/CoApJYBBaXupDuC/ysJytrfqNnTJ9pwVCYdkNxw7fMbMqLreizHxES6kEOlB1VIWP+
	6k6y9Kd9N+IZAyBzMlC/fyDmQQ4NCRZqRPHJMFkUlYV0kw2OAg1kGizKZDIGYoYVSvrxG3
	q+68CwIBXRtxBYn94DrVh65OI/3coDl/9g4zLTHWw8bToIk9DvRABoXQT/mvrU3OnsBvuN
	maZotwkF54GBmQnTPAVKYeMocCy1tnxdWYy797ahAOMbtVhhnDZwZiwFPvQSuw==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 09 Jun 2026 10:57:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Phiality" <phial@phiality.com>
Message-ID: <72ccc65de49d2321abc25fcf7ba9b2071300f0bf@phiality.com>
TLS-Required: No
Subject: Re: [PATCH v2] wifi: mt76: mt76u: use a threaded NAPI for the RX
 path
To: "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc: nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
 sean.wang@mediatek.com, linux-wireless@vger.kernel.org
In-Reply-To: <aifg0WOxWD6x7no4@lore-desk>
References: <20260609003224.132191-1-phial@phiality.com>
 <aifg0WOxWD6x7no4@lore-desk>

> I guess the patch is fine, just a couple of nits inline.

Patch updated in v3 to address the nits,
https://lore.kernel.org/linux-wireless/20260609105301.196302-1-phial@phia=
lity.com/

Cheers,
Filip
