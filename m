Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f198.google.com ([209.85.210.198]:64346 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGYTVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 15:21:46 -0400
Received: by yxe36 with SMTP id 36so1234541yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 12:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248513231.32151.60.camel@johannes.local>
References: <1248461132.1216.53.camel@rc-desk> <1248513231.32151.60.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 25 Jul 2009 12:21:26 -0700
Message-ID: <43e72e890907251221rdf7d247yc81d7bc7cb23f255@mail.gmail.com>
Subject: Re: new lockdep warning in 2.6.31-rc3-wl
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 25, 2009 at 2:13 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Obviously 3) is my favourite solution, not only because it's the only
> one that seems feasible at all, but it's somewhat more complex, and I
> don't really have time to do that today.

Hm yeah this seems very appealing, it should be noted that this is
called *very* often too right now because we call this for every
beacon. If we want to merge beacon hint and 11d stuff with the added
advantage to make new functionality available to cfg80211 it would
seem then to make sense to add some sort of beacon parser so we can
extend it later if needed.

But can fullmac cards send full beacon stuff somehow to cfg80211? Can
they send 11d stuff or would they have to try to build one? Or can
they realistically only send alpha2 stuff?

  Luis
