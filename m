Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5D3DD523;
	Mon, 29 Jun 2026 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735407; cv=none; b=cAtdsAEFoUSE8oWJ57W0Gz6qflcUlz5KUUn87BUdyRamzItx80L6T8J9n+TO5iO/rw3WBCRuH4nsTRZkQ6psV/j41WSntleGfvulkWSUmxF9ODbITotUyxo0fPcEvoOwdqWdiqB1z8yMpWaqjMmlvX3eiENooZnv3+zpkA9k7V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735407; c=relaxed/simple;
	bh=OoKBP2nxz1tcc2713rBEy51AiHrW7NDjKMGULsUxOEw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zo9yCkmgJLoBEOhMSEy35I7xg6FF0HW5Bh4quNzC51NsnplVzcVdazB0WBmGYhMfUc1FprRKXvx3CkgZJzLaedH9SdeI1xL0wcYZ9LNUTrWZV1kbwqmeJ1oSH8n5djMNzsPBkoAWVm9I8q/HgQSMd7LzGtd94f9GWfm3TrIQFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QppfzPpc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QppfzPpc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OoKBP2nxz1tcc2713rBEy51AiHrW7NDjKMGULsUxOEw=;
	t=1782735404; x=1783945004; b=QppfzPpcvf1FDRUTCXxMF6dcLp0IvKlVVYMPuAxRGjk4zXm
	MvXKZTUrw5FbRVI3+aNhMDrERST6mFjEoDXRy1J5Lq5AaE/5D82+thgY0Fz+L6kMJOhIg36kRevYP
	QNuvplXHwzsoY0aEq7zxE2SK/aoculKPy5xYFUuk0T+1Fubnoha9sutKaTmGX0Yhrw427BgRX7/gx
	qSDyX3ACUk/BKuc1v1ais+ZQ/56cT2KpHfJtr3PL/kKMvUafazSLSOtkcOfmmEoYhxfcubyNfQa9k
	fVYntZbSnubP/h+wArLM0TL8s/IYAb3c+Vm6k6qQ28T2JuPTeQHPMtXZ/Kz227Kw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1weAuh-00000000BLt-2BxP;
	Mon, 29 Jun 2026 14:16:35 +0200
Message-ID: <297578c2a1293523a28896f30031db16ccd26bd0.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, 
	linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com, emmanuel.grumbach@intel.com, 
	linux-kernel@vger.kernel.org
Date: Mon, 29 Jun 2026 14:16:34 +0200
In-Reply-To: <20260629121213.597038-2-jtornosm@redhat.com>
References: <20260629121213.597038-1-jtornosm@redhat.com>
	 <20260629121213.597038-2-jtornosm@redhat.com>
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

On Mon, 2026-06-29 at 14:12 +0200, Jose Ignacio Tornos Martinez wrote:
> Re-enable MFP_CAPABLE flag in FIPS mode for iwlwifi to allow Management
> Frame Protection (802.11w) to work with mac80211 software crypto.
>=20
> Commit 0636800c8ee1 ("wifi: iwlwifi: disable certain features for
> fips_enabled") disabled MFP_CAPABLE when fips_enabled=3D1.
> I think the original concern about "some frames need to be handled in
> firmware" applies to firmware-offloaded features like WoWLAN and beacon
> protection, which remain correctly disabled by the commented commit.

No, you think wrong, this cannot be done.

johannes
