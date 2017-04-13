Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50376 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbdDMGcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 02:32:42 -0400
Message-ID: <1492065153.28255.1.camel@sipsolutions.net> (sfid-20170413_083245_593688_29397ADF)
Subject: Re: [PATCHv4 0/2] cfg80211: mac80211: BTCOEX feature support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh Chelvam Raja <c_traja@qti.qualcomm.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "tamizhchelvam@codeaurora.org" <tamizhchelvam@codeaurora.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 13 Apr 2017 08:32:33 +0200
In-Reply-To: <efe890d95d374af7b7a8839811afe0d8@aphydexm01f.ap.qualcomm.com>
References: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
         <50d867d1-740c-85b9-2bab-6ef49c4d87c1@broadcom.com>
         <efe890d95d374af7b7a8839811afe0d8@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-12 at 07:08 +0000, Tamizh Chelvam Raja wrote:
> > 
> > So you make a distinction between WMM ACs, but what about the
> > different
> > types/profiles of BT traffic?
> > 
> 
> [Tamizh] There will be BT high and BT low traffic. It will be decided
> by BT module. Firmware internally checks BT low traffic with wlan
> traffic. If we enable some of wlan frames as high priority, those
> frames will have more priority than BT low traffic.

That ("firmware internally..." etc.) really sounds more like an
argument *not* to apply this patch ...

Everyone has their favourite BT coex control. We could possibly
implement this in our driver, but I'm not sure we'd *want* to, since
it's so far from what we actually do today.

Do we really need more than toggling it on/off?

Actually, I probably should've asked this much earlier - but what use
cases do you see for this? What can a user, or userspace application
like NM, really try to set here? It seems the use cases for this would
be rather constrained?

johannes
