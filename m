Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdJSGHw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 02:07:52 -0400
Subject: Re: [PATCH] wil6210: disallow changing RSN in beacon change
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>, Jouni Malinen <j@w1.fi>
References: <20171017194253.10212-1-johannes@sipsolutions.net>
 <18712cc3-3c69-ff9a-e64b-a988463d1965@codeaurora.org>
 <1508321623.2674.11.camel@sipsolutions.net>
From: Lior David <liord@codeaurora.org>
Message-ID: <a13235cf-a738-7d9f-38a7-cac61b322215@codeaurora.org> (sfid-20171019_080756_056117_1E221D78)
Date: Thu, 19 Oct 2017 09:07:47 +0300
MIME-Version: 1.0
In-Reply-To: <1508321623.2674.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/18/2017 1:13 PM, Johannes Berg wrote:
....
>> hostapd uses change_beacon to change the security of the AP so this
>> needs to be supported. 
> 
> I didn't think this made sense - Jouni? Does hostapd kick off all
> stations in this case?
> 
>> We do need to restart the AP in this case which will
>> disconnect existing clients, but this cannot be helped...
> 
> Why not restart the AP entirely then from userspace? Hmm. I wonder what
> would happen with mac80211 - I guess keys would have to removed etc?
> Does this just work by accident because mac80211 removes the keys with
> stations? What about GTK(s) though?
> 
Not sure what happens when the privacy stays the same (secure) but keys
change, maybe Jouni can comment.

>> As a side note, hostapd can also use change_beacon to change the
>> SSID.
> 
> When does that happen?
By chance I worked on a WPS certification test last week which used
a shell script to perform various operations. The AP started secure
but the script could change its configuration to unsecure. It used
the wps_config CLI command to change both the security and
SSID and hostapd used change_beacon to perform this operation.
We got this script from WIFI team so there is good chance it
is in use by existing certification test beds.
