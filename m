Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50526 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0DWEx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:53:58 -0400
Subject: Re: [PATCH] mac80211: Fix sta->last_tx_rate setting with no-op
 rate control devices
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <v2k43e72e891004220928lb5acefbch8397c6a9a56047b5@mail.gmail.com>
References: <1271921268-7512-1-git-send-email-juuso.oikarinen@nokia.com>
	 <v2k43e72e891004220928lb5acefbch8397c6a9a56047b5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 07:51:28 +0300
Message-ID: <1271998288.6205.10127.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 2010-04-22 at 18:28 +0200, ext Luis R. Rodriguez wrote:
> On Thu, Apr 22, 2010 at 12:27 AM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > The sta->last_tx_rate is traditionally updated just before transmitting a
> > frame based on information from the rate control algorithm. However, for
> > hardware drivers with IEEE80211_HW_HAS_RATE_CONTROL this is not performed,
> > as the rate control algorithm is not executed, and because the used rate is
> > not known before the frame has actually been transmitted.
> >
> > This causes atleast a fixed 1Mb/s to be reported to user space. A few other
> > instances of code also rely on this information.
> >
> > Fix this by setting the sta->last_tx_rate in tx_status handling. There, look
> > for last rates entry set by the driver, and use that as value for
> > sta->last_tx_rate.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> But the actual rate used is not known, or is it? In those cases would
> it not be better to inform userspace that the information is not
> available?

The point here is to set the last_tx_rate with the actual used rate, as
reported by the hardware (and reported to mac80211 by the driver.)

In case of hardware rate control, mac80211 sets the skb's
info->status.rates array to rates indexes "-1".

The driver sets the rate actually used to transmit the frame into the
same array before calling tx_status, along with retry etc info, and
mac80211 then uses this info to update the sta->last_tx_rate.

So by all means, the actual rate is getting set. Opposite to host
rate-control, the sta->last_tx_rate field is just updated right after
transmitting the frame, instead of just before.

-Juuso

>   Luis


