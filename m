Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53884 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdKMMWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 07:22:47 -0500
Message-ID: <1510575765.30497.38.camel@sipsolutions.net> (sfid-20171113_132251_089092_87BEC743)
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Date: Mon, 13 Nov 2017 13:22:45 +0100
In-Reply-To: <20171113115841.3dcrcjqnp543kndi@bars>
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
         <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
         <1510565429.30497.10.camel@sipsolutions.net>
         <20171113115841.3dcrcjqnp543kndi@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I apologize for email duplication, but it looks like reply from Vasily
> has been rejected due to Outlook issues. While we choose between mutt
> and gnus, here I briefly repeat the rationale behind these RFC patches.

:)

> The nl80211 get_beacon callback appears to be useful in the case when
> userspace software needs to retrieve current operational parameters of
> AP including HT/VHT IEs.

Do you have any usage in mind though? I can't really see where this
would really make sense, rather than getting direct hooks for the bits
you needed in hostapd.

For example, if you care about the channel bandwidth changing, wouldn't
it be more efficient to just add a signal to hostapd rather than
listening to beacon updates and parsing, etc.?

johannes
