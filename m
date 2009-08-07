Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41302 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZHGVu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 17:50:27 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Deauthentications with p54usb
Date: Fri, 7 Aug 2009 23:50:25 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4A7C9383.2040705@lwfinger.net>
In-Reply-To: <4A7C9383.2040705@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908072350.26193.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Friday 07 August 2009 22:50:11 Larry Finger wrote:

> I've been working with b43 of late and had not run p54usb until I
> tested the rfkill code earlier today. Now I'm getting
> deauthentications with reason=7 that I did not get with b43 using the
> same AP in roughly the same geometric relationship.

hmm, so the SNR of b43 and p54 are comparable?

good...

reason 7 must be:
WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA

and class 3 frames are (according to 802.11-2007 11.3.c)
	- "normal" data frames
	(- some MLMEs - probably not relevant )
	- control frame:
		=> especially: Power Save Poll.

your log doesn't hold any records about a disassoc event from the AP.
so, my first guess would be that you're hitting yet another
power saving related issue.  And as far as I know b43 does not do that yet.
So, can you please give the device another go without ps?

(BTW: mac80211 prints a debug text (if enabled in kconfig),
 whenever the device goes or leaves the hibernation mode...
 do you see any of those too?) 
> I don't know if this is a regression, or not. The current kernel is
> 2.6.31-rc5-wl. I'll boot 2.6.30-wl to test if the older one is OK.
> 
> The logged data below shows nothing but the timing of the disconnects.

does the time between reassoc & _deauth_ vary, or is it always ~24 secs?)
do you experience this behavior on an idle or loaded link?
  
Regards,
	Chr
