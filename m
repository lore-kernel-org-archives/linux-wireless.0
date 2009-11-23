Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58888 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZKWL3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:29:11 -0500
Date: Mon, 23 Nov 2009 12:29:16 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mwl8k: split driver by chipset
Message-ID: <20091123112916.GT20214@mail.wantstofly.org>
References: <1258931158.12095.33.camel@localhost.localdomain> <20091123110211.GS20214@mail.wantstofly.org> <1258974789.7094.162.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258974789.7094.162.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 12:13:09PM +0100, Johannes Berg wrote:

> > I was wondering if we should really make the support for each chip a
> > different kernel module as you did in your patch, but then I figured
> > that this might be a good way to let the user choose whether to load
> > AP or STA firmware if we have both available, which was still one of
> > the unsolved problems.  I.e., make mwl8366_ap and mwl8366_sta, and
> > then let the user choose which one to load.  Or is there a better way
> > of doing this?
> 
> Try to load both at probe() time (via the async firmware loading
> interface that I fixed up recently [1], that patch will be in .33), and
> hang on to the firmware images [2]. Register the wiphy with appropriate
> bits depending on which firmware files you found (and fail + unbind if
> you didn't find any, cf. my ar9170 patch [3]). Then you can upload the
> right firmware depending on the type of interface the user is adding.

This has the problem that e.g. if someone creates a STA interface first,
and we load the STA firmware image in response to that, and then creates
an additional AP interface, we'd have reload the chip while there's
still an active interface (the original STA one), which seems somewhat
involved.  Just rejecting the second add_interface() seems undesirable,
as then the outcome of two add_interface() calls will depend on their
order.

(AP firmware supports both AP and STA interfaces, but e.g. it doesn't
do STA power save and such.)

It'll also have some consequences if there are monitor interfaces, as
e.g. STA firmware allows fine-grained control over the receive filter,
while the AP firmware does not.
