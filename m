Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266A3812EC;
	Thu,  4 Jun 2026 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780573345; cv=none; b=bfw3X9PlglZrveHBEaKyPyJXj7iPDaVTuFbasyP7HNxZkqGvhPalHOtbAM50eyZzQO+pCD9H99zjCAyfmGrX4IX1rmQd09gfhvxJ4HPrcSbh9JBh8cLKLBkr8wnI6E6PDC7Uc9YsFq357YHvipZtVMSQ6P2YjJ7kQf8NjC1jALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780573345; c=relaxed/simple;
	bh=0yo3Yw/4ZYw7XRfyFnMuLKDMfqiwgrraYysCoZ+tKeo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nGlpsuE7DttR0gIYo5eAf4RPHuTjIaP6Ux8xLIAXZAZPIHETucNgpuP6UGkYZDDh4A5fM6xga7X1iPURdOO0n/lTSRBmAcDkZwzjDdSFNi7Yc3cNsUDX/TG0H8IH1S3Fl1Vq28z8pEB833ohRbCqO+3grRZFP4dRiYviswqV7mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vHIsD3q2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vHIsD3q2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qf8AwuPZ9q8operZ/yX6tBkSs0E1JMvt8CpQ9d5+HXw=;
	t=1780573344; x=1781782944; b=vHIsD3q2UUNiVryFBfQgAfTk9k6fM9uY6GdETDjq0QQK6yy
	N7oEGFaXRCLanQSJF3TmGmqx0OEMEa++bYZyX6Y5zX+UqXRruPJLsh0mGQbIR10j/oDN6VrQRyhRq
	QNxIyQfqvlUcpwxpIFBHQFVky9PPfREkn38zps6Utz9MtCE2FStaePjWBDaEmCSD9exERYh7pPK1F
	FBftdnApo0HODZE2dnRokFHA8TGgpnmNcIX3ZcOsE78GMjdMvnTpTRhUL2WDZItcuQ/G04k4W5btH
	Lue9/vNt1xuRrphFRQ01IHqQp7BhQ2/nnNMfhPanD+QLVCFGFf1LU5uQ2t/yyzhA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wV6Sr-00000000Smw-3CDB;
	Thu, 04 Jun 2026 13:42:21 +0200
Message-ID: <8562865b568ac12c0c6b5568872b84970c7ecd37.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 10/31] wifi: mm81x: add hw.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>, Dan Callaghan
	 <dan.callaghan@morsemicro.com>, Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 04 Jun 2026 13:42:20 +0200
In-Reply-To: <20260430045615.334669-11-lachlan.hodges@morsemicro.com> (sfid-20260430_065729_788303_3AE5935F)
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
	 <20260430045615.334669-11-lachlan.hodges@morsemicro.com>
	 (sfid-20260430_065729_788303_3AE5935F)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-04-30 at 14:55 +1000, Lachlan Hodges wrote:
>=20
> +	*((u16 *)&mors->macaddr[0]) =3D (mac1 & MM81X_OTP_MAC_ADDR_1_MASK) >> 1=
6;
> +	*((u32 *)&mors->macaddr[2]) =3D mac2;

This is an alignment fault waiting to happen, better to build byte-by-
byte perhaps, or at least use put_unaligned_...()

johannes
