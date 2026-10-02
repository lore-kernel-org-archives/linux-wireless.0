Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE533436D
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 23:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982598; cv=none; b=JLR9aE8UiOfqsuK+V0kezJ1Pn5244zs7BpeuWc4iBGeaPs8wahTWRfn+k+Gcm+v4CZ6aex6LF4/RcDoVP/2NvsGXExk6AI8BxtmukHlbZa6e9udxMcJ+yLHycJO9msbixkLLDFnOEO3kRas9GvkdYmgUwPb+v+HZ2k8xfb70slE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982598; c=relaxed/simple;
	bh=QK12jZccLedIx3puWsmURa+Mnz+5+QlcZ+mqSy18S2w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H99G82rV1ZsW8ljhj8zul3zrj4xMO/PrDgchSvjvNRn29q9BMpZpPCLOMHnCG6c/lnCee5ywCOnT+LfgQ7/QrsjdlYF+Bbd35vQZ5MrojcXthF6RtgYri/TTqcVOFYUUmOY7yyOtGOJ64SxWQyXlkSw2KAOnuC0+qSGBN4C0PTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=1w5Noen7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X02e8j4u; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="1w5Noen7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X02e8j4u"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CE40B14000F4
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 19:09:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 02 Oct 2026 19:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790982593;
	 x=1791068993; bh=/UxR25uWpM984v5kU8eNOhtzi69zPCfAweq3mLv2gYU=; b=
	1w5Noen7uOLbH/esYU+XaygzFvfL14KebIWOx8cfbS1coU2lIgSgxescrrYF2C0x
	AVIYAgDPm5FVIpsxvAv9nyqhmPB/0P5nZSWX+B1I/keUFYRyuomRb7CaLnUDdziu
	LVzwFaQn58iUF4vFkjAUg3G4w9MPm3xsPmhr7bfXPLdlv9m91JCI3u1R7EO3iAll
	t0lC51MAvLKjX2pXY+snQwOM32P90QMVM82qhpmsHm6kYIOGEcqJSDiwEfOOkbMA
	FU4D1zsIoyc1TjY/fXMEaSnrLXeEkJESO8lN4mo9h1aiwLS1J1E4zjP9pZ/zZOgC
	V5Qh1SuuIvNwxMatfVYOZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790982593; x=
	1791068993; bh=/UxR25uWpM984v5kU8eNOhtzi69zPCfAweq3mLv2gYU=; b=X
	02e8j4u5dGXA3jm2Wpb3+ON/KicSbg2Wlkrc3XrVgCTm9MxGSQw+NnifV+tkqldf
	SGoXEUkuvLStTvnfPOS5vZ9igDxqXO/nBcLGrvNqYCpISY7Ss4fIlEoVz8nHN/IO
	gThAqcu0M0Tmsf3SY8xxxnH2VYTjeZOPHj8YFLbDNbhNBRUUn5yLfEDlh/A6PbNv
	PTRL7hN2zUuZwMMxKMuTedM9XkPk/EyqcglD9H4Bs5T7LpzmmmGgfgIbnnsqZxGf
	XXBxRWw8l2LZjE0UofGz5Sp/YzRY4RREvSch6OgIIh1vdrE4b/G5yVtTvZSdmOqD
	c6gw0Q8mYTaz+g7nRf0rg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shazbot.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790982593; d=shazbot.org;
	mf=PGFsZXhAc2hhemJvdC5vcmc+;
	rt=PGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:RlZGTt1CNhRYZnzKvp+PBhMeENiJBQ52962MfP0ZiUHvbj1
	iBpo9/IMmJZ/c/1bXgfESikfC7t+IujtHgHFmhZmUlglyyZ28ZPj4C/MBN/1Cu6r
	ztPsFMgty7rlfKfsxdljIfAKeTMEL46xYZp49t4RzOoxNNKjkQEqPPmUpg5l6w6J
	gvUTvFiwtBZbRuO6dgsM+RzB+4IeGy/2/qUdT8KxJkrFvzqt4RkmZNfBr5IlVQi8
	cnIIaNC6s9k+7NhVWekAppxsohDTq5CvLGXseGekXpcgbrdvh6xVz2noy3K9pSce
	aOhrvQHdYHYcg5HMfUsT1gUpcNRPTWrvqFhHbQg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:SSOOM2bBfRc8S7PzpEaZvqUaqLe06UbPJoujimjiPug=:QK12jZccLedIx3puWsmURa+Mnz+5+QlcZ+mqSy18S2w=;
