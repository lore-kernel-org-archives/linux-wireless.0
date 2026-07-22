Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4283655C9;
	Wed, 22 Jul 2026 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731003; cv=none; b=juww+PmsL9yOYbPrp9JxINla8w0qaG3ASeEuBrK6/Cd6BoMovkOkz/TXWpbWLGOcZCj3BaB9iGb3K9gsuc7G9OBivQ0LKPcxA8PcJuAmbWCDlpGorX2Wkyug7RqwIRTPLTdxTcu1Y2xrmdOdbd8P9bLi7pQVMjpkPHlE6AbIpAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731003; c=relaxed/simple;
	bh=m8MOcbLnaFoQyHbktdJ8V1S0Nm7WfE1ZCB0ssjpvzSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKDkr6QvSAfF0ZGo6mUcaDMKzW0YPU1HdCsE7tEPDukSrkjFs42S7xv1LOPHaO5zR0iR1ovFCTTcOd2FcqerdX+Ajz4y5C3KMhzfoMJksTHDp0rpAMRdvdQhqYafWCL+L+lULPMnL1Y+uDr+gBOfdxmh/+jPlX16EmVB63c+Udg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 97FC5C14;
	Wed, 22 Jul 2026 16:36:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 5E7CD62749FA; Wed, 22 Jul 2026 16:36:37 +0200 (CEST)
Date: Wed, 22 Jul 2026 16:36:37 +0200
From: Lukas Wunner <lukas@wunner.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>
Subject: Re: [PATCH] PCI: Disable NoSnoop and Relaxed ordering for Intel
 wireless BE200
Message-ID: <amDVdTzCkNDuIc5c@wunner.de>
References: <20260621065451.21650-1-emmanuel.grumbach@intel.com>
 <ajecdx3HYj5rqJBZ@wunner.de>
 <9eeb29c6b7986797eec0af6c7ef42cb8c9feefd2.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eeb29c6b7986797eec0af6c7ef42cb8c9feefd2.camel@intel.com>

On Wed, Jul 22, 2026 at 11:01:40AM +0000, Grumbach, Emmanuel wrote:
> On Sun, 2026-06-21 at 10:10 +0200, Lukas Wunner wrote:
> > On Sun, Jun 21, 2026 at 09:54:51AM +0300, Emmanuel Grumbach wrote:
> > > The Intel wireless BE200 device fails to copy the TLP Attributes
> > > from a
> > > Request to the Completion.
> > > Since there is no caching involved the device anyway, disable the
> > > NoSnoop and Relaxed ordering on the root port.
> > 
> > Is there a public Specification Update which could be linked in the
> > commit message and/or code comment?
> 
> I replied to this already. Anything needed from my side?
> We'd like to allow those users to work with BE200.
> 
> Not pushing or anything, just making sure you're not waiting for me.

I guess you need an Acked-by from Bjorn, or have the patch applied
to pci.git.  I can't do either I'm afraid, but if it helps:

Reviewed-by: Lukas Wunner <lukas@wunner.de>
