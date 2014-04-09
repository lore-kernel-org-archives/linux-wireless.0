Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39999 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaDINtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:49:43 -0400
Received: by mail-pd0-f175.google.com with SMTP id x10so2474895pdj.20
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:49:43 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
In-Reply-To: <1397029770.4964.2.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 09 Apr 2014 09:49:30 +0200")
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	<1397029770.4964.2.camel@jlt4.sipsolutions.net>
Date: Wed, 09 Apr 2014 21:49:34 +0800
Message-ID: <877g6yfw9d.fsf@gmail.com> (sfid-20140409_154947_340073_5BADBF77)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 09:49:30 +0200, Johannes Berg wrote:
> I don't like those last four patches, I'd rather have more includes than
> rely on other headers including headers that we need - that could change
> after all.

And if the change causes compile to fail(or generate warnings), it can
be found immediately and be fixed, but duplicate including could _hide_
problems, that's not good.

That's why we have `make includecheck`. But I make this change by my
bare hand, since `make includecheck` doesn't report any problems to
cfg80211 / mac80211.

>
> johannes
