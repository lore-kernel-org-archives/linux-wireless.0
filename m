Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37676 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1CWJkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 05:40:49 -0400
Received: by eyx24 with SMTP id 24so2079349eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 02:40:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300806782.3746.41.camel@jlt3.sipsolutions.net>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	<1300806782.3746.41.camel@jlt3.sipsolutions.net>
Date: Wed, 23 Mar 2011 11:40:47 +0200
Message-ID: <AANLkTinzRQHq8Zwvua2Zsnz2OjW4_e9L_YAkMxSwnS5j@mail.gmail.com>
Subject: Re: [RFC 0/9] add WoW support
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
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
>
as Ohad noted, we do need to be able to suspend while operating as AP
(which is possible as the beaconing is done in the fw), at least with
our model.
i can also think of use cases in which it will be useful to have a
suspended AP also in standard wowlan - like letting the ap go to sleep
while there are no clients, and waking it up on a directed probe
request.

> Back to the unsupported modes though, should those fail suspend as well?
> Currently, we simply deconfigure everything during suspend. But once we
> have a model of "the connection stays up during suspend", should we
> still silently shut down AP mode interfaces and keep the others during
> suspend? That seems inconsistent.
>
> Again, the solution might be a suspend agent that will configure the
> system in a way that suspend is possible. But how can it tell that
> suspend will be possible? Between the different possible models, there
> can be a lot of variety. We can expose those, but what will userspace do
> with the information? Do we require that it configures the device in a
> way that it can suspend, or do we do that in the drivers?

maybe we can add each trigger an additional parameter which describes
whether this
trigger is optional (when applicable) or mandatory (which will abort
the suspend if it can't
be configured)?

Eliad.
