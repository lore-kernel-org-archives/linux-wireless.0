Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33596 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYKZHGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 02:06:18 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 07:06:03 +0000
Cc: Helmut Schaa <helmut.schaa@googlemail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	ipw2100-devel@lists.sourceforge.net
References: <200811251809.55461.helmut.schaa@gmail.com>
In-Reply-To: <200811251809.55461.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811260706.03160.hs4233@mail.mn-solutions.de> (sfid-20081126_080628_884055_BA358FA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The current scan timeout is set to 5 seconds. If the timeout
> is hit because the firmware did not respond yet, the adapter
> gets restarted, which results in a disassociation.

I have nothing against raising the timeout, but two general 
questions.

First thing: why does the adapter get's resetted?  Even if a 
whole scan takes 11 seconds, the scan of one channel takes less. 
So if results trickle in during these 11 seconds, nothing should 
get resettet.

Second thing: why should the association get's cleared if the 
adapter get's reset?  Isn't one a (assoc) at protocol level and 
the other (adapter) a hardware thing?

