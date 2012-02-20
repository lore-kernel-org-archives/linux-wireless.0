Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37944 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2BTLDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 06:03:36 -0500
Received: by vcge1 with SMTP id e1so3522713vcg.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 03:03:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201202201048.01883.chunkeey@googlemail.com>
References: <CAHPDcRtEHP7LAGPDE_UDs-P9Nq_ZrQbxsMYDCt-eXvjR+5=6kQ@mail.gmail.com>
	<201202201048.01883.chunkeey@googlemail.com>
Date: Mon, 20 Feb 2012 16:33:35 +0530
Message-ID: <CAD2nsn1UWO0ix2OCkqC+xu3bX_p-pvsPk7VNv-5E=kGvKaxMUw@mail.gmail.com> (sfid-20120220_120339_900810_70F86FBC)
Subject: Re: AP send null-data packet?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Yingang Fu <yingang.fu@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Don't know much about other AP software. But hostapd sends them
> to check if a station is still in range and active.
>
> quote from hostapd.conf:
>
> # Station inactivity limit
> #
> # If a station does not send anything in ap_max_inactivity seconds, an
> # empty data frame is sent to it in order to verify whether it is
> # still in range. If this frame is not ACKed, the station will be
> # disassociated and then deauthenticated. This feature is used to
> # clear station table of old entries when the STAs move out of the
> # range.

i think also in this path in mac80211
sta_notify (driver call back) for AP mode
ieee80211_sta_block_awake
sta_unblock ->
ieee80211_sta_ps_deliver_poll_response  ->
ieee80211_sta_ps_deliver_response  ->
 ieee80211_send_null_response

also in UAPSD path. i don't know much about the technical details

-- 
thanks,
shafi
