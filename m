Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1DKOxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 10:53:53 -0400
Subject: RE: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Anantha Idapalapati <aidapalapati@nvidia.com>
Cc: "olofj@chromium.org" <olofj@chromium.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Uday Raval <uraval@nvidia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andy Ritger <ARitger@nvidia.com>,
	Rakesh Kumar <krakesh@nvidia.com>
In-Reply-To: <108BD5B22FBF9E46BD793DEDBF92B7056CF1A54FD2@BGMAIL02.nvidia.com>
References: <1302532426-12846-1-git-send-email-aidapalapati@nvidia.com>
	 <1302532734.6487.12.camel@jlt3.sipsolutions.net>
	 <108BD5B22FBF9E46BD793DEDBF92B7056CF1A54FD2@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:53:49 +0200
Message-ID: <1302533629.6487.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-11 at 20:15 +0530, Anantha Idapalapati wrote:
> Initially it was written specific to BCM4329. But because of the
> reason most of the BT chips have similar switch on/off sequence, this
> driver is made generic. If there is any specific changes required for
> a particular platform, this driver can be taken as reference.

Well, so, it still has bcm4329 all over the code, so you should get rid
of that and just call it rfkill_gpio or something. Also, if it's all
this generic, then how about you make an rfkill GPIO driver that works
like the rfkill regulator driver we recently got?

johannes

