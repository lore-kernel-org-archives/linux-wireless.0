Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55222 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760295AbcLPJ0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:26:04 -0500
Message-ID: <1481880358.27953.8.camel@sipsolutions.net> (sfid-20161216_102626_065580_87113F0F)
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 10:25:58 +0100
In-Reply-To: <58537DA3.1090901@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
         <1481794142.31776.5.camel@sipsolutions.net>
         <58528607.7090101@qti.qualcomm.com>
         <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
         <1481809984.2582.5.camel@sipsolutions.net>
         <58537DA3.1090901@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-16 at 05:37 +0000, Thiagarajan, Vasanthakumar wrote:

> QCA988X does not have capability to configure vif specific decap
> mode. Encap mode is configurable per packet for all the ath10k based
> chips so this part should be fine to support per vif configuration. 

Ok, that's good.

> Newer QCA chips like QCA9984, QCA4019, QCA9888 and QCA99X0 supports
> decap mode configuration per vif.

Also good.

> To reduce the complexity, we can probably make per vif encap/decap
> configuration mandatory to enable ethernet frame format, not sure how
> this will work with non-QCA capable hardware.

I don't know either, nobody else has talked about it yet :-)

Anyway, if we (for now) we can assume that TX can be constant 802.3
encap mode once enabled, we don't have to deal with the messy dynamic
switching you had there.

RX can switch more dynamically independent of all the mac80211 code
since it basically just means the driver calls one function or the
other - if everything is offloaded correctly there shouldn't really be
a difference.

Then also things like IEEE80211_CONF_CHANGE_80211_HDR_OFFL etc. can go
away entirely because you don't have to switch anything dynamically at
a global level. That will simplify everything a lot.

johannes
