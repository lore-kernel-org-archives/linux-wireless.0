Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0083.outbound.protection.outlook.com ([104.47.38.83]:7072
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752474AbdKMMBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 07:01:08 -0500
Date: Mon, 13 Nov 2017 15:00:55 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
Message-ID: <20171113115841.3dcrcjqnp543kndi@bars> (sfid-20171113_130115_478997_A32F3796)
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
 <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
 <1510565429.30497.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510565429.30497.10.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes and all,

> > From: Vasily Ulyanov <vulyanov@quantenna.com>
> >
> > Notify user-space listeners about beacon data change.
> 
> What would this be needed for, and why couldn't you just directly talk
> to hostapd/wpa_s?

I apologize for email duplication, but it looks like reply from Vasily
has been rejected due to Outlook issues. While we choose between mutt
and gnus, here I briefly repeat the rationale behind these RFC patches.

The nl80211 get_beacon callback appears to be useful in the case when
userspace software needs to retrieve current operational parameters of
AP including HT/VHT IEs. In fact we considered two implementation options:
to implement this functionality either in hostapd (extending its
hostapd_cli interface) or in kernel (adding nl80211 call).

We decided to try nl80211 since there was a stub for NL80211_CMD_GET_BEACON
operation. Beacon change notifier was introduced due to the following reason:
if anyone is interested in AP operational params, then he might be also
interested to know when those params are changed.

Regards,
Sergey
