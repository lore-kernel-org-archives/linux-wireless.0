Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:44359 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYKZIJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:09:37 -0500
Received: by fk-out-0910.google.com with SMTP id 18so311227fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 00:09:35 -0800 (PST)
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 09:09:10 +0100
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net
References: <200811251809.55461.helmut.schaa@gmail.com> <200811260706.03160.hs4233@mail.mn-solutions.de>
In-Reply-To: <200811260706.03160.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811260909.11175.helmut.schaa@gmail.com> (sfid-20081126_090941_376439_CD905900)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 26. November 2008 schrieb Holger Schurig:
> > The current scan timeout is set to 5 seconds. If the timeout
> > is hit because the firmware did not respond yet, the adapter
> > gets restarted, which results in a disassociation.
> 
> I have nothing against raising the timeout, but two general 
> questions.
> 
> First thing: why does the adapter get's resetted?

I guess the intention was that if the firmware does not get back within the
timeout it might have been crashed (or something similar) and thus the driver
simply restarts the card.

> Even if a  
> whole scan takes 11 seconds, the scan of one channel takes less. 
> So if results trickle in during these 11 seconds, nothing should 
> get resettet.

Right. Could do that too.

> Second thing: why should the association get's cleared if the 
> adapter get's reset?  Isn't one a (assoc) at protocol level and 
> the other (adapter) a hardware thing?

No idea!

Helmut
