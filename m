Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABFF439F67
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735650; cv=none; b=nL22z7kZSbreDSy17okEcNmqE1/wykVjDH6cNwYgjY1mo/Bk0w7IQKG+eeWs+kRSLBQp8JWWEFr64SRbG6VQqjHB7+26hdWr1NKM8Isx6vf/zObZWbeIgDzksoX/6m+4R9s5d6AKVmJpy0+CWbBng6K8Kyh2wkfuzX6PhDSqj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735650; c=relaxed/simple;
	bh=UMRQ79v2yXtRCnJD9wL8CE8DndfEY6GMzqVfIBeapK0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mnGGQPJUwo0/GVIKnPvCQ4RS5pPz6qAhuzKgm/VM/BJpci9/Z/6lrMAauhfksB5XTtkF9lzoN5MFkPvQ1vATVmc9NVW4z/b09ijESm98+35kUocwDqpjWHiNs4oo170D31yZD4okHPcEP/iDqMbBmr2lIm4+jWUJA8DgKsM4AKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uKdGOqfr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uKdGOqfr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wORtUkuxibZxnGk6EjbUQDGPL3gg8q570y1SAxHEQQM=;
	t=1784735648; x=1785945248; b=uKdGOqfreWVddrNJDvBh3vjEdQtlM7TSS+tHk/DabQBdxfA
	7qaRvKXWzzX3+vPsNuUQ9ajOMYgbITWDFyoVituZTsv84Vjyll4Fui60sG7iRs2/ETyoBMK36QWQZ
	qfw/7kW6r6nx8bot2DcDTCnf4evt7udZ2UxJ4Uh1iyBIYADVqFUw+QAzJB7dboDjiRUxNcdIpoDH+
	q0pw6+KBZpXc9ajLP4NdBcOWF0SE7GdKW388n2dKpCaT44MBCjp5z8LJn1WU7T4d1wqTMj3hSLiv8
	31HS6teFo10kfULcmzvb4rPqelhDwAKlm1jcRzHhzVeO+PzUeTMQ5rSNn8aEA10Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmZGl-00000004rfk-0hd6;
	Wed, 22 Jul 2026 17:54:03 +0200
Message-ID: <c43276c11a6b1ad888b5ca5c3a28de199b6c2d78.camel@sipsolutions.net>
Subject: Re: pull-request: ath-next-20260721
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, jjohnson@kernel.org, Bjorn Andersson
	 <andersson@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 17:54:02 +0200
In-Reply-To: <0833afbd-4a25-4e7d-8e77-ab9fac9d36cf@oss.qualcomm.com>
References: <f73b76bb-dc27-42d0-8e47-b617eec766a6@oss.qualcomm.com>
	 <67b88a3cc68473a1ee9d2816c4b5fe07c378434f.camel@sipsolutions.net>
	 <0833afbd-4a25-4e7d-8e77-ab9fac9d36cf@oss.qualcomm.com>
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

On Wed, 2026-07-22 at 08:51 -0700, Jeff Johnson wrote:
> On 7/22/2026 7:08 AM, Johannes Berg wrote:
> > On Tue, 2026-07-21 at 16:46 -0700, Jeff Johnson wrote:
> > >=20
> > > ----------------------------------------------------------------
> > >=20
> > > NOTE TO UPSTREAM MAINTAINERS
> > > This PR includes the merge of an immutable branch from the qcom tree
> > > https://lore.kernel.org/all/178362521364.2422497.1305957434056184382.=
b4-ty@kernel.org/
> >=20
> > That's annoying, it added a kernel-doc warning that now shows up on our
> > output... I guess we need to ignore that.
> >=20
> > > New warnings added:
> > > Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found f=
or return value of 'qcom_scm_is_pas_available'
> > > Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found f=
or return value of 'qcom_scm_is_pas_available'
> > > Per-file breakdown:
> > >      2 drivers/firmware/qcom/qcom_scm.c
>=20
> :(
>=20
> I run kernel-doc on the patches I process, but since I didn't directly pr=
ocess
> that series I didn't see it.

Yeah, no worries. Also they're outside our normal set of files, so I saw
them only because of the diff, not in my normal "check everything"
process. I'm not really bothered by it, just a heads-up.

> > Note that the first of those ... the commit exists, but not in the righ=
t
> > tree. It's in some ath12k-bringup-start tag in your tree, but not in
> > mainline, got a different sha1 there. So checking locally is confusing.
>=20
> Let me rewrite those and send another PR

Thanks!

johannes
