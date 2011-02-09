Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.3eti.com ([65.220.88.141]:51914 "EHLO webmail.3eti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1BIQJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 11:09:10 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: 'Zefir Kurtisi' <zefir.kurtisi@neratec.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] DFS userspace handler
Date: Wed, 9 Feb 2011 16:09:08 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC34@RockMX01.rock.corp>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
 <4D52B7DB.8000000@neratec.com>
In-Reply-To: <4D52B7DB.8000000@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would vote for a dedidate DFS daemon.

Straightforward name is better. 
Beginners would be hard to understand why WDS/Mesh/IBSS mode requires a hostapd daemon which intuitively means for AP mode..



-----Original Message-----
From: Zefir Kurtisi [mailto:zefir.kurtisi@neratec.com] 
Sent: Wednesday, February 09, 2011 10:51 AM
To: Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] DFS userspace handler

On 02/09/2011 04:35 PM, Chaoxing Lin wrote:
> What about DFS in WDS / Mesh / IBSS mode if DFS is only implemented in hostapd?
> 
> Will an instance of hostapd be required for all these modes, too?
> 
> Thanks
> 
Yes, with this approach you will need to have some userspace component that
evaluates the reported pulses and handles channels upon radar detection.

hostapd was taken as the first shot, but one might also think of a dedicated
DFS deamon that takes this role. Actually that is our intended gain of this
approach: having a defined interface for pulse events reporting and highest
flexibility wrt detection and handling.

Cheers

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Zefir Kurtisi
> Sent: Wednesday, February 09, 2011 7:02 AM
> To: linux-wireless@vger.kernel.org
> Cc: Zefir Kurtisi
> Subject: [RFC] DFS userspace handler
> 
> Hello DFS folks,
> 
> this is a patch series to prove the concept of DFS handling done in userspace.
> 
> It moves the radar pattern detector introduced in [1] and documented in [2] 
> from mac80211 up to hostapd.
> 
> The basic concept is:
> 1) pattern detection
>  * pulse events detected by HW are passed to hostapd
>  * hostapd performs per-wiphy DFS pattern matching
> 2) channel handling: on radar detection hostapd
>  * updates channel state (NOL handling)
>  * switches to new operating channel with TX disabled (on all wiphys)
>  * after CAC period enables TX on that channel
> 
> The proposed patches provide part 1) of the concept. The nl80211 interface is
> extended with functions to pass DFS pulse events to hostapd.
> 
> Testing as described in [2] results in identical output, indicating that both
> approaches (mac80211 and hostapd based) are equivalent from functional point
> of view.
> 
> The testing was done with
>  * OpenWRT r25417
>  * Atheros AR9280 Rev:2
>  * DFS radars generated with R&S vector signal generator
> 
> We at our company would prefer this approach over the mac80211 based one as
> soon as we see that part 2) can be implemented as proposed. 
> 
> 
> 
> Cheers
> Zefir
> 
> 
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/61868
> [2] http://linuxwireless.org/en/developers/DFS/DetectorDesignNt
> ---

