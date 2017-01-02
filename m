Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37520 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932236AbdABL2v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 06:28:51 -0500
Message-ID: <1483356523.4596.12.camel@sipsolutions.net> (sfid-20170102_122853_587864_689C3D56)
Subject: Re: [PATCH] cfg80211: Random local address for Public Action frame
 exchange
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
        jouni@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, vamsin@qti.qualcomm.com
Date: Mon, 02 Jan 2017 12:28:43 +0100
In-Reply-To: <cf228384-c98e-737e-3ba6-6c18e988210c@quantenna.com>
References: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
         <cf228384-c98e-737e-3ba6-6c18e988210c@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-30 at 22:55 +0300, IgorMitsyanko wrote:
> 
> > The driver needs to configure receive behavior to accept frames to
> > the
> > specified random address during the time the frame exchange is
> > pending
> > and such frames need to be acknowledged similarly to frames sent to
> > the
> > local permanent address when this random address functionality is
> > not
> > used.
> 
> A (probably) silly question: how wireless drivers are supposed to use
> SA 
> in a frame? I think drivers are not concerned about source address,
> they 
> simply pass whatever there is already set by userspace in 
> cfg80211_mgmt_tx_params::buf into air on Tx.
> And on Rx, they filter frames based on receiver address/BSSID, pass
> it 
> to upper layers and do not care what address is in DA (it is handled
> by 
> upper layers).

They do care about the DA in RX, since - as the commit message states -
"such frames need to be acknowledged [...]"

johannes