X-ME-Sender: <xms:wTnAasW6xuG7Y4fBHRRXWYqBz9C558IQPlr2DBSHe5y3W3Rie3Kwfg>
    <xme:wTnAagLDJE8h8m5WEvxXD76lvoaGU9Ln7JaYPS-jxteDHh1XZIc5HsZd28xp5XNn0
    hTO6ILO2KA3_Z_XsUzAGbg57Ix9-KztseJIcuA5GEhmhQyKfd9dtxo>
X-ME-Received: <xmr:wTnAaktnLh5XFHcCkFA1aYD_bLErD2i71T23wliERFCINsJ7ikXNZSfk0QZTGg>
X-ME-Proxy-Cause: dmFkZTG2demwP3RbOPVfbzFvVn3o14zaLPORCEz0kFecatwO4dqPywF0iI4P1elJRTYhbP
    UMttM0KAT5tUxpnf2pUHShtYc1+A6Y43HbO/4tTTbhGF3glTyq82CfSi+j2jPWq+8jBRaN
    PnEzkXQUsJ37tQ9STPTtlTt48b+JO2zlVc0z0QaToZJDr488fn3oXEhlJWgqaJCztmadUH
    RyIwXFz/CV4dX4U4zlyJwhgDQ4J+8/OW+rCJP1sR8E6RnswFnuDvD6DdqSFNt+vtc/7bRU
    Kz2q9+eorQMRRJ5r+miFne7VHXyJ9H3EaLX79lxOjc+ffH8fphwIWlNROMkrAI+pExIYRw
    tzaYvvDo7jfFrmgoAxARPMCOSkov5nLcICf5ogTusyUKkQfCIJajIxOjeXyc8Ozh5wm6Il
    XCklIGbNwg2YBc8/sIdfOMqgz3IVec7bwi7lo4su57VVikILk6QcUSNx18CNCqqRROyrFI
    lRoQq8ehkjuNlBNR4EcunAvee45Ki68vFBRfw/LgXq8wU8aaEcl2uePnBvBd8tlMr1a2/R
    z7HoIIXWcw7EyN0DS8r1KGf85p4GZzs70hwnw5ud+XUcuQa1xqgf88bKf73E4nbiA4Oaaa
    GJRYk51yADdKCyuqfxK/dpfX+tVCgPe6gCrtI5X8Y/CrMMST4kfkwln0l0og
X-ME-Proxy: <xmx:wTnAat3ckw5bYiaj_sMFQ7otJUuu5hspag_HARnNQfJRQBmUXK9eWg>
    <xmx:wTnAakMp25Ef1l4yVBw4NJRVkPV2VPG8qIN61M8yM5M0prHSsJrvLA>
    <xmx:wTnAalXYW6zR4lLJ8KbYyBM7TcrctpM2qTkUdXJA3JIRtgAeBVduCw>
    <xmx:wTnAahYamrjbxnzm-8CgHJ0rPnLBRiXd_uC3nC8e_BrIAKn7fZa0Fg>
    <xmx:wTnAavYtdcFaKuHeGai4H--OdYyC15OmyZAIH0-csTXLzRpkUnSj2j8X>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 19:09:51 -0400 (EDT)
Date: Fri, 2 Oct 2026 17:09:49 -0600
From: Alex Williamson <alex@shazbot.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, bhelgaas@google.com,
 mani@kernel.org, jjohnson@kernel.org, linux-pci@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, mhi@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 alex@shazbot.org
Subject: Re: [PATCH v14 0/2] PCI: Add device-specific reset for Qualcomm
 devices
Message-ID: <20261002170949.59c3d47a@shazbot.org>
In-Reply-To: <20261002214058.GA284603@bhelgaas>
References: <20260917071651.14174-1-jtornosm@redhat.com>
	<20261002214058.GA284603@bhelgaas>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Oct 2026 16:40:58 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [cc->to: Alex, +cc Jason]
