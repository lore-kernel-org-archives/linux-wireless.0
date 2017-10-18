Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965409AbdJRJZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 05:25:21 -0400
Subject: Re: [PATCH] wil6210: disallow changing RSN in beacon change
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20171017194253.10212-1-johannes@sipsolutions.net>
From: Lior David <liord@codeaurora.org>
Message-ID: <18712cc3-3c69-ff9a-e64b-a988463d1965@codeaurora.org> (sfid-20171018_112526_954166_22DB46FF)
Date: Wed, 18 Oct 2017 12:25:18 +0300
MIME-Version: 1.0
In-Reply-To: <20171017194253.10212-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 10/17/2017 10:42 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is a code path that will never really get hit anyway, since
> it's nonsense to change the beacon of an existing BSS to suddenly
> include or no longer include the RSN IE. Reject this instead of
> having the dead code, and get rid of accessing wdev->ssid/_len by
> way of that.
> 
This is not dead code, we reach it in several scenarios, mainly WPS tests.
hostapd uses change_beacon to change the security of the AP so this needs to
be supported. We do need to restart the AP in this case which will disconnect
existing clients, but this cannot be helped...
As a side note, hostapd can also use change_beacon to change the SSID. It
does so by updating the SSID IE in the probe response frame. We have a pending
patch that detects this and updates the FW but we also need to update wdev->ssid
otherwise the wireless_dev will be out of date (not sure if it will cause
any problems...)
