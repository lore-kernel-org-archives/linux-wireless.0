Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:45490 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZCIT4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 15:56:41 -0400
Received: by bwz26 with SMTP id 26so1342709bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 12:56:38 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Another "scan handling in mac80211" bug
Date: Mon, 9 Mar 2009 20:56:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <200903091838.16365.helmut.schaa@gmail.com> <1236624512.9658.5.camel@johannes.local>
In-Reply-To: <1236624512.9658.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903092056.28091.helmut.schaa@gmail.com> (sfid-20090309_205644_543182_66380CDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 9. M=E4rz 2009 schrieb Johannes Berg:
[...]

> > All subsequent scan requests will fail in cfg80211_wext_siwscan as =
mac80211
> > did not notify cfg80211 about the scan result.
> >=20
> > I guess it should be sufficient to queue one more sta_work after th=
e MLME
> > moves to IEEE80211_STA_MLME_DISABLED state. In case IEEE80211_STA_R=
EQ_SCAN
> > is still set the scan will get started and cfg80211 gets notified a=
bout the
> > result.
> >=20
> > Does that seem correct?
>=20
> Yes, that seems correct to me. IEEE80211_STA_REQ_RUN not being set wi=
ll
> catch the "do nothing with assoc state" part.

Ok, I'll do some more tests tomorrow and send a patch if it works for m=
e.

Helmut

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
