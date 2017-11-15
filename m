Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0075.outbound.protection.outlook.com ([104.47.34.75]:21301
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758467AbdKOPf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 10:35:58 -0500
Date: Wed, 15 Nov 2017 18:35:49 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Marianna Carrera <mcarrera@quantenna.com>
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
Message-ID: <20171115153547.kkunkrfcivoqcsq2@bars> (sfid-20171115_163802_668121_02AD2A80)
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
 <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
 <1510565429.30497.10.camel@sipsolutions.net>
 <20171113115841.3dcrcjqnp543kndi@bars>
 <1510575765.30497.38.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510575765.30497.38.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

> > The nl80211 get_beacon callback appears to be useful in the case when
> > userspace software needs to retrieve current operational parameters of
> > AP including HT/VHT IEs.
> 
> Do you have any usage in mind though? I can't really see where this
> would really make sense, rather than getting direct hooks for the bits
> you needed in hostapd.
> 
> For example, if you care about the channel bandwidth changing, wouldn't
> it be more efficient to just add a signal to hostapd rather than
> listening to beacon updates and parsing, etc.?

In our case, we are experimenting with applications running along with
hostapd and enabling band steering and client roaming functionality.
As I mentioned, various approaches are being examined, including
both pure nl80211-based approach as well as adding direct hooks
to hostapd.

Regards,
Sergey
