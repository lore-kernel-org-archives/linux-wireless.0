Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:35210 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZHIPMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 11:12:33 -0400
Received: by rv-out-0506.google.com with SMTP id f6so792593rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2009 08:12:34 -0700 (PDT)
Message-ID: <4A7EE75E.30900@lwfinger.net>
Date: Sun, 09 Aug 2009 10:12:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
References: <4A7C9383.2040705@lwfinger.net> <200908072350.26193.chunkeey@web.de>
In-Reply-To: <200908072350.26193.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> reason 7 must be:
> WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA
> 
> and class 3 frames are (according to 802.11-2007 11.3.c)
> 	- "normal" data frames
> 	(- some MLMEs - probably not relevant )
> 	- control frame:
> 		=> especially: Power Save Poll.
> 
> your log doesn't hold any records about a disassoc event from the AP.
> so, my first guess would be that you're hitting yet another
> power saving related issue.  And as far as I know b43 does not do that yet.
> So, can you please give the device another go without ps?
> 
> (BTW: mac80211 prints a debug text (if enabled in kconfig),
>  whenever the device goes or leaves the hibernation mode...
>  do you see any of those too?) 

Once I got that debug mode set with PS enabled, I still got the deauth
events, but no messages from mac80211. I may not have had the debug
value set correctly. Turning off CONFIG_CFG80211_DEFAULT_PS stopped
the messages, thus it certainly looks like a power saving event.

Larry

