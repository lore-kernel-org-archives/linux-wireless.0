Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38250 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbcAEPwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:52:39 -0500
Message-ID: <1452009156.12357.38.camel@sipsolutions.net> (sfid-20160105_165241_994395_066DAACB)
Subject: Re: [PATCH] mac80211: Don't buffer non-bufferable MMPDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 16:52:36 +0100
In-Reply-To: <CAGXE3d9TZbUF0k0moa_hzOUip9q5PgDSe0kDbiD1KCH7mjX+Ng@mail.gmail.com> (sfid-20160105_164357_550938_57AADF44)
References: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
	 <1452008139.12357.32.camel@sipsolutions.net>
	 <CAGXE3d9TZbUF0k0moa_hzOUip9q5PgDSe0kDbiD1KCH7mjX+Ng@mail.gmail.com>
	 (sfid-20160105_164357_550938_57AADF44)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 16:43 +0100, Helmut Schaa wrote:

> > That said, it obviously also points to a driver bug not treating
> > these frames correctly, so you might want to investigate why you
> > got here to start with!
> 
> It was not the driver marking the frame as filtered but mac80211
> itself in status.c:
> 
>                 acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
>                 if (!acked && test_sta_flag(sta, WLAN_STA_PS_STA)) {
>                         /*
>                          * The STA is in power save mode, so assume
>                          * that this TX packet failed because of
> that.
>                          */
>                         ieee80211_handle_filtered_frame(local, sta,
> skb);
>                         rcu_read_unlock();
>                         return;
>                 }

Ah, yes, ok. So the frame simply didn't go through, for whatever
reason. Hopefully the driver actually transmitted it :)

> However, I've put the code into ieee80211_handle_filtered_frame to
> not grow ieee80211_tx_status even more :)
>
> If you prefer to add it here directly I'm fine to change it.
> 

No, looks fine as is. I just misunderstood how we got here.

johannes
