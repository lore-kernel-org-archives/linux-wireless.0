Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64410 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2LMWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:53 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2265117lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:38:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net> <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:38:31 -0800
Message-ID: <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com> (sfid-20121213_233856_806470_CD62AB75)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> -       /* TODO: missing regulatory check on 80/160 bandwidth */
> +       /*
> +        * TODO: What if there are only certain 80/160/80+80 MHz channels
> +        *       allowed by the driver, or only certain combinations?
> +        *       For 40 MHz the driver can set the NO_HT40 flags, but for
> +        *       80/160 MHz and in particular 80+80 MHz this isn't really
> +        *       feasible -- should we ask the driver here?
> +        */

It'd be real odd if a card could only do certain settings but at least
from what I was told the spec did limit the required combinations to a
smaller set so technically I could see the firmware having the checks
to only allow those settings. I don't think it makes sense to add this
as a limitation that gets annotated by a flag on the driver though. I
suspect we can assume a driver that supports VHT80 will support those
combos defined on the spec and so will a card that can support VHT160
and the only restriction really should be regulatory.

  Luis
