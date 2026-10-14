Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348650AC2C;
	Wed, 14 Oct 2026 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982551; cv=none; b=DPYIem4t+OL40m7l9gtlFaxtCOYfZc11vvvEa1sSKuTeZt2L//eXdL7k4An24nM748c6XSmerVUAvZUX8D3xmXu9u94kXAzo5mfBlKoEpE5pnS6DGbnf93P3hLB7sX4f5G7gkYiMyHOu8yXw1Bs3hz8cAQEWgpLA78vcZ7NgVQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982551; c=relaxed/simple;
	bh=/CCnmFYSzXO7rsKAhnM/B82XpebemkUwfZSROrHSshE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UzByQmcLeOW9uambvDlEfJt79GrZkHDKrIV5qSkt33pPViw1QIB4BPFFFCyPMI52HkYPs8fag3VhT6raMichsk3FLpWJa1zTbinmm5EVEeWS+0RfLOYEvfrPBn8nPYGU+IBOJ9qh7AzJhz7/jdTUSCN28FyEwt/FLxqg+oMmoSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DkKSdMNZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DkKSdMNZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/CCnmFYSzXO7rsKAhnM/B82XpebemkUwfZSROrHSshE=;
	t=1791982542; x=1793192142; b=DkKSdMNZk+DkTRLAuaB5w3m9cFybOfid2HrFS8UgglRTfzl
	cxPAIDCSMP8xQhTTdf+CGLfO53H0kcjeGxhEia2dibnTUfwpd7rZgOoSD1R/RWBFlaVOo7j/+NTcM
	pZQ7/yGihPeiNsLuF8Ypn7zuzMjy+u8r+X/Y32/PgmIcQjK2/rP46TQ7pPcm1nK8k1+sQ1387Tqj0
	TodTJafXrJOI+lUKpmf51xOIrR2HnkvBntt+4Z9htM5drbghyUo+u6A588hU70m3iKWUmO8OPZZW9
	jaOkyIdmK2FL+yqiJo+1I1azYmGw7qRsXmq53C4nJIEKOyc8rWpCnFnm6z7LDrxA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGyW9-00000001Xtv-206Y;
	Wed, 14 Oct 2026 14:55:37 +0200
Message-ID: <3d2fde6558449d82dec7c9eef8cb4c6e4e464dc8.camel@sipsolutions.net>
Subject: Re: [PATCH iwlwifi-next] wifi: iwlwifi: pcie: return a real errno
 from read_config32()
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Gaur <yogesh.gaur@intel.com>, miriam.rachel.korenblit@intel.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
Date: Wed, 14 Oct 2026 14:55:35 +0200
In-Reply-To: <20261014124357.2569535-1-yogesh.gaur@intel.com>
References: <20261014124357.2569535-1-yogesh.gaur@intel.com>
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

On Wed, 2026-10-14 at 18:13 +0530, Yogesh Gaur wrote:
> pci_read_config_dword() can also return a positive PCIBIOS_* error code
> (e.g. PCIBIOS_DEVICE_NOT_FOUND for a disconnected device), but
> iwl_trans_pcie_read_config32() passes it through unchanged and
> iwl_dump_ini_config_iter() only checks for ret < 0. The error is missed,
> so the loop keeps reading and stores 0xffffffff in the dump.
>=20
> Convert the return value with pcibios_err_to_errno().
>=20

This isn't incorrect, but is it a good idea? I'm not convinced, we might
still get some other parts of the dump vs. just aborting the entire
section at that point?

IOW, _why_ are you doing this? Do you have a problem with it? What is
that problem? Is it just a static checker/LLM complaint that you want to
fix?

johannes
