Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F40D34CFC7
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769517720; cv=none; b=Ke+wTtkMpBgCcFxrpsKa0urkvN56HM1RR0OcvPZaZlRTRRElHBK2mqu3ndjlewjxz6tfw4PVpCE1WjHafi9xEuvL9eGZjAEaaSA0rn9vLrkR2eA8IiGPfbGVA2F9+mTAVQut8zcwLelvSv1fT0Zh7vqr69LmgDYsGpTTSRrfjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769517720; c=relaxed/simple;
	bh=MfbzAJU8CG1RcGAh/0ELndGBS75i4StAK8TMv++NjDw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gh04snO4vCBvJHiVWqLFbpbfghBuBrNqt+6UP1gLMcgEmpUzJvwga90KAtzQHmtbCj3KfwIejFibsLs00jk1HlugzzxfO4yBOHRMC01sUngHfG+p/Pt1cQi70dr6cb3e+PQzpxqdMm+Ud8csfmNE9FmfaqGV3jrz3vrlVdba3I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vU94pbU7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vU94pbU7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MfbzAJU8CG1RcGAh/0ELndGBS75i4StAK8TMv++NjDw=;
	t=1769517719; x=1770727319; b=vU94pbU7xrwN8DVWcPHMwsOdFRkRHZm4IizqRqXMWjr3BjC
	KZH+bta3+svXBwsTQwB/lGJfnPEdqGpt3Ad9v4tbyDo7/GHFqENWcBWxGZqkzWEoKqbHLQhXL40GR
	MnVXleHDBiqjwwR0SYOWYMyDvVaMJ2aB7U3GtMHOR/NNqAE/0q020UI2Ue8cdWEWmu2Irg1PSpaPd
	wzy3mecACJe0lVS0KbFoFJp4YGcYOAkXhPL+2VgfP6qHk8QpGwojPb79XCd9yJL97BYlEpd0IVkvE
	p1wh7aYVj4Y/MBmbMLc/pOf+rhFNaQrMaGoRLVzny1/SwwxyZlEQDhom5hNyaH9g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vkiOJ-00000004zS1-2ecH;
	Tue, 27 Jan 2026 13:41:56 +0100
Message-ID: <b2effd37d943394d415ba314222f399ad1579a9d.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 1/4] wifi: nl80211/cfg80211: add new FTM
 capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Date: Tue, 27 Jan 2026 13:41:54 +0100
In-Reply-To: <20260111190221.bf43785c18f6.Ic98cf9790ddee84bf88e5720b93c46c23af3c96c@changeid> (sfid-20260111_180413_591356_7AA889E1)
References: <20260111170351.2093318-1-miriam.rachel.korenblit@intel.com>
	 <20260111190221.bf43785c18f6.Ic98cf9790ddee84bf88e5720b93c46c23af3c96c@changeid>
	 (sfid-20260111_180413_591356_7AA889E1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-01-11 at 19:03 +0200, Miri Korenblit wrote:
> From: Avraham Stern <avraham.stern@intel.com>
>=20
> Add new capabilities to the PMSR FTM capabilities list. The new
> capabilities include 6 GHz support, supported number of spatial streams
> and supported number of LTF repetitions.
>=20
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Tested-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
> tested: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>

"tested:" is not a customary tag, I've edited that out.

johannes
