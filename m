Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2AXH3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 02:29:53 -0500
Date: Tue, 24 Jan 2012 08:29:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
Message-ID: <20120124072946.GB2420@redhat.com> (sfid-20120124_083009_216657_2F3B1229)
References: <4F040FEA.3080703@01019freenet.de>
 <1408490.qSFZVkU7fA@helmutmobil.site>
 <4F0562DF.3000200@dualc.maya.org>
 <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
 <4F0AEBAB.9020104@01019freenet.de>
 <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
 <201201100803.q0A83nsQ003757@mail.maya.org>
 <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
 <201201200730.q0K7U0oj004966@mail.maya.org>
 <CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 02:29:08PM +0100, Helmut Schaa wrote:
> On Fri, Jan 20, 2012 at 8:29 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
> > All in one: Your workaround was a good idea, but unfortunately it
> > doesn't "solve" / workaround the problem introduced with the patch
> > "mac80211: retry sending failed BAR frames later instead of tearing
> > down aggr" [1]. I don't know off any other solution at this time as to revert it.
> 
> Ok, so we've got at least one hw issue here: rt2800 is not able to report
> correct ACK state of BARs :(

Whould it help, if rt2800 driver will not filter out BAR frames?

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..20418be 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1205,8 +1205,7 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PSPOLL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR,
-			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
 			   !(filter_flags & FIF_CONTROL));
 	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);


