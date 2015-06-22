Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47130 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbbFVID3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:03:29 -0400
Message-ID: <1434960206.19597.6.camel@sipsolutions.net> (sfid-20150622_100333_109745_74F505F4)
Subject: Re: brcmfmac: one faulty "iw interface add" command breaks
 in-firmware BSS state
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Date: Mon, 22 Jun 2015 10:03:26 +0200
In-Reply-To: <5587BDA9.5000107@broadcom.com> (sfid-20150622_094800_795721_2E996996)
References: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>
	 <5587BDA9.5000107@broadcom.com> (sfid-20150622_094800_795721_2E996996)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-22 at 09:47 +0200, Arend van Spriel wrote:

> > # iw phy phy0 interface add wlan0 type __ap
> 
> Now this is a pretty silly scenario as there already is a wlan0 
> interface. Admittedly, this should be rejected as such. This clearly is 
> a user mistake (not sure why you quoted that :-p ) and it might be good 
> to catch this in cfg80211 as it probably applies to other drivers as 
> well. This probably explains why register_netdev fails.

I don't think that's easy to catch - but the driver really should just
see that register_netdev fails and do nothing (except for reporting the
error back), no?

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
