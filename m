Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54089 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZKTLov (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 06:44:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
Date: Fri, 20 Nov 2009 12:44:49 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Oncaphillis <oncaphillis@snafu.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200911201212.19588.mb@bu3sch.de> <200911201238.08005.florian@openwrt.org>
In-Reply-To: <200911201238.08005.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911201244.51138.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 November 2009 12:38:07 Florian Fainelli wrote:
> Why not call once random_ether_addr instead of using some kind of hash? Is it 
> because you
> want the same MAC from a reboot to another?

yes.

> Ok, so for BCM63xx I would no longer have to declare my SPROM, fine.

No you still need to do that. The sprom is device specific.
You need to call ssb_register_sprom_override() from the arch code with
that callback that sets up your sprom image.

-- 
Greetings, Michael.
