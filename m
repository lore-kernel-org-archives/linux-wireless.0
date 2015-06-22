Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47216 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbbFVIXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:23:49 -0400
Message-ID: <1434961425.19597.7.camel@sipsolutions.net> (sfid-20150622_102352_798701_AFFC6137)
Subject: Re: brcmfmac: one faulty "iw interface add" command breaks
 in-firmware BSS state
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Date: Mon, 22 Jun 2015 10:23:45 +0200
In-Reply-To: <5587C532.3050901@broadcom.com>
References: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>
		 <5587BDA9.5000107@broadcom.com>
	 (sfid-20150622_094800_795721_2E996996) <1434960206.19597.6.camel@sipsolutions.net>
	 <5587C532.3050901@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-22 at 10:20 +0200, Arend van Spriel wrote:

> >>> # iw phy phy0 interface add wlan0 type __ap

> Indeed there is an issue with error handling here, but as this was a 
> user fault I was looking for early detection. If as you say that will 
> not be easy from cfg80211 we will need to rework brcmfmac code. 
> Currently, we create interface in firmware and upon receiving 'ifc 
> created' event we do the register_netdev. I think we do that to avoid 
> getting start_xmit calls as we do not use netif carrier calls.

We could possibly check for duplicate names, but surely there are other
failure modes that we can't easily pre-check, so it seems better to fix
the driver (and, in fact, use the duplicate name issue as a convenient
way of testing the error path)

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
