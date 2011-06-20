Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1FTGpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 02:45:46 -0400
Subject: RE: [RFC] cfg80211: skip checking of SSID for maintaining scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: "Shajakhan, Mohammed Shafi" <mohammed@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <D106CD05FEFBA74BA17F929FD27C8AB3099BAFB2@nasanexd02a.na.qualcomm.com>
References: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com>
	 ,<1308470929.4145.3.camel@jlt3.sipsolutions.net>
	 <D106CD05FEFBA74BA17F929FD27C8AB3099BAFB2@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 08:45:41 +0200
Message-ID: <1308552341.4322.0.camel@jlt3.sipsolutions.net> (sfid-20110620_084550_138079_C4439C3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 04:50 +0000, Shajakhan, Mohammed Shafi wrote:

> > when we connect to hidden SSID AP's we maintain two entries
> > for the same AP and we update all the parameters for the hidden
> > SSID entry rather than the associated entry, this is because we
> > have the SSID check in updating/adding new entries in scanlist.
> > by skipping the SSID check we will maintain a single entry for
> > the hidden SSID and also update the associated entry for the
> > same.
> >   will this break something if I skip SSID check for the sake
> > of hidden SSID AP's or is there someother IE's I can check for.
> 
> I think this will break the case where there are multiple SSIDs all
> hidden on the same BSSID, which is a configuration that some people use.
> 
> thanks for your kind review, let me try to find if there is some other way to fix this. if you have any ideas please tell me.

I'm not sure; I think maybe we need to treat the associated case
differently? In that case, we know what the SSID is we're supposedly
connected to, so we could update that entry.

johannes

