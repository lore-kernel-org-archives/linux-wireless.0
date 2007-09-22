Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47494
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXIVOsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 10:48:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Please pull 'z1211' branch of wireless-2.6
Date: Sat, 22 Sep 2007 16:47:45 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070919181005.GB5483@tuxdriver.com> <200709221411.12128.mb@bu3sch.de> <20070922144254.GB12907@deine-taler.de>
In-Reply-To: <20070922144254.GB12907@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709221647.45715.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 September 2007, Ulrich Kunitz wrote:
> Michael Buesch wrote:
> 
> > On Saturday 22 September 2007 11:48:00 Ulrich Kunitz wrote:
> > > A real high-quality driver will require Johannes' proposed
> > > mac80211 driver interface changes to be merged and TX
> > > confirmations handled in a way, that the semantics can really be
> > > supported by the driver. (Michael Buesh's patch is taping over the
> > > issue.)
> > 
> > No it is not. It is fixing the issue. It fixes the following issues:
> 
> > * You must ignore the Txstat-requested bit in the driver.
> 
> If that is really the case the flag should be removed from
> mac80211. There is no way for somebody looking at the code to know
> this.

It is used internally in mac80211.

> > * You must report bad frames with the excessive_retries set.
> 
> All bad frames or only those with actual excessive retries? Your patch
> set the excessive_retries flag for packets that couldn't be
> transmitted to the device because of an USB error. If the flag
> should be set for all kinds of errors it should be renamed.

Well, there is no better flag to set, currently.
