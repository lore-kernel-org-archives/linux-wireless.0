Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38050 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZEOPAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 11:00:11 -0400
Date: Fri, 15 May 2009 10:46:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ken Lewis <kennylewis@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
	linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: Regression: 2.6.30-rc5 and rt2x00 / rt2500pci
Message-ID: <20090515144628.GE2773@tuxdriver.com>
References: <5a44caba0905150740n3bf90e05i17a74e82f35edcf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5a44caba0905150740n3bf90e05i17a74e82f35edcf4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 03:40:44PM +0100, Ken Lewis wrote:
> I've been looking for a bug in Linux-Next that makes my rt2500pci
> wireless card unusable.  When testing 2.6.30-rc5, I saw the following
> bug while trying to associate with a WPA-PSK encrypted access point.
> It's a regression over 2.6.30-rc4 and I'm trying to git-bisect my way
> to the source of the problem.  I think that a problem in the same area
> is stopping my card from associating when using a kernel from
> linux-next also.

Please apply this patch:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/0002-mac80211-avoid-NULL-ptr-deref-when-finding-max_rate.patch

A pull request was sent to Dave M. a couple of days ago.  I imagine
that it will make its way to Linus shortly.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
