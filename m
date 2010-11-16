Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:56685 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab0KPQxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:53:17 -0500
Date: Tue, 16 Nov 2010 17:53:02 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Message-ID: <20101116165302.GA29570@sig21.net>
References: <201011131911.47346.IvDoorn@gmail.com>
 <201011161711.51581.helmut.schaa@googlemail.com>
 <20101116163434.GA29414@sig21.net>
 <201011161742.08503.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011161742.08503.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 05:42:08PM +0100, Helmut Schaa wrote:
> Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> > 
> > Hm, yes, rt2x00mac_conf_tx() has the same issue that it calls
> > rt2x00queue_get_queue() with an argument which is a mac80211 AC,
> > but expects an enum data_queue_qid.  So one could says one
> > bug cancels the other out.
> 
> Right. We could of course add a mac80211-queue <-> rt2x00-queue mapping in
> the appropriate places or rename the QID_* identifiers accordingly. Not sure
> if it's worth it ...

Hm, reducing confusion enhances maintainability.

> > > And btw. queue 0 is used for managment frames as well.
> > 
> > Queue 0 means QID_AC_BE?  Or AC_VI?
> 
> It's AC_VO.

Ah, right got it now.  This explains the output of
/sys/kernel/debug/ieee80211/phy0/rt2800usb/queue/queue,
qid 0 is used by management frames and queue 2 for BE data.


Thanks,
Johannes
