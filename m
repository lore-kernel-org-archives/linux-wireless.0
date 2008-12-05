Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-1718.google.com ([74.125.44.157]:35578 "EHLO
	yx-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYLEFcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 00:32:50 -0500
Received: by yx-out-1718.google.com with SMTP id 4so1889520yxp.14
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 21:32:48 -0800 (PST)
Message-ID: <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com> (sfid-20081205_063254_599614_49FFD2E2)
Date: Thu, 4 Dec 2008 21:32:48 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan E" <trg_info@mailhaven.com>
Subject: Re: CRDA question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228454249.2652.1288380409@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228454249.2652.1288380409@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 4, 2008 at 9:17 PM, Dan E <trg_info@mailhaven.com> wrote:
> What is the purpose of the "intersect" program in CRDA? It builds but it
> doesn't seem to be used anywhere.

We use it to check to see if we have to update the world regulatory
domain. You run intersect against the regulatory.bin for example to
get the intersection of all regulatory domains.

> I also notice the CRDA source has its
> own nl80211.h header file, as does the source tree for "iw". Shouldn't
> userspace tools just include the sanitized kernel header from the
> standard gcc include-file locations? Having multiple copies (and
> versions) of nl80211.h everywhere seems like a bad idea.

Yes and no.

We keep the latest header in crda and iw so we can get it to compile
to work with the latest stuff, even if you don't have support for the
new stuff on your old kernel.

So although iw and crda are built with support for the shiny new stuff
the kernel netlink messages which apply to the new stuff simply won't
work. This lets you have, for example, an iw and crda for 2.6.28 and
still have it working in case you want to test drive wireless-testing
(which as stuff for 2.6.29) or compat-wireless (which has
wireless-testing stuff backported).

> Will CRDA work with AP mode? That's where my primary interest lies (I'm
> writing a new driver for an as-yet unsupported chipset). I can see the
> usefulness of CRDA in a laptop. I have a much harder time seeing the
> benefit of a 250K application to process 3,000 bytes of data
> (regulatory.bin) in an embedded AP context where filesystem space is at
> a premium.

Would you prefer that being duplicated in kernel space by each driver?
That's sort of what we had before. Each driver had their own
regulatory solution.

  Luis
