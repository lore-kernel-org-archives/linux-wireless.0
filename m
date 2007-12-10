Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51196 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbXLJQD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:03:28 -0500
Subject: Re: [PATCH 14/48] libertas: fix data packet size errors
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200712101649.39391.mb@bu3sch.de>
References: <E1J1kpI-0006lF-Pz@shinybook.infradead.org>
	 <200712101649.39391.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 11:03:26 -0500
Message-Id: <1197302606.2957.40.camel@shinybook.infradead.org> (sfid-20071210_160331_238111_6DBC3D7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-12-10 at 16:49 +0100, Michael Buesch wrote:
> > +             u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
> 
> Whoops, something's wrong here.
> You are subtracting from a LE value.

It should have been le16_to_cpu(), not cpu_to_le16(). It works as it is
on all real hardware, although it makes sparse unhappy. Holger later
fixed a bunch of such things (including this one along with some _real_
errors) in patch #21.

-- 
dwmw2

