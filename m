Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54144 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbeCVLs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 07:48:26 -0400
Message-ID: <1521719304.19621.8.camel@sipsolutions.net> (sfid-20180322_124900_976652_6E02F1AC)
Subject: Re: [PATCH] brcmfmac: Add timestamp to scan results report
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        dimitrysh@google.com, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com
Date: Thu, 22 Mar 2018 12:48:24 +0100
In-Reply-To: <5AB388FE.2040609@broadcom.com> (sfid-20180322_114417_668509_02BCB500)
References: <00000000000080af470567f3ef29@google.com>
         <5AB388FE.2040609@broadcom.com> (sfid-20180322_114417_668509_02BCB500)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-03-22 at 11:44 +0100, Arend van Spriel wrote:
> I recall a similar attempt for another driver, but I think the timestamp 
> should really be the TSF of the beacon/proberesp received. As you 
> already Cc-ed Johannes explicitly maybe he can clarify what is needed 
> here as I do not recall the details. ;-)

Yes, this should be "tsf", it's actually labelled explicitly as such. I
know Android used to get this wrong and *even test* it wrongly, but
that's no excuse.

However, should switch this to cfg80211_inform_bss_data() and use the
timestamp set up here to fill the cfg80211_inform_bss::boottime_ns
value. That's also sent to userspace in the proper way for this.

johannes
