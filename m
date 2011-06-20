Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60014 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1FTNne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 09:43:34 -0400
From: "Shajakhan, Mohammed Shafi" <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] cfg80211: skip checking of SSID for maintaining scan list
Date: Mon, 20 Jun 2011 13:40:21 +0000
Message-ID: <D106CD05FEFBA74BA17F929FD27C8AB3099BBC99@nasanexd02a.na.qualcomm.com> (sfid-20110620_154337_952965_FB7495C0)
References: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com>
	 ,<1308470929.4145.3.camel@jlt3.sipsolutions.net>
	 <D106CD05FEFBA74BA17F929FD27C8AB3099BAFB2@nasanexd02a.na.qualcomm.com>,<1308552341.4322.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1308552341.4322.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: 20 June 2011 12:15:41
To: Shajakhan, Mohammed Shafi
Cc: linux-wireless@vger.kernel.org
Subject: RE: [RFC] cfg80211: skip checking of SSID for maintaining scan list

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

thanks for your inputs, i will try do that. I can update the parameters not only based on whether the BSS is found, also based on if its an associated entry, however still we maintain an additional entry for the hidden-SSID AP .

thanks,
shafi

johannes

