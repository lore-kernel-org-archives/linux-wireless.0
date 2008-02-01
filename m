Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:40129 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYBAUpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 15:45:36 -0500
Received: by py-out-1112.google.com with SMTP id u52so1833665pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 12:45:35 -0800 (PST)
Message-ID: <8e6f94720802011245i66a524c1j1d03a772f7477006@mail.gmail.com> (sfid-20080201_204542_412442_0D2BE232)
Date: Fri, 1 Feb 2008 15:45:35 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
Cc: "Lars Ericsson" <Lars_Ericsson@telia.com>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080129213746.790b68d2@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <479E928C.5000709@lwfinger.net>
	 <00f201c862b3$be1f00b0$0b3ca8c0@gotws1589>
	 <20080129213746.790b68d2@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 29, 2008 3:37 PM, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Tue, 29 Jan 2008 21:15:49 +0100
> "Lars Ericsson" <Lars_Ericsson@telia.com> wrote:

> > Unfortunately the rt2x00/rt61pci driver is broken in current git. I'm using
> > http://www.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git,
> > and the 'everything' branch.
> >
> > I got plenty of :
> > [ 2119.568376] WARNING: at net/mac80211/rx.c:2022 __ieee80211_rx()
>
> Could you check which one is the condition which fails at rx.c:2022, i.e.
> by inserting three separate WARN_ON(1) statements?

On my system, it is the "status->rate_idx < 0" condition.

In rt2x00lib_rxdone() we set the rate_idx to -1 because we looped
through all the rates without finding a match. This does not happen on
every frame. I am still digging.

-- 
Will Dyson
