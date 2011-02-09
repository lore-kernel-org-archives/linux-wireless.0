Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:36610 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1BIPuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:50:54 -0500
Message-ID: <4D52B7DB.8000000@neratec.com>
Date: Wed, 09 Feb 2011 16:50:51 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Chaoxing Lin <CLin@3eti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] DFS userspace handler
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com> <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

