Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB163AE194;
	Mon,  7 Sep 2026 06:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762674; cv=none; b=b9ZmUBE9IaoRp3/tve9uouRBU9D6p96VFRRlufXLcjHHuzR+8KroZdHyOMEOTJa0zcRkf1h2k9Yky5VAZmvNYtZHCgcpP8gIS1Y8ucKmOQJy1T1sehtD6df4jY8o58RJ0Ts0mvg00dLyhxZlAgemlvkLQHr//frCnOQCIwdQW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762674; c=relaxed/simple;
	bh=oPI5dlqcbplDbVLpYxfwS1vk1MKfBLp2yvJkz6prFSw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tx0ZUGksADyZ8NRdgDY525zqImTBFJtP2y14NHDaPlMwWSKStS9UL+nwFCb5kOSdw9fRXqLxrVIM29girUyfmA27rbw5LsaoJkSysDi7V8JQc8bKlQvyJwcIZ6P+FWbQggXUpiLTa4D8NPWxFrB/sfLD3nLORE0SNhhRyAS02VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AY7UuHC5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AY7UuHC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oPI5dlqcbplDbVLpYxfwS1vk1MKfBLp2yvJkz6prFSw=;
	t=1788762670; x=1789972270; b=AY7UuHC5/asf4vI/UHKyJhKE04Zwy4dwqRBK7lFlOWR23wQ
	eiSezzNSz3yrAKerJygKANasaMDc23TjRvG5LT8IeXsjhfwZiY520k+cogjj/RDTTdImOsNyvsig3
	BswXP8dvmh2gb18RDIZ54/Og/mOxmbBs+2rym1q+KW/wRy+9+o6bY7BDY5tuR1q+xkdeGaLNXk33q
	j42YiX+TCYXj+b284j9i3OgAbftLQHkWOx+EK6PPva+FgnEfqDSyoCZBU/AdSW+cdf1+XUK7knerp
	b7FT1Nmmk8ee8OFroRMr+y+5J7/pwsv2twGQAQe4vgu7Q+ZjBjD52Lk7OhytbYkA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3Sse-00000004Jzo-36An;
	Mon, 07 Sep 2026 08:31:01 +0200
Message-ID: <60a8acf1adc0d2acc5c558c4cc791d01421f6b92.camel@sipsolutions.net>
Subject: Re: [PATCH wireless v2 1/3] wifi: iwlwifi: pcie: don't infer CSME
 presence from a failed read
From: Johannes Berg <johannes@sipsolutions.net>
To: Navon John Lukose <navonjohnlukose@gmail.com>, 
	linux-wireless@vger.kernel.org, Miri Korenblit
	 <miriam.rachel.korenblit@intel.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Emmanuel Grumbach	
 <emmanuel.grumbach@intel.com>, Nika Krasnova <nika@nikableh.moe>, Mark
 Pearson	 <mpearson-lenovo@squebb.ca>, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 07 Sep 2026 08:30:59 +0200
In-Reply-To: <20260906230022.148733-1-navonjohnlukose@gmail.com> (sfid-20260907_010041_495523_B0CD5EA1)
References: <20260831130332.323549-1-navonjohnlukose@gmail.com>
	 <20260831130332.323549-2-navonjohnlukose@gmail.com>
	 <20260901154828.GA1879052@bhelgaas> <20260901161736.GA1883420@bhelgaas>
	 <1a2c11d47b27dfd8a246300ac158d25cef5abf35.camel@sipsolutions.net>
	 <20260906230022.148733-1-navonjohnlukose@gmail.com>
	 (sfid-20260907_010041_495523_B0CD5EA1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-07 at 04:30 +0530, Navon John Lukose wrote:
> On Tue, 2026-09-01 at 19:02 +0200, Johannes Berg wrote:
> > I believe the hardware itself never generates ~0, so yes, it probably
> > should use that.
>=20
> I'll switch the tests this series adds to PCI_POSSIBLE_ERROR(); drv.c and
> trans.c already include linux/pci.h. There's no non-PCI transport to
> worry about: Kconfig depends on PCI, and iwl_trans_ops went away in
> 0d91a2bfc3dc.
>=20
> I'd be more careful with the helper itself. iwl_trans_pcie_read_mem() and
> its _no_grab variant run it over dwords they're copying out of SRAM, and
> ~0 is a value the driver writes as data (FW_CTXT_INVALID fills unused
> binding and quota slots). iwl_dump_ini_dbgi_sram_iter() is the sharp
> case: it gives up on a single hit, so one all-ones dword fails a whole
> region. I haven't seen it happen, it's just what the value means.
> Widening the helper and taking the SRAM paths off it would work, but
> that's more churn than belongs here. Your call.
>=20
> Separately, the test at the top of iwl_pcie_irq_handler() (rx.c:1948)
> looks unreachable: inta has just been masked with at most
> CSR_INI_SET_MASK (0xBA00008F). I'd move it above the mask, unless you'd
> rather drop it. I'll send that and the PCI_POSSIBLE_ERROR() conversions
> separately.
>=20

I'm not your remote prompt engineer, so as far as I'm concerned this
thread ends here.

johannes
