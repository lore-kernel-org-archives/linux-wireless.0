Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42631 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1FTExe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 00:53:34 -0400
From: "Shajakhan, Mohammed Shafi" <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] cfg80211: skip checking of SSID for maintaining scan list
Date: Mon, 20 Jun 2011 04:50:45 +0000
Message-ID: <D106CD05FEFBA74BA17F929FD27C8AB3099BAFB2@nasanexd02a.na.qualcomm.com> (sfid-20110620_065338_792821_5CD5D204)
References: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com>,<1308470929.4145.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1308470929.4145.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: 19 June 2011 13:38:49
To: Shajakhan, Mohammed Shafi
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: skip checking of SSID for maintaining scan list

On Mon, 2011-06-13 at 21:09 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> when we connect to hidden SSID AP's we maintain two entries
> for the same AP and we update all the parameters for the hidden
> SSID entry rather than the associated entry, this is because we
> have the SSID check in updating/adding new entries in scanlist.
> by skipping the SSID check we will maintain a single entry for
> the hidden SSID and also update the associated entry for the
> same.
>   will this break something if I skip SSID check for the sake
> of hidden SSID AP's or is there someother IE's I can check for.

I think this will break the case where there are multiple SSIDs all
hidden on the same BSSID, which is a configuration that some people use.

thanks for your kind review, let me try to find if there is some other way to fix this. if you have any ideas please tell me.

thanks,
shafi


johannes

