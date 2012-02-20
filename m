Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2BTLF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 06:05:26 -0500
Subject: Re: AP send null-data packet?
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Yingang Fu <yingang.fu@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAD2nsn1UWO0ix2OCkqC+xu3bX_p-pvsPk7VNv-5E=kGvKaxMUw@mail.gmail.com> (sfid-20120220_120339_900810_70F86FBC)
References: <CAHPDcRtEHP7LAGPDE_UDs-P9Nq_ZrQbxsMYDCt-eXvjR+5=6kQ@mail.gmail.com>
	 <201202201048.01883.chunkeey@googlemail.com>
	 <CAD2nsn1UWO0ix2OCkqC+xu3bX_p-pvsPk7VNv-5E=kGvKaxMUw@mail.gmail.com>
	 (sfid-20120220_120339_900810_70F86FBC)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 12:05:23 +0100
Message-ID: <1329735923.3458.16.camel@jlt3.sipsolutions.net> (sfid-20120220_120529_415447_725D7910)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-20 at 16:33 +0530, Mohammed Shafi wrote:
> > Don't know much about other AP software. But hostapd sends them
> > to check if a station is still in range and active.
> >
> > quote from hostapd.conf:
> >
> > # Station inactivity limit
> > #
> > # If a station does not send anything in ap_max_inactivity seconds, an
> > # empty data frame is sent to it in order to verify whether it is
> > # still in range. If this frame is not ACKed, the station will be
> > # disassociated and then deauthenticated. This feature is used to
> > # clear station table of old entries when the STAs move out of the
> > # range.
> 
> i think also in this path in mac80211
> sta_notify (driver call back) for AP mode
> ieee80211_sta_block_awake
> sta_unblock ->
> ieee80211_sta_ps_deliver_poll_response  ->
> ieee80211_sta_ps_deliver_response  ->
>  ieee80211_send_null_response
> 
> also in UAPSD path. i don't know much about the technical details

Yes, this is true, it happens when the station sends a PS-Poll but we
timed out the frame in the meantime -- should be uncommon. In the uAPSD
case it's more common, if nothing is pending and the station sends a
trigger frame.

In any case, it's perfectly normal for an AP to send null data frames.

johannes

