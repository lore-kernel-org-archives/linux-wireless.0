Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:37874 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXFLRbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 13:31:22 -0400
Received: from rly38d.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly38d.srv.mailcontrol.com (MailControl) with ESMTP id l5CH2Swl029379
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 18:02:51 +0100
Received: from submission.mailcontrol.com (submission.mailcontrol.com [86.111.216.190])
	by rly38d.srv.mailcontrol.com (MailControl) id l5CH1XqW026454
	for linux-wireless@vger.kernel.org; Tue, 12 Jun 2007 18:01:33 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [RFC] {cfg,nl}80211 API
Date: Tue, 12 Jun 2007 18:01:24 +0100
Message-ID: <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
In-Reply-To: <200706120945.41154.flamingice@sourmilk.net>
References: <20070611230434.GA13221@charon.n2.diac24.net> <20070612131458.GA6411@charon.n2.diac24.net> <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI> <200706120945.41154.flamingice@sourmilk.net>
From: "Mark Powell" <Mark.Powell@csr.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Cc: "David Lamparter" <dl@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"David Lamparter" <lists@diac24.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Michael Wu [mailto:flamingice@sourmilk.net] 
> Sent: 12 June 2007 17:46
> To: Mark Powell
> Cc: David Lamparter; Johannes Berg; David Lamparter; Dan 
> Williams; linux-wireless
> Subject: Re: [RFC] {cfg,nl}80211 API
> 
> On Tuesday 12 June 2007 06:58, Mark Powell wrote:
> > Very interesting. It raised a question in my mind...
> > When associating to a WPA network, at what point should the driver 
> > open the controlled port?
> > With wext/wpa_supplicant, the driver relies on knowing that the 
> > supplicant sets the pairwise key first and group key second and can 
> > open the controlled port after the second key.
> >
> > Can we tie down the correct behaviour more tightly in 
> cfg80211/nl80211?
> >
> Shouldn't wpa_supplicant know when the connection is ready? 
> It has support for dormant mode, so the link can be held down 
> by userspace until it is ready. 
> The driver shouldn't need to figure out when the link is 
> ready to go up.

This is to do with the operation of the "Controlled Port" as specified
by 802.1x, which is handled by the driver. When the key exchanges are
complete and the link is secure, then data is allowed to flow. With
wext, the driver has to guess when this state is reached, based on
knowledge of how wpa_supplicant uses wext.

Mark


To access the latest news from CSR copy this link into a web browser:  http://www.csr.com/email_sig.php

To get further information regarding CSR, please visit our Investor Relations page at http://ir.csr.com/csr/about/overview
