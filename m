Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35175 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1ATJOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:14:54 -0500
Received: by fxm20 with SMTP id 20so338435fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 01:14:53 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
Date: Thu, 20 Jan 2011 10:13:08 +0100
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>, kvalo@adurom.com
References: <20110104234745.25309.72030.stgit@fate.lan> <201101192122.25282.chunkeey@googlemail.com> <20110120101606.53052h18mlpyp8w0@hayate.sektori.org>
In-Reply-To: <20110120101606.53052h18mlpyp8w0@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101201013.09222.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 20. Januar 2011 schrieb Jussi Kivilinna:
> Quoting Christian Lamparter <chunkeey@googlemail.com>:
> > True, but a recent discussion into this matter have made parts of the
> > API you are planning to use sort-of "deprecated"? [I think?]
> >
> > http://marc.info/?l=linux-wireless&m=129463297300480
> >
> > I don't know the exact details, but I'm sure Kvalo does have his reasons.
> > [afaik it has to do with wl12xx, he even explained it once, but I can't
> > find that mail anymore].
> >
> 
> What I understood from that thread is that rt2x00/usb doesn't have HW  
> buffering and doesn't enable IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING  
> (rt2x00/pci does), and yet enables AP-mode. Driver has this comment:
> 	/*
> 	 * Initialize all hw fields.
> 	 *
> 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING unless we are
> 	 * capable of sending the buffered frames out after the DTIM
> 	 * transmission using rt2x00lib_beacondone. This will send out
> 	 * multicast and broadcast traffic immediately instead of buffering it
> 	 * infinitly and thus dropping it after some time.
> 	 */

Yep, your interpretation is correct. Multi- and broadcast buffering in mac80211
will stay, but only if your device is able to send them out in a timely manner,
which rt2x00 usb devices are not.

Helmut
