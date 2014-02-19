Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57634 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaBSWMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 17:12:03 -0500
Received: by mail-lb0-f178.google.com with SMTP id u14so749147lbd.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 14:12:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392809288.4733.15.camel@jlt4.sipsolutions.net>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
 <1392807806.4733.14.camel@jlt4.sipsolutions.net> <CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com>
 <1392809288.4733.15.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 14:11:40 -0800
Message-ID: <CAB=NE6WDvxXGT21H5-D4H3tSJ_iZufp6X05_quPpoAeaoMkOog@mail.gmail.com> (sfid-20140219_231208_306165_33F16290)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 3:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Ah ok, thanks.

Let me know if you merge this so I can apply and push the respective
patch for CRDA. Not sure if you saw but as proposed this means this
bumps the wireless-regdb format. Janusz, I see you submitted a
respective patch for iw and CRDA but not one for wireless-regdb, we'll
need one there in order to parse the new entries in db.txt.

John, this should mean we will need two releases for wireless-regdb
moving on so that older versions of CRDA can read the new rules under
the old format. Another option may be to have wireless-regdb spit out
the file in two formats and we modify the new CRDA to jump to the new
format section if it supports it. Otherwise I'm afraid we get stuck
with the latest rules for old kernels forever, or we make a branch on
wireless-regdb for the old format.

Thoughts folks?

  Luis
