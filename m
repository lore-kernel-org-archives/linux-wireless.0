Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40132 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbeDEH7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 03:59:36 -0400
Message-ID: <1522915172.7140.1.camel@sipsolutions.net> (sfid-20180405_095946_180786_CEE7361E)
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Steve deRosier <derosier@gmail.com>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Date: Thu, 05 Apr 2018 09:59:32 +0200
In-Reply-To: <5AC5D33F.4090100@broadcom.com> (sfid-20180405_094200_504747_90E0C585)
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
         <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
         <5AC5D33F.4090100@broadcom.com> (sfid-20180405_094200_504747_90E0C585)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-05 at 09:41 +0200, Arend van Spriel wrote:
> 
> So for a full-mac device or a mac80211 device with certain offloads 
> (that we may already have, eg. 4way-hs offloads) you could keep up the 
> connection for a while, but if it is receiving data it probably wants to 
> wake-up the host at some point. So if such a device has means to do a 
> host wake-up you could keep the connection upon suspend. You could 
> consider such behavior a wowlan trigger as well and extend that.

There's the "any" trigger that might be appropriate for that, or a
"disconnect" trigger.

But I'm basically thinking the same as Steve - if you're never going to
wake up the host, there's not really much point in keeping the
connection, and if you only suspend briefly like e.g. on Android then
you probably *do* want to wake up the host for pretty much everything
that's going on (hence the "any" trigger).

johannes
