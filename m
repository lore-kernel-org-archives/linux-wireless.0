Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42091 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaLROAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 09:00:15 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so1688978wgg.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 06:00:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418910981.6134.9.camel@sipsolutions.net>
References: <1418832044-25582-1-git-send-email-arik@wizery.com> <1418910981.6134.9.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 18 Dec 2014 15:59:58 +0200
Message-ID: <CA+XVXfcT5vevfSMHoeNobjLOrzeZdO-XerEB6rLxD_6LqLfhcQ@mail.gmail.com> (sfid-20141218_150020_639459_68DD0E49)
Subject: Re: [PATCH] nl80211: increase the max number of rules in regdomain
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2014 at 3:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-12-17 at 18:00 +0200, Arik Nemtsov wrote:
>> Some network cards (Intel) produce per-channel regdomains and rely on
>> cfg80211 to merge rules as needed. This hits the max rules limit and
>> fails.
>
> Maybe we should consider just getting rid of this or bumping it to
> something ridiculously large like 1000? Looking at how this is (not)
> used, there's no real sense in limiting it. The only possible problem is
> the O(n^2) complexity when doing an intersection, but processing a
> million combinations is probably not a big deal? In fact, even if that
> becomes a problem, we can easily optimise that complexity away by
> sorting the rules or so. Then it becomes O(n log n)...

Well when someone does NL80211_CMD_GET_REG from usermode, we send the
entire regdom in a single message, so 1000 rules may become
problematic..

Arik
