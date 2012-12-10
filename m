Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2LJLbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 06:31:35 -0500
Message-ID: <1355139107.9857.15.camel@jlt4.sipsolutions.net> (sfid-20121210_123138_450793_9508E19D)
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60gHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 12:31:47 +0100
In-Reply-To: <1424987.QUc2GD1qWX@lx-vladimir>
References: <8774585.BvFN3Opv12@lx-vladimir>
	 <1573921.0GjqNuABMd@lx-vladimir>
	 <1355134918.9857.9.camel@jlt4.sipsolutions.net>
	 <1424987.QUc2GD1qWX@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 13:09 +0200, Vladimir Kondratiev wrote:
> On Monday, December 10, 2012 11:21:58 AM Johannes Berg wrote:
> > On Mon, 2012-12-10 at 11:45 +0200, Vladimir Kondratiev wrote:
> > 
> > > For the 60gHz band, regulation defined in the "Etsi En 302 567"
> > > http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html
> > 
> > > +country AD:
> > > +        # 60 gHz band channels 1-4, ref: Etsi En 302 567
> > > +        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> > > +        (57240 - 65880 @ 2160), (N/A, 25)
> > 
> > There doesn't seem to be a bandwidth limitation in the rules, should we
> > really put one into the database?
> Yes, there is no limit and I'd want to remove bandwidth, but I don't see
> how to do so. If I simply omit '@ 2160', I am getting error from db2bin.py:

Right. I have this patch as work in progress:

http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=commitdiff;h=ec6e761bc0eb2471cda223431207b34af36f2b28

which would allow having no limit in the kernel, but the scripts here
would need to be updated to use it and allow the omission (or doing @N/A
or so)

Also, now looking closer, does the kernel understand the two rules with
different TX power/outdoor restriction properly?

johannes

