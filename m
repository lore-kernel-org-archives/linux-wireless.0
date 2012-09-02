Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50759 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2IBWxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 18:53:35 -0400
Received: by wgbdr13 with SMTP id dr13so4118745wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 15:53:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] carl9170: connect to 11w protected networks
Date: Mon, 3 Sep 2012 00:53:28 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <E1T89yV-0007Cn-JT@debian64.localnet> <1346622503.10113.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346622503.10113.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209030053.28945.chunkeey@googlemail.com> (sfid-20120903_005339_298225_E1D95A50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 September 2012 23:48:23 Johannes Berg wrote:
> On Sun, 2012-09-02 at 14:25 +0200, Christian Lamparter wrote:
> > Previously, it was not possible to connect to
> > networks which requires 11w to be supported by
> > the stations.
> > 
> > While the documentation hints that there's some
> > hardware support for offloading MFP "decryption",
> > this simple implementation relies on the mac80211
> > stack to do the actual crypto operations.
> 
> Maybe we need to clarify the documentation...

Something like a special section about converting
drivers of legacy devices like this one, or more
general?

> The problem with MFP is that now unicast management frames are encrypted
> with CCMP. If the device has HW crypto on RX or TX, it may not implement
> it correctly due to the different header munging needed for management
> frames over data frames.

understood.

> You should verify that unicast management frames are properly encrypted
> and decrypted by the hardware (or punted to software on RX like you do
> on TX). The danger is that the hardware corrupts CCMP encrypted RX mgmt
> frames and software can't recover.
At least for AR9170, there's a bit which tells the
hardware not do decrypt any management frames: 
	AR9170_MAC_ENCRYPTION_MGMT_RX_SOFTWARE

Of course, this 'very' patch sets it. Also,
in case of carl9170, it was easy to verify as
the device can easily establish BA sessions with
the 11w ap and the action mgmt frames are
properly encrypted on both sides.

Regards,
	Chr
