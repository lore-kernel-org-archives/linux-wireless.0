Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:55679 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3K3TH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 14:07:57 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so7725255eaj.40
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 11:07:56 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: unable to set iwlwifi master mode
Date: Sat, 30 Nov 2013 20:07:53 +0100
Message-ID: <20693321.VaS1fqlGWS@debian64> (sfid-20131130_200803_238825_CF9A8962)
In-Reply-To: <CAHdPZaPACfFrvXyszwLpT1-iLCrGs_mCh7dR4-_tW=W5V8e1oA@mail.gmail.com>
References: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com> <1980481.3p2Oa8Hyrn@debian64> <CAHdPZaPACfFrvXyszwLpT1-iLCrGs_mCh7dR4-_tW=W5V8e1oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 November 2013 13:24:10 devendra.aaru wrote:
> On Sat, Nov 30, 2013 at 1:20 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > Hi,
> >
> > On Saturday 30 November 2013 12:26:11 devendra.aaru wrote:
> >> I was trying to use my intel wireless device as an AP.
> >>
> >> It seem to be that i couldn't able to get it working.
> >>
> >> in case:
> >>
> >> 03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
> >
> >
> >> What could be the possible mistake?
> > Well, The latest version I found for the IWL 1000 was/is v39.31.5.1 Build
> > 35138. It looks like this version doesn't "support" AP or P2P mode... and
> > it looks like it won't be coming.
> >
> > You probably want to look for a replacement card. However, if you are using
> > a laptop, this might be difficult. Some vendor bios' have a wifi whitelist
> > and you have to ask your laptop vendor for the list first or "get creative".
> >
> > Regards,
> >
> > Christian
> 
> I am using a laptop, so it won't work out for me.
Think about it. I can tell you from my experience: This is less of a hassle.

> Does this version you are talking is about the firmware?
Oh yes. Sorry. I must have dropped the "firmware" while editing.
It should have said: "Well, the latest firmware version I found..."

> If so changing it might help out?
If you can find/get a firmware version for the device which supports it:
"probably yes". You can check if a firmware supports the mode by loading
iwlwifi/iwldvm driver and use the iw tool [0].

# iw list

This will produce a list of all capabilities of each (available) wifi
device in the system. Among the print out there's an entry called
"Supported interface modes". It should look something like this:

	Supported interface modes:
		* managed
    	* AP <---
		* AP/VLAN <---
		* ...

(This is from a IWL 7260).

Good luck while scanning through intel's firmware repository 
(sorry, can't help you there).

Regards,

Christian

[0] <http://wireless.kernel.org/en/users/Documentation/iw>
