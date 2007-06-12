Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-c.mailcontrol.com ([168.143.177.190]:60710 "EHLO
	cluster-c.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXFLOxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 10:53:22 -0400
Received: from rly06c.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly06c.srv.mailcontrol.com (MailControl) with ESMTP id l5CDxEkk014811
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 14:59:33 +0100
Received: from submission.mailcontrol.com (submission.mailcontrol.com [86.111.216.190])
	by rly06c.srv.mailcontrol.com (MailControl) id l5CDx4s2014351
	for linux-wireless@vger.kernel.org; Tue, 12 Jun 2007 14:59:04 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [RFC] {cfg,nl}80211 API
Date: Tue, 12 Jun 2007 14:58:14 +0100
Message-ID: <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI>
In-Reply-To: <20070612131458.GA6411@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net> <20070612131458.GA6411@charon.n2.diac24.net>
From: "Mark Powell" <Mark.Powell@csr.com>
To: "David Lamparter" <dl@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: "David Lamparter" <lists@diac24.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lamparter wrote:
> Hi,
>
> just for fun, I created a graph of wext->nl80211 mappings:
> http://git.spaceboyz.net/?p=nl80211/nl80211-meta.git;a=blob_plain;f=nl
> 80211-map.png;hb=865687f294a84d7847ed7a05aa63de5cbb1a0c89
> - wext stuff marked red means I have no idea what that ioctl does
> - lines marked blue mean I'm not sure whether that's correct
> - nl80211 cmds in lowercase and light green aren't outlined yet

Very interesting. It raised a question in my mind...
When associating to a WPA network, at what point should the driver open
the controlled port?
With wext/wpa_supplicant, the driver relies on knowing that the
supplicant sets the pairwise key first and group key second and can open
the controlled port after the second key.

Can we tie down the correct behaviour more tightly in cfg80211/nl80211?

thanks
Mark

-- 
Mark Powell                              mailto:Mark.Powell@csr.com
Group Leader, Host Drivers               Tel: +44 (0)1223 692000
CSR, Business Park, Cowley Road, Cambridge, CB24 0WZ, UK


To access the latest news from CSR copy this link into a web browser:  http://www.csr.com/email_sig.php

To get further information regarding CSR, please visit our Investor Relations page at http://ir.csr.com/csr/about/overview
