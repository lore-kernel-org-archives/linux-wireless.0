Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B43241225;
	Tue, 30 Jun 2026 07:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782804336; cv=none; b=rmadKHvz7IzpwOHxPac0hvY5Sx5JuwJldH2x82UZr6xlvqZiYDlwHT1A8Uw/zLhviBRFOESxS5bFWFhf7JLLQns2/y4dAFPudx1Fh2RVfcngMJruFhj43kdZ23qdu8+2tn/nX3UQYmrj7zrZbV1K/J+d9jr+yHVvyPp8wfd2kFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782804336; c=relaxed/simple;
	bh=WvhxqOiusRfFAMqN0hegOJIEbSbrtZDw9h2KJZtuHV8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RWPMTQyVGDjxW3Xl1pqjN5o8w+P+Rh5DcGqQafRbSFPTu8iE9A43Sss0YP5jvTGcem+c4oHIGtJzeqzw7FzgBN0+gUBlt98GSRqmtxhTebikDG0o6iapncjtrQHRwIQi4G83TB5wxUP8HnQA70dVVmtSBfKlTQys23jipLt2IK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Yau9jqaR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Yau9jqaR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WvhxqOiusRfFAMqN0hegOJIEbSbrtZDw9h2KJZtuHV8=;
	t=1782804334; x=1784013934; b=Yau9jqaR9nqamEnCozVwSPqSSQL5QpnPn+HDM89a3jnuElu
	VgDKB1M1Zx5tMykXF2MjlLdzCZ7T5uA/l3L1MfEod0BoOKwedzjRojyo+Xwi0lHyJOmACOsl2kV2s
	l8EvGVcpZJUnSyNp52x9VVhbNvR+vyMUBKhrZJyVgoOL7hAd0xqiOm1a5Le8qFNlAI6sHQ1u6o2kU
	5nWab6fHsMxDmAwEDB3x+NGVtWnrPGtT3a5Hyf4aDL+uRgcYe/LbjDuUTEOC0+s+iuJ+wKQ8jZNQK
	Eva4EH0Mb+Nr2pTf2JOVHJHsZEDe9bG6EpGzAqaZGlqBr5nfFMuYACkXNPtNRG5w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1weSqZ-00000003OF2-1mo4;
	Tue, 30 Jun 2026 09:25:31 +0200
Message-ID: <a9578988af110a0966cd2bd236e6044ac5e7a70e.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: emmanuel.grumbach@intel.com, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com
Date: Tue, 30 Jun 2026 09:25:29 +0200
In-Reply-To: <20260630072046.201393-1-jtornosm@redhat.com>
References: 
	<588f665e6c1e8a24d6cee56762ae754f39ab9703.camel@sipsolutions.net>
	 <20260630072046.201393-1-jtornosm@redhat.com>
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

On Tue, 2026-06-30 at 09:20 +0200, Jose Ignacio Tornos Martinez wrote:
> Hi Johannes,
>=20
> > There's probably something to be said for the second patch anyway.
> Good to know, should I resend patch 2/2 separately, or would you like me
> to wait until I have the customer use case information?

I think we can just take it as-is.

johannes
