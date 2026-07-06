Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818933148BF;
	Mon,  6 Jul 2026 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334397; cv=none; b=CjgLb85CYJGq0MGrGNwUG9OKEWLIIbA8HBBs/TTOuvb3/8nwmyrKqQbdL1+FODv0gbXbQaUWQQym+PHopciEKrY1xhjvzrsuS2VhVnQB+sUjauqjid8FVNrhG3iDC2Cao1PffXR4NfCcx4uMdYllq/goeg2TEO/3IhcGBM1hWvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334397; c=relaxed/simple;
	bh=Z61jGkp5iFcPQET9lNUJyKDn6inWB8ly1nt4Sljy5WQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GxSEZZR+K4MG4TkUOhQioBHzNvm0Tscqn2R/181Z9/eFA2sRaiGbx2RUYYtIP7tNMKyz6qemaF/H2qdeM1enZznOHaFXFAtGY42/GLixK9T/vguuOPSJRWqA0/4v4eXYccF0gsD8Agkw6uJL2zYlF7su9Ra9kACqtRLn1NUFwXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=A+jsS6/h; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="A+jsS6/h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Z61jGkp5iFcPQET9lNUJyKDn6inWB8ly1nt4Sljy5WQ=;
	t=1783334396; x=1784543996; b=A+jsS6/h3JqwK6+ZV9DXmxoxaEcwN/qM6hlxmri7m+4LvPR
	ey3iE4exlQOQzcS0I08bqA2qEplZfiaMi1CRK3v3UKX8x4Zg8BNg49JQU0tSfZmjB4ayFAxTcMZQX
	Cj6T2qCXSx9cMlHfWcwNK21mCBmrmPBEdiGYZPVr7HwZRqhjn8dgKVhkeUDcd90B6Ivb/tLlp7XCV
	pfZAd17v/SCZszeNympfQuh7yuYXa3vjZRSreiiGzr4FukZo+sqEyV8OEtNbfBm0owlU7/IZ6DJGZ
	rLVFIuSgi/YyPXzVKCcGkh3jozSCr1i8xKJvCgeInqbopoJgxUZm6+V4A38g1Ywg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wggjx-0000000D66y-1Qic;
	Mon, 06 Jul 2026 12:39:53 +0200
Message-ID: <c967e7897f421fde56ca4367c9e10d0c6d9f7ec4.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] wifi: cfg80211: validate assoc response length
 before status and IE access
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Jul 2026 12:39:52 +0200
In-Reply-To: <20260612185042.66260-5-enderaoelyther@gmail.com>
References: <20260612185042.66260-4-enderaoelyther@gmail.com>
	 <20260612185042.66260-5-enderaoelyther@gmail.com>
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

On Sat, 2026-06-13 at 02:50 +0800, Zhao Li wrote:
> cfg80211_rx_assoc_resp() initialises the status and response-IE fields
> of cfg80211_connect_resp_params from the management frame before
> proving that the frame is long enough for those offsets. S1G and
> regular association responses also have different IE offsets, but the
> S1G path only patched resp_ie after the unsafe initialiser had already
> run.

What makes you claim "unsafe"?

johannes
