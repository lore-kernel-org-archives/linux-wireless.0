Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:58864 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaFKIn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:43:27 -0400
Received: by mail-la0-f53.google.com with SMTP id ty20so4681327lab.12
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402462835-3281-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1402462835-3281-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 11 Jun 2014 01:43:05 -0700
Message-ID: <CAB=NE6XB-u05fa0hO-Vxg5Gim9U0vPfLOhz+bOeB-WQ_-9THTA@mail.gmail.com> (sfid-20140611_104340_127525_8035709A)
Subject: Re: [PATCH] cfg80211: reg: setup correct alpha2 after intersection
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:00 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Setup correct alfa2 in last request after intersection.
> In other case after intersection we could not change/set
> new country using eg. iw reg set
>
> Failed scenario:
> - insmod cfg80211.ko
> - iw reg set FR
> - modprobe ath10k_pci (US hint)
> - intersection and country set as "98"
> - no way to setup new country using iw reg set
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This approach seems good to me Janusz, but I think the commit log
doesn't describe the issue precisely and I do have a few questions, so
consider this patch not yet ACKd. The reset_regdmains() will be
triggered on certain type of events, the intersection is pertinent and
valid up to the point some specific state hasn't changed on the
devices present though, for example a dissociation form AP if its a
STA. Its important that the type of hint was a user hint though --
that tells us further compliance is desired. If the ath10k_pci device
is an AP and it required a US hint the original FR hint can help with
the intersection but further events can 'reset' that originally preset
user setting for FR. FR in this case was passed as user hint and it
can be a subjective matter if we want to upkeep FR or not, that's up
to us to decide. In this case I think it does make sense to upkeep it
always -- that's why we also had cached user specific regulatory
settings into some other user alpha2 (sorry don't have a terminal
right now so just replying to the review right now, should be easy to
find). So it seems to me you were trying to preserve the userspace
original hint, why is that not being preserved, I think the
reset_regdomains() should have upkept that already.

  Luis
