Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3765 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519AbXJPRPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 13:15:47 -0400
Date: Tue, 16 Oct 2007 12:58:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20071016165803.GA5677@tuxdriver.com> (sfid-20071016_181550_701552_98C933AA)
References: <1189526874.6161.30.camel@johannes.berg> <20071016005711.GA10957@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20071016005711.GA10957@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2007 at 05:57:11PM -0700, Jean Tourrilhes wrote:
> On Tue, Sep 11, 2007 at 06:07:53PM +0200, Johannes Berg wrote:
> > Hi Jean,
>=20
> 	Hi again,
>=20
> > Anyhow, the problem is that my landlord has an AP that broadcasts a=
n
> > SSID with a 0xFC byte in it (supposedly an "=FC" in windows). iwlis=
t,
> > however, just prints
> >=20
> > 		ESSID:"B
>=20
> 	You remember that problem ? Well, we now have a new version of
> Wireless Tools that support that. However, this is blocked because th=
e
> necessary kernel patch has not gone yet in the kernel.
> 	I've sent the patch to John twice, with you in cc for the last
> occurence. It seems that John for some reason does not receive e-mail
> from me, or something else. This was the last time :
> 		http://marc.info/?l=3Dlinux-wireless&m=3D119022849315111&w=3D2
> 	So, would you mind pushing yourself this patch to John ?
> 	Thanks in advance...
>=20
> 	Jean
>=20
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

Jean, you can keep whining and complaining.  But you never address
the issue of preserving the userland ABI.  Simply releasing a new,
smarter, better wireless-tools does not change the situation.

Because of the confusion in SSID handling when WEXT was defined,
WEXT is just never going to support a 32-byte SSID unless it happens
to end in a NULL.  Sorry.

I don't see how the patch you wish to revert has anything to do with
the umlaut issue.  If it does, please explain how or feel free to
propose a patch that corrects it while still preserving the userland
ABI.

John

P.S.  Please note that the userland ABI concern is not some pet issue
for me.  This comes from the community at large, including Linus,
Jeff Garzik, and other notable contributors.
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
