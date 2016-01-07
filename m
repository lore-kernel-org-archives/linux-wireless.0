Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46266 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbcAGVGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 16:06:31 -0500
Message-ID: <1452200788.3141.22.camel@sipsolutions.net> (sfid-20160107_220634_782110_BB99499D)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Jan 2016 22:06:28 +0100
In-Reply-To: <568CD9D1.6080001@neratec.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	 <568B912F.8070100@neratec.com> <1451987939.12357.18.camel@sipsolutions.net>
	 <568BA0E3.5080905@neratec.com> <1452009029.12357.37.camel@sipsolutions.net>
	 <568CD9D1.6080001@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-06 at 10:09 +0100, Matthias May wrote:
> 
> afaik it solves the issue that when a STA roames from AP1 to AP2, and
> key material is installed at different times.
> We observed encrypted frames which had a wrong CCMP counter. If the
> STA 
> updates it's counter with these frames then depending on the wrong
> CCMP 
> value received, up to a few hundred frames were dropped.

I don't really see how it has any effect there either, since in that
case the old key material should be deleted long before the new one is
installed, so the cross-over that causes the PN update problem with
rekeying can't happen?

> Not exactly the same as rekeying but the effect are pretty similar.

Ignoring the discussion about the effect of the patch in roaming, the
patch really can't do anything for rekeying since the station never
goes back to !authorized in that case, so it can't really be relevant
for this thread.

johannes