> 
> On Thu, Sep 17, 2026 at 09:16:49AM +0200, Jose Ignacio Tornos Martinez wrote:
> > Some Qualcomm PCIe devices (WCN6855, WCN7850 WLAN; SDX62/SDX65 modems)
> > lack working reset methods for VFIO passthrough scenarios. These devices
> > have no FLR capability, advertise NoSoftRst+ (blocking PM reset), and have
> > broken bus reset (addressed by quirk_no_bus_reset, merged for v7.2).  
> 
> Specifically, 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm
> WCN6855/WCN7850 WiFi, SDX62/SDX65 modems").  I don't know what the
> behavior was prior to that commit.  I suppose it was something
> obvious?
> 
> > VFIO attempts to reset devices on every reassignment:
> > - For the listed modems, without a proper reset capability, these devices
> > never successfully initialize even on first VM assignment.
> > - For the listed WLAN devices, without a working reset method, the attempt
> > fails. On clean VM shutdown, the guest driver properly deinitializes the
> > device via .shutdown/.remove callbacks, leaving it in a usable state despite
> > the failed reset. However, on unclean VM termination (crash, force-off), the
> > guest driver callbacks are not triggered, the device remains in an undefined
> > state (DMA active, interrupts enabled, etc.), and without a working reset it
> > cannot be reused.  
> 
> So IIUC, prior to these patches, these devices were functional when
> passed through to several successive guests as long as the guests shut
> down cleanly, but the resets done by VFIO didn't work, so the host
> couldn't enforce isolation between those guests.
> 
> If true, I propose updating the commit logs to emphasize the lack of
> isolation and de-emphasize the VM clean shutdown vs crash behavior,
> e.g.:
> 
>   Resets of this device always failed prior to this commit, so VFIO on
>   the host could not enforce isolation between successive passthrough
>   users.
> 
>   If a guest driver deinitialized the device, it may have been
>   functional if passed through to a subsequent guest, despite the lack
>   of isolation.  Otherwise the device may have been left in an
>   undefined state (e.g., DMA and interrupts active) and unusable.
> 
> It would also be great to have Alex's ack here.

Yes, aiui it's an isolation and repeatability issue.  In fact, without
knowing what's actually stored in the hardware, I'd suspect it's more
the latter and the testing proves that.  Mani is really the one
vouching for it from the hardware, isolation perspective.

Standard reset methods have never worked on these devices and that's
now evident by the quirks that disable them for these devices.  This
fills the remaining gap by providing device specific resets for the same
hardware.

Both patches should properly reference the quirk_no_bus_reset commit,
but otherwise these look correct, afaict.

Acked-by: Alex Williamson <alex@shazbot.org>

Thanks,
Alex
 
> > Add device-specific reset methods using BAR-space hardware reset registers
> > that exist in these devices:
> > 
> >   Patch 1: SDX62/SDX65 modem reset via MHI SoC reset
> >   Patch 2: WCN6855/WCN7850 WLAN reset via SoC global reset
> > 
> > These are true hardware reset mechanisms (not power management or firmware
> > error recovery), providing proper device reset for VFIO scenarios.
> > 
> > Testing shows stable operation over 100+ VM crash/reset cycles. Device-
> > specific reset is position #1 in the reset hierarchy, so these devices
> > will use hardware reset as their primary reset method.
> > 
> > Jose Ignacio Tornos Martinez (2):
> >   PCI: Add device-specific reset for Qualcomm SDX62/SDX65 modems
> >   PCI: Add device-specific reset for Qualcomm WCN6855/WCN7850 WLAN
> > 
> >  drivers/pci/quirks.c | 116 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 116 insertions(+)
> > 
> > ---
> > v14: Address Bjorn Helgaas feedback:
> >   - Split WLAN and modem resets into two separate patches
> >   - Clarify commit message for WLAN devices: VFIO resets on every
> >     reassignment, clean shutdown leaves device in usable state via
> >     driver callbacks, but unclean termination is where the lack of reset
> >     is critical
> >   - No code changes from v13, only patch split and commit message
> >     clarification (Mani's Reviewed-by retained)
> > v13: https://lore.kernel.org/all/20260915223634.GA878346@bhelgaas/
> > 
> > --
> > 2.54.0
> >   

