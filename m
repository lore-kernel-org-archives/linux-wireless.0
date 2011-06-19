Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1FSIIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:08:51 -0400
Subject: Re: [RFC] cfg80211: skip checking of SSID for maintaining scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com>
References: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:08:49 +0200
Message-ID: <1308470929.4145.3.camel@jlt3.sipsolutions.net> (sfid-20110619_100855_720760_1EBF8823)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

johannes

