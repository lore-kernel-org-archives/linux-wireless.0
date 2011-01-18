Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-08.prod.phx3.secureserver.net ([72.167.82.88]:36746
	"HELO p3plsmtpa01-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752724Ab1ARPdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:33:17 -0500
Message-ID: <8D410FA49EFD4D8997BAC548BA2D55AF@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC> <1295347932.3563.13.camel@jlt3.sipsolutions.net> <BB274B92115347F9A8E250DEF0C2B732@ChuckPC> <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC> <1295362622.3563.23.camel@jlt3.sipsolutions.net> <48A27D1459A9493C8A16D0D6308A5FB1@ChuckPC> <1295364238.3563.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295364238.3563.24.camel@jlt3.sipsolutions.net>
Subject: Re: intermittent eap authentication failure
Date: Tue, 18 Jan 2011 10:33:05 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The deauth reason code isn't passed up to the supplicant, so the supplicant 
doesn't have the best info to make a decision. If the notification message 
was changed to include the reason code, then the supplicant wouldn't need to 
do a scan in this case, which makes everything faster (unless you have 
accurate scan results from a background scan). Dropping a scan means 
everything works much faster.

Background scans probably won't work for our app because we are transmitting 
about 2-3 (sometimes more) good sized data packets every ~40 msec. We would 
have to drop video frames to make room for background scanning, but that 
degrades the video quality, and that is noticeable.

Chuck
----- Original Message ----- 
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Chuck Crisler" <ccrisler@vgocom.com>
Cc: <linux-wireless@vger.kernel.org>
Sent: Tuesday, January 18, 2011 10:23 AM
Subject: Re: intermittent eap authentication failure


> On Tue, 2011-01-18 at 10:21 -0500, Chuck Crisler wrote:
>> What is the reason that the design calls for a scan in response to a 
>> session
>> timeout? A session timeout doesn't happen because of a roam, so the 
>> original
>> AP is probably still good. Why scan?
>
> I don't think there's any design here, and in any case that's
> wpa_supplicant's doing. :)
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

