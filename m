Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:44173 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760977AbXIKDu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 23:50:59 -0400
Received: by py-out-1112.google.com with SMTP id u77so2885872pyb
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2007 20:50:58 -0700 (PDT)
Message-ID: <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
Date: Tue, 11 Sep 2007 06:50:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: zd-mac80211: Fix TX status reports.
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1189422611.4506.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200709082341.31720.mb@bu3sch.de> <200709091259.00237.mb@bu3sch.de>
	 <1189421542.4506.46.camel@johannes.berg>
	 <200709101258.39619.mb@bu3sch.de>
	 <1189422611.4506.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/10/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-10 at 12:58 +0200, Michael Buesch wrote:
>
> > I think the ack callback is pretty reliable, so that should be OK.
> > It looks for the ACK in software.
>
> Right. But Uli mentioned that it can become out of sync. Is there no
> indication about how many times a packet was transmitted before it was
> acked?
>
Receiving all ACKs packets will degraded performance greatly for sure,
even on PCI interface.
Receving ACK can maybe allowed selectively only for management packets
including EAPOLS in some synchronous way, yet this is still error
prone.
It looks strange to me that there is no other HW mechanism that does that?
Is this driver reverse engineered?

However I liked the idea about

"An alternative option could be that the mac80211 stack would call
a non-atomic function of the driver to report the total count of
transmitted packets and the number of successful transmissions."

This mechanism will help us to implement aggregation rate scaling
I would actually prefer if such statistics will be pushed by driver
rather then pulled by mac though.

Thanks
Tomas

> johannes
>
>
