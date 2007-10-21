Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52057 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbXJUOea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 10:34:30 -0400
Message-ID: <471B6368.7000600@lwfinger.net> (sfid-20071021_153442_737106_9CAB4785)
Date: Sun, 21 Oct 2007 09:34:16 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43: cannot set channel to 12
References: <jey7e1leh0.fsf@sykes.suse.de> <4716676C.5010907@lwfinger.net> <jesl44n1ax.fsf@sykes.suse.de>
In-Reply-To: <jesl44n1ax.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Schwab wrote:
> Larry Finger <larry.finger@lwfinger.net> writes:
> 
>> This is not a b43 problem. The standard loading of mac80211 sets an FCC regulatory domain, i.e. b/g
>> channels 1-11. You need to load mac80211 with a parameter of 'ieee80211_regdom=64'. That will allow
>> b/g channels 1-13. Technically, it sets the regulatory domain to Japan, but channel 14 is not allowed.
> 
> Thanks, that works.  (But I regard it as a regression.)

That is in the eye of the beholder. For those of us in FCC-land, the default behavior of bcm43xx
(channels 1-14) was a bug _AND_ a violation of regulations and law.

Handling regulatory domain information including allowed channels, power, etc. is still a big
weakness of all MAC layers, both hard and soft.

Larry
