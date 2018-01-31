Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58224 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbeAaWAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 17:00:02 -0500
Message-ID: <1517436000.28814.3.camel@sipsolutions.net> (sfid-20180131_230013_410448_00624CB9)
Subject: Re: [RFC v3 0/6] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 23:00:00 +0100
In-Reply-To: <20180131213329.25322-1-denkenz@gmail.com> (sfid-20180131_223342_909055_336D73F4)
References: <20180131213329.25322-1-denkenz@gmail.com>
         (sfid-20180131_223342_909055_336D73F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks pretty good! Some comments over in separate emails.

Maybe you should consider reordering:

[1/6] keep
[2/6] keep
[3/6] introduce TX (now patch 5)
[4/6] introduce RX (now patch 3)
      modify this to require TX from the driver in order to be able to
      set the new flag
[5/6] add TX to mac80211
[6/6] add RX to mac80211 and set the flag

Ok, you don't really have to do that, since you only set the flag in
the last patch anyway, but that'd make it better to add the check that
requires TX, so you don't have to do that in the TX patch and modify
the RX portion again.

johannes
