Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39698 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbdCCNbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:31:13 -0500
Message-ID: <1488544754.25750.8.camel@sipsolutions.net> (sfid-20170303_143147_995710_555E6674)
Subject: Re: [RFCv2 2/2] mac80211: Implement data xmit for 802.11 encap
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: mpubbise@qti.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date: Fri, 03 Mar 2017 13:39:14 +0100
In-Reply-To: <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> There is a field, no_80211_encap, added to ieee80211_tx_info:control
> to mark if the 802.11 encapsulation is offloaded to driver.

Why is that needed? Since you have a separate TX path (ndo_start_xmit),
wouldn't it make more sense to call into a drv_tx_8023() or something
like that instead?

> There is also a new callback for tx completion status indication
> to handle data frames using 802.11 encap offload.

Maybe you could just use _noskb?

Haven't really looked at the rest all that much, few comments:

 * not sure you're handling non-linear frames right, are you assuming
   the driver can handle them? probably a fair assumption, but should
   be documented
 * you seem to also be assuming that the driver not only does all
   encryption in HW (which is obviously needed) but also does all the
   key lookups etc. - also seems fair, but also should be documented
 * similarly for a lot of other (all?) fields in tx_info
 * you seem to be assuming that if encap offload is supported then it's
   also *desired* for AP/VLAN and client interfaces, if not 4-addr.
   This seems ... probably about right, but if drivers don't always
   support it? Or support it in more cases? Perhaps we can move the
   SUPPORTS_80211_ENCAP flag into a VIF flag instead, so they can do it
   more fine-grained?

johannes
