Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1FCUic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 16:38:32 -0400
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com> (sfid-20110603_221849_457984_ABB91EDC)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	 <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
	 <1307108661.3800.6.camel@jlt3.sipsolutions.net>
	 <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
	 (sfid-20110603_221849_457984_ABB91EDC)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 22:38:29 +0200
Message-ID: <1307133509.3800.10.camel@jlt3.sipsolutions.net> (sfid-20110603_223835_958013_827D8EF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 17:18 -0300, Lauro Ramos Venancio wrote:

> Actually, we don't expect more than a couple of targets because of NFC
> short range.

I know.

> I agree that this can be a problem if we start supporting vicinity cards.

I have no idea what that is, but I think that you'll start adding
attributes at some point, and somebody will also build "scanners" with
better RX sensitivity ... I'd rather not design something that _right
now_ limits you to around 100 targets.

> I agree that this is a better solution. But I think we don't need a
> generation counter because only a new polling operation (start_poll
> call) can change the targets list (i.e. there is no passive polling).


> We don't need a generation counter here because we have the events
> NFC_EVENT_DEVICE_ADDED and NFC_EVENT_DEVICE_REMOVED. So, it is
> possible to keep the device list consistency listening for these
> events.

That may be true, but it complicates coding in userspace. Much easier to
check a generation counter (in both cases) to see if data is consistent
than to listen to multiple events concurrently with receiving a dump.

johannes

