Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34612 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759273AbdLSJlV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:41:21 -0500
Message-ID: <1513676475.26145.3.camel@sipsolutions.net> (sfid-20171219_104125_461890_342A684B)
Subject: Re: [PATCH 2/3] rtlwifi: Add beacon check mechanism to check if AP
 settings changed.
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Tsang-Shian Lin <thlin@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Tue, 19 Dec 2017 10:41:15 +0100
In-Reply-To: <449108ee-32c1-0da9-8779-079beb659467@lwfinger.net> (sfid-20171214_170624_925221_BAD090A1)
References: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
         <20171209173710.9879-3-Larry.Finger@lwfinger.net>
         <87fu8dcwsf.fsf@purkki.adurom.net>
         <449108ee-32c1-0da9-8779-079beb659467@lwfinger.net>
         (sfid-20171214_170624_925221_BAD090A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-14 at 10:06 -0600, Larry Finger wrote:

> Does mac80211 have this facility? If so, how would we tap into it? If this 
> capability does not exist in mac80211, how would one add it? I have never 
> devoted much effort to looking at the internals of mac80211.

It really should, and this code looks awful - but can you tell me what
exactly this is doing?

If the AP changed settings, then we should handle this in
ieee80211_rx_mgmt_beacon() and simply reconfigure the driver
accordingly.

johannes
