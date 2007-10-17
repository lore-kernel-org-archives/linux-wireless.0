Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:60253 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762811AbXJQTuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 15:50:14 -0400
Message-ID: <4716676C.5010907@lwfinger.net> (sfid-20071017_205034_434311_6DA82EA3)
Date: Wed, 17 Oct 2007 14:50:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43: cannot set channel to 12
References: <jey7e1leh0.fsf@sykes.suse.de>
In-Reply-To: <jey7e1leh0.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Schwab wrote:
> The b43 driver in current wireless-2.6 cannot set the channel to 12:
> 
> # iwconfig wlan0 chan 12
> Error for wireless request "Set Frequency" (8B04) :
>     SET failed on device wlan0 ; Invalid argument
> 
> iwlist still lists the APs on channels 12 and 13.
> 
> This is a 4318 in a iBook G4, using firmware version 410.2160.

This is not a b43 problem. The standard loading of mac80211 sets an FCC regulatory domain, i.e. b/g
channels 1-11. You need to load mac80211 with a parameter of 'ieee80211_regdom=64'. That will allow
b/g channels 1-13. Technically, it sets the regulatory domain to Japan, but channel 14 is not allowed.

Larry
