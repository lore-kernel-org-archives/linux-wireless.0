Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53896 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932583AbdJRKNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 06:13:46 -0400
Message-ID: <1508321623.2674.11.camel@sipsolutions.net> (sfid-20171018_121350_415193_4AA01D17)
Subject: Re: [PATCH] wil6210: disallow changing RSN in beacon change
From: Johannes Berg <johannes@sipsolutions.net>
To: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>, Jouni Malinen <j@w1.fi>
Date: Wed, 18 Oct 2017 12:13:43 +0200
In-Reply-To: <18712cc3-3c69-ff9a-e64b-a988463d1965@codeaurora.org>
References: <20171017194253.10212-1-johannes@sipsolutions.net>
         <18712cc3-3c69-ff9a-e64b-a988463d1965@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This is not dead code, we reach it in several scenarios, mainly WPS
> tests.

Interesting.

> hostapd uses change_beacon to change the security of the AP so this
> needs to be supported. 

I didn't think this made sense - Jouni? Does hostapd kick off all
stations in this case?

> We do need to restart the AP in this case which will
> disconnect existing clients, but this cannot be helped...

Why not restart the AP entirely then from userspace? Hmm. I wonder what
would happen with mac80211 - I guess keys would have to removed etc?
Does this just work by accident because mac80211 removes the keys with
stations? What about GTK(s) though?

> As a side note, hostapd can also use change_beacon to change the
> SSID.

When does that happen?

> It does so by updating the SSID IE in the probe response frame. We
> have a pending patch that detects this and updates the FW but we also
> need to update wdev->ssid otherwise the wireless_dev will be out of
> date (not sure if it will cause any problems...)

Logic-wise it won't, but we do expose this to userspace and that'd be
confusing, so we have to update it I guess.

johannes
