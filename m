Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58836 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2IGQKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 12:10:23 -0400
Received: by eaac11 with SMTP id c11so976784eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 09:10:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
Date: Fri, 7 Sep 2012 18:10:18 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net> <201209071747.09666.chunkeey@googlemail.com> <1347033342.4256.28.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347033342.4256.28.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209071810.18821.chunkeey@googlemail.com> (sfid-20120907_181028_313230_413ABEE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 17:55:42 Johannes Berg wrote:
> On Fri, 2012-09-07 at 17:47 +0200, Christian Lamparter wrote:
> > On Friday 07 September 2012 14:17:14 Johannes Berg wrote:
> > > On Tue, 2012-09-04 at 16:54 +0200, Johannes Berg wrote:
> > >
> > > If you want this for your driver, I'll commit this:
> > > 
> > > http://p.sipsolutions.net/ea2e3dbe980f5db8.txt
> > 
> > Won't this totally disable the crypto offload
> > capabilities in AP mode?
> 
> Yes, though we could add an nl80211 attribute that
> allows hostapd to tell us, and then if it did tell
> us we could know and do the right thing here.

Well, if we want to do the right thing here, then I
guess we should go for another alternative: a rxkey
manager of some sorts. So, we delete keys from the
firmware context once MFP comes into the game.

This method also has another advantage that with
a proper manager we can use the key usage statistics
and upload only the most-used keys into the firmware
context (most/all? p54 firmwares have usually 4-8 key
slots in total, which is not always enough).
 
> > I sort of prefer the nohwcrypt switch as it won't
> > interfere with running user setups as much (so we
> > don't burden systems like that weird telekom
> > streamin-box (Vision S100 - it's name I think)
> > that came with a p54pci minipci card and are
> > now used for different purposes by some.
> 
> I guess it would make sense then to give hostapd the ability to tell us?
> 
> It's up to you. I don't need 11w, nor do I have p54 hardware, nor does
> it matter much to me ... :)
Let's save that task for a rainy day :-D.

Regards,
	Chr
