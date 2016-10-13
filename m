Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50985 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754189AbcJMNrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 09:47:08 -0400
Message-ID: <1476364371.4904.29.camel@sipsolutions.net> (sfid-20161013_154713_587276_63E89078)
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Xu, Peng" <pxu@qca.qualcomm.com>
Date: Thu, 13 Oct 2016 15:12:51 +0200
In-Reply-To: <20161004161518.GD5430@jouni.qca.qualcomm.com>
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
         <1471330367.16783.23.camel@sipsolutions.net>
         <20160816123441.GA3678@jouni.qca.qualcomm.com>
         <1472198948.390.20.camel@sipsolutions.net>
         <1473674982.29016.10.camel@sipsolutions.net>
         <20161003211523.GA6585@jouni.qca.qualcomm.com>
         <1475587551.5324.57.camel@sipsolutions.net>
         <20161004161518.GD5430@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-04 at 16:15 +0000, Malinen, Jouni wrote:
> 
> And even if the driver were to simply copy the IEs with the BSS
> membership selectors, this would only work with stations that
> implement this part correctly, i.e., the AP would not necessarily
> have any means for rejecting the association if a non-HT/VHT station
> were to try to associate.. With mac80211-drivers, this happens in
> hostapd.

Yes, that's a good point, so we'd still have to pass this information
down.

I think we'll look at adding the necessary parsing to cfg80211, and
then other drivers can pick it up as needed.

johannes
