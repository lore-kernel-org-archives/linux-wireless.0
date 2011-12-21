Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LUPOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:14:16 -0500
Subject: Re: [PATCH] atheros: force endian checks on atheros wireless
 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1324465840.2182.198.camel@cumari> (sfid-20111221_121047_806730_87573FD9)
References: <1324408728-20300-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1324465840.2182.198.camel@cumari> (sfid-20111221_121047_806730_87573FD9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 16:14:09 +0100
Message-ID: <1324480449.3401.7.camel@jlt3.sipsolutions.net> (sfid-20111221_161419_782389_88DA8ACD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-21 at 13:10 +0200, Luciano Coelho wrote:

> >  ath-$(CONFIG_ATH_DEBUG) += debug.o
> > +ccflags-y += -D__CHECK_ENDIAN__
> 
> Doesn't this force everyone who compiles the modules (even
> non-developers) to have sparse installed? Is it really what we want?

No. It just forces everyone who does use sparse to also use it for
endian checks. I do the same in all code I maintain, take a look :-)

johannes

