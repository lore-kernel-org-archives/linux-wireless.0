Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37050 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZCIPRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 11:17:21 -0400
Received: by fxm24 with SMTP id 24so1281743fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 08:17:18 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: handle failed scan requests in STA mode
Date: Mon, 9 Mar 2009 16:17:07 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <200903091547.09223.helmut.schaa@gmail.com>
In-Reply-To: <200903091547.09223.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903091617.08149.helmut.schaa@gmail.com> (sfid-20090309_161725_212051_353E6CE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 9. M=E4rz 2009 schrieb Helmut Schaa:
> If cfg80211 requests a scan it awaits either a return code !=3D 0 fro=
m
> the scan function or the cfg80211_scan_done to be called. In case of
> a STA mac80211's scan function ever returns 0 and queues the scan req=
uest.
> If ieee80211_sta_work is executed and ieee80211_start_scan fails for
> some reason cfg80211_scan_done will never be called but cfg80211 stil=
l
> thinks the scan was triggered successfully and will refuse any future
> scan requests due to drv->scan_req not being cleaned up.
>=20
> If a scan is triggered from within the MLME a similar problem appears=
=2E If
> ieee80211_start_scan returns an error, local->scan_req will not be re=
set
> and mac80211 will refuse any future scan requests.
>=20
> Hence, in both cases call ieee80211_scan_failed (which notifies cfg80=
211
> and resets local->scan_req) if ieee80211_start_scan returns an error.
>=20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Btw, John, I guess this should go into linux-next as the cfg80211-scan =
code
is there already and otherwise cfg80211 and mac80211 can get stuck (ref=
uses
any scan requests) when the iwlwifi killswitch is used (only tested wit=
h
NetworkManager).

I'm not sure if anything apart from the killswitch also triggers this i=
ssue.

Thanks,
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
