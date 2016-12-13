Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50486 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934106AbcLMQMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:12:01 -0500
Message-ID: <1481645519.20412.37.camel@sipsolutions.net> (sfid-20161213_171211_643192_18B6BF23)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <balrogg@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 17:11:59 +0100
In-Reply-To: <CAOq732K88CygXBmDfGmU21AcQHurcWx081Q3SM-b0ecm+848gA@mail.gmail.com> (sfid-20161128_190608_203783_0078941B)
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
         <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com>
         <1480344479.8107.60.camel@sipsolutions.net>
         <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com>
         <1480347358.8107.65.camel@sipsolutions.net>
         <CAOq732K88CygXBmDfGmU21AcQHurcWx081Q3SM-b0ecm+848gA@mail.gmail.com>
         (sfid-20161128_190608_203783_0078941B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I wasn't clear: nl80211 sets the thresholds so that "high" is higher
> than last known value and "low" is lower than last known value, also
> the distance is at least 2 x hysteresis.  There's no purpose for
> reporting "middle" rssi events because we have to set a new range as
> soon as we receive a high or a low event.  I realize I need to
> document better.

But there can be a delay between reporting and reprogramming, and if
during that time a new event could be reported? I guess it doesn't
matter much if we assume that upon reprogramming the driver will always
report a new event if the current value falls outside the new range
(either high or low)... it just seemed a little bit more consistent to
unconditionally report a new event at the beginning, even if that new
event is "yup - falling into the middle of your range now".

johannes
