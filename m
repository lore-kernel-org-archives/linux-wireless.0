Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3FFHOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 03:14:12 -0400
Message-ID: <1370502848.8401.1.camel@jlt4.sipsolutions.net> (sfid-20130606_091415_530526_2F68BE76)
Subject: Re: WLAN EAP methods verification.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless@vger.kernel.org, Michal Marek <MMarek@suse.com>,
	oneukum@suse.de, tiwai@suse.de
Date: Thu, 06 Jun 2013 09:14:08 +0200
In-Reply-To: <51B099FE0200009200022E0D@soto.provo.novell.com> (sfid-20130606_061746_887758_9E445931)
References: <51B099FE0200009200022E0D@soto.provo.novell.com>
	 (sfid-20130606_061746_887758_9E445931)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-05 at 22:17 -0600, Matt Chen wrote:

> I would like to ask if there is a policy or way to verify a WLAN
> driver in kernel such as ath9k, iwlwifi, rt2x00 or rtlwifi and so
> on ... pass all the EAP method [1] or WPA/WPA2 encryption ?

Not really. I think we all pretty much assume that once we support the
cipher algorithms (TKIP/CCMP) everything else works because it's
implemented in wpa_supplicant and the drivers don't have to do anything
but pass frames and eventually install keys.

The only driver where that's not true is the PS3 wifi driver ;-)

johannes

