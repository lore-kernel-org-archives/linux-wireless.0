Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35656 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933882AbcECQBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 12:01:08 -0400
Message-ID: <1462291262.2251.4.camel@sipsolutions.net> (sfid-20160503_180127_090247_335B90AB)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 May 2016 18:01:02 +0200
In-Reply-To: <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com> (sfid-20160503_163230_612724_F1B0945E)
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
	 <1462281243.2251.2.camel@sipsolutions.net>
	 <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com>
	 <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com>
	 (sfid-20160503_163230_612724_F1B0945E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 20:02 +0530, Krishna Chaitanya wrote:

> > i don't see any issues in the powersave w.r.t driver. Isn't it a
> > valid case? you meant implementing dynamic_ps?

No, I really did mean implementing the entire PS logic in the driver,
instead of having mac80211 do it.

> If it advertise HW_SUPPORTS_DYNAMIC_PS it works fine.
> so may be we should queue those frames and send it to
> HW once it is out of powersave?

We could, but I *really* don't want to patch over the messy and broken
powersave code in mac80211 now.

I really do think that the only way out of this mess is to implement
powersave entirely outside of mac80211; perhaps mac80211 could provide
helpers for it, but tying it into the MLME implementation and having
all the PS-Poll stuff be global etc. is simply wrong today.

johannes
