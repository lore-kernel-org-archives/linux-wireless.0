Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DD82D7DEA
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 06:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874549; cv=none; b=YVKORxlgf62qiEiGqnbsk3XEUZQKFT69L2PJV4SzuMj3otTKYE6Ffpt7NVBidDk8+PPbvtbdFzQamxiK4n3hp/uWMYOFtkR18t2Z5ttCVmIRat5Mzo/xwcXE6KovjAE3pSz/mwwu/bYZxfsPHaxS5yN22eGeS84RXJDV2cRdi8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874549; c=relaxed/simple;
	bh=jjoJ9MBgz2S1gI59MmH+/C1Fs4fZZPeDuyhWFYdkM1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VS73y8rfJI1fhZZ5c9ASOr65JPI7Zh1tmaizumNXEkGsW1ib/XLS8//uYPhODIx3C53uqekLMjoxDRt4w2zP4oFq6tR0nKvfoOSopE2bPF3EEnB7EnS7jKnirRFjpxPqZKQQElU1AZFsmRugD1Nyo4v7kGdxKMJyKlbKIMY9RB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=jEEmq18G; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="jEEmq18G"
Received: (wp-smtpd smtp.wp.pl 29704 invoked from network); 24 Jul 2026 08:29:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784874543; bh=0BHFurq7yN4XVhu0RBZyHzuU9s3RpDn+LMYbLZ5LSNs=;
          h=From:To:Cc:Subject;
          b=jEEmq18GAGVGDkTXZMBWnKsaB7n5EywkAeXcMr6urQeNdH61qonHx7qfdOjsOBCpC
           LRWZzZuK3qVUTocGne/UeOuzYtIHxFIBbY6bNX/UN03stDDEcJXzfgpnOoOH1WFPuB
           e8tyNOHeQwBp2tSJiMsmmuLeqhhAIkDqw+2CEFUtHAdHG5CheEyjAdTP8Vk4z9A3yS
           nybhKCN9avPjQ4NtoqtZ5XMRMLLwiKO0v4cSkvWtNbXs8dg6/ua263nNqChF+AnPDm
           ATwyNRkgKmYJG5LxebgATj5f11sszVGc4r7HizygMLSmIRYJvnVwKsDkCil0jNUf8s
           iWeSJoXgW3utQ==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <rosenp@gmail.com>; 24 Jul 2026 08:29:03 +0200
Date: Fri, 24 Jul 2026 08:29:02 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: Use flexible array for
 hw_mode_spec channels
Message-ID: <20260724062902.GA2146@wp.pl>
References: <20260629033156.2363850-1-rosenp@gmail.com>
 <20260723075304.GA4577@wp.pl>
 <CAKxU2N_LbndYqrGDQ__sAjj87mj-J8Hs-RWeD90eRcGK1dDAcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKxU2N_LbndYqrGDQ__sAjj87mj-J8Hs-RWeD90eRcGK1dDAcw@mail.gmail.com>
X-WP-MailID: a13e81ad173fc5a465da57119a4cfa99
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [4dCx]                               

On Thu, Jul 23, 2026 at 12:26:41PM -0700, Rosen Penev wrote:
> On Thu, Jul 23, 2026 at 12:53 AM Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> >
> > Hi,
> >
> > On Sun, Jun 28, 2026 at 08:31:56PM -0700, Rosen Penev wrote:
> > > struct hw_mode_spec stores channel information that is allocated by the
> > > individual rt2x00 drivers during hardware probing.  The channel info
> > > array has the same lifetime as the hardware mode specification, but it
> > > is currently allocated separately and then freed through a separate
> > > pointer.
> > >
> > > Make struct rt2x00_dev hold a pointer to the hardware mode
> > > specification, store the channel info as a flexible array member, and
> > > allocate both pieces together with kzalloc_flex().
> > >
> > > Assisted-by: Codex:GPT-5.5
> > > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > > ---
> > >  .../net/wireless/ralink/rt2x00/rt2400pci.c    | 24 +++---
> > >  .../net/wireless/ralink/rt2x00/rt2500pci.c    | 55 ++++++++------
> > >  .../net/wireless/ralink/rt2x00/rt2500usb.c    | 55 ++++++++------
> > >  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 74 ++++++++++---------
> > >  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  4 +-
> > >  .../net/wireless/ralink/rt2x00/rt2x00config.c | 12 +--
> > >  .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  4 +-
> > >  drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 42 ++++++-----
> > >  drivers/net/wireless/ralink/rt2x00/rt73usb.c  | 50 +++++++------
> > >  9 files changed, 177 insertions(+), 143 deletions(-)
> >
> > This result in extra code. I do not see benefit of avoiding
> > kzalloc calls at cost of adding more lines of code.
> On runtime there's extra UBSAN analysis. Reducing allocations is always good.

No, not always. 

Sanitizes are for catching bugs, not for performance. 
Adding complexity to the driver to run faster with them
is not good idea.

Also, this is on initialization path, which done usually
once per system boot, so visible gains will be something
between zero an non-existing.

Regards
Stanislaw
