Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYB1CcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 21:32:00 -0500
Subject: Re: [PATCH, take 2] libertas: implement SSID scanning for
	SIOCSIWSCAN
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200802261522.05676.hs4233@mail.mn-solutions.de>
References: <200802261522.05676.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 21:28:37 -0500
Message-Id: <1204165717.26788.1.camel@localhost.localdomain> (sfid-20080228_023212_414955_A1F92D99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-26 at 15:22 +0100, Holger Schurig wrote:
> libertas: implement SSID scanning for SIOCSIWSCAN
> 
> After my bit scan re-writing the SIOCSIWSCAN wext ioctl no longer supported
> scanning for a specific SSID. However, wpa_supplicant is a possible user of
> this ioctl, so here is code that add's this.
> 
> While passing, removed even more of the debugfs-based scanning. You can (and
> should) the SIOCSIWSCAN to ask for scans, so there is no need for
> proprietary interfaces for scanning. And, besides, the scan result couldn't
> be used further, e.g. not for associating.

Was going to test this; but it doesn't apply to either libertas-2.6 or
to wireless-2.6/everything.  Which branch is it a diff from?

Also, should we still be targeting libertas-2.6 or just go straight to
Linville since Woodhouse seems to have gone quiet for a bit?  If he has,
we should probably get Linville to pull the latest from libertas-2.6
since there's a few good cleanups in there (the should_deauth_infra()
return value for one).  Then send further patches to wireless-2.6 until
woodhouse shows up again.

Dan


