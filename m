Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54610 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753634AbdCBPCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 10:02:08 -0500
Message-ID: <1488462198.8390.16.camel@sipsolutions.net> (sfid-20170302_160239_878973_64533F58)
Subject: Re: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
From: Johannes Berg <johannes@sipsolutions.net>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Thu, 02 Mar 2017 14:43:18 +0100
In-Reply-To: <b461827bad634932a8f0f3b3bfe5e6b4@aphydexm01f.ap.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
         <1488444659.8390.8.camel@sipsolutions.net>
         <b55e902d1a5445feb3058cee1118ae39@aphydexm01f.ap.qualcomm.com>
         <1488456958.8390.15.camel@sipsolutions.net>
         <b461827bad634932a8f0f3b3bfe5e6b4@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> [Tamizh] I'm planning to do this check in iw itself and converting
> into a value, 
> 
> iw command will looks like below
> 
> iw btcoex enable [<be> <bk> <vo> <vi> <mgmt><beacon>]
> 
> If anything other than this given by user will be rejected and will
> not forward to cfg80211.
> Do you have any concern on this?

Yes, you really need to check it in cfg80211 and define the bits that
are valid in nl80211.

johannes
