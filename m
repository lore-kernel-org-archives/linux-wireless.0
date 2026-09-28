Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE87B374A14;
	Mon, 28 Sep 2026 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576741; cv=none; b=IEpy/E3p8GQu64CLExlo3BwehRJEYDctkhEMRPHvhsv1otelUOqRRam9tQigfWYoP0n4wQL1QZLrG1d1Umv5QAy+f5U5jWByLaFhFbVCuEUXUoZdAgV296KKqspDPpwErDUfWlRxFsmXywbM5hptPToBOyGqsaumhDgY4zDjVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576741; c=relaxed/simple;
	bh=yK8SkxVrTjAHp9UslPmSuszj7WECzvfTU7WphPliP2M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CEiCfdh6+365mGea65VtgjJniiwbDXn5G8wUM6ih/xvg6jAnHzCvonurCiOj4Ehy87wZu0/CZtQC0SWJhg+Elgyz9o/4bWjZQFKpEmbe2EUgujiwkyLfqnYapJQpTZFpmfnZgR9Wae45xQLIQ1oKpsYDl9NILuoKmCpxq3ym6sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TTjoskBw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TTjoskBw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yK8SkxVrTjAHp9UslPmSuszj7WECzvfTU7WphPliP2M=;
	t=1790576738; x=1791786338; b=TTjoskBwSYcAVZQVTxORHFfSqtiJ040BmZ06NhO4+Rq1owf
	MhaPa5aYde1DXSXTbk1x5VmzVxcMiDg6LMrxa5DZ6y8Z1pq9/ungc2Yix9R+OkOsQD348AUmP5Bqu
	dzK9ePbHsFX2ysNjzQdXYijAt4pG71tpxtQWUO8HlgDo7CNhIdSoM2Sxz7v5FoIqSvzowkg9OrO9w
	Qe3dimUVxpxY7KNabrJdrGRLvel0Z3as0kfzyTTAZ1ygza7pK/yR9UC2l8fJVOADnzxiPhf59d9fG
	ftRz9+/6rJI24dZ6Ulsovj8hx26OGU1G+TzJ1UInJnIX1//qMmDpCPQmMoh5xlsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xB4no-0000000DHx1-3fEl;
	Mon, 28 Sep 2026 08:25:29 +0200
Message-ID: <2e378b6615ef4022a62989f6501018e689e5993a.camel@sipsolutions.net>
Subject: Re: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org"	 <linux-kernel@vger.kernel.org>, Michael
 Straube <straube.linux@gmail.com>,  Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>
Date: Mon, 28 Sep 2026 08:25:27 +0200
In-Reply-To: <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
	 <20260921154347.82317-4-luka.gejak@linux.dev>
	 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
	 <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
	 <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
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

On Thu, 2026-09-24 at 03:11 +0000, Ping-Ke Shih wrote:
>=20
> Can you reuse the existing since they are the same?
>=20

For the record, if you find yourself arguing with an LLM (which is
clearly the case here) then feel free to just drop the patches - clearly
the submitter hasn't even bothered to understand them.

johannes
