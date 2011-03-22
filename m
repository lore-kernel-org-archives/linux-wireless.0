Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36414 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1CVPkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 11:40:31 -0400
Received: by iyb26 with SMTP id 26so7567650iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 08:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300806782.3746.41.camel@jlt3.sipsolutions.net>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com> <1300806782.3746.41.camel@jlt3.sipsolutions.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 22 Mar 2011 17:40:10 +0200
Message-ID: <AANLkTinEOK5LFQobuFVi69u3g0z1-Oy8iE1gzk6eDuQi@mail.gmail.com>
Subject: Re: [RFC 0/9] add WoW support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2011 at 5:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> In the second email, I'll gather some thoughts about userspace APIs.
>
> Regardless of how suspend works, the device may need special
> configuration (e.g. wakeup patterns [1], rekeying information or
> similar), in our case it even needs special firmware uploaded. Suspend
> might also only be possible in certain configurations, like being
> associated with exactly one AP, and not while operating as an AP, for
> example.

With TI's 12xx, we actually do want to let the host suspend itself
even when acting as an AP, because the 12xx firmware itself is
responsible for sending beacons, and responding to probe requests,
without involving the host.

So in case there's no traffic going on, the host can stay suspended
even if we have stations connected.
