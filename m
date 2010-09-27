Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:58427 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab0I0Rbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:31:39 -0400
Received: by pxi10 with SMTP id 10so1487559pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:31:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC>
References: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 10:31:10 -0700
Message-ID: <AANLkTim=hHPMS9kUn11BnWDED1DeUVdJmu3u0Ajr3MPa@mail.gmail.com>
Subject: Re: memory leak in scan with 9170?
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 10:16 AM, Chuck Crisler <ccrisler@vgocom.com> wrote:
> I have modified my code that is using a 9170. I am really concerned about
> roaming and so am testing that pretty hard. Yesterday I had a loop that
> forced a DISCONNECT followed by a REASSOCIATE every 30 seconds. After
> between 1:30 and 1:40 it failed by no longer receiving scan results. When I
> looked into a log, the very last scan results that I received had a reduced
> number of BSSs, down from 10-12 per scan to 4, then the next scan was zero.
> It never recovered. All scans always failed to return any results from then
> on and, of course, the re-associate failed. This 'feels' to me like a memory
> leak somewhere, either in the firmware or the driver. I am running the
> 2.6.31 kernel/driver and the dual file firmware and version 0.6.10 of the
> supplicant.

Both are ancient. Please try compat-wireless-2.6.36-rc3-1, I will soon
make a new release with some stable fixes applied which are not yet in
Linus' tree which I think will help a lot with your roaming testing. I
should also note roaming was not possible until circa 2.6.33 when
Jouni allowed for cfg80211 to authenticate to two APs at the same time
and then move off to it to associate. Also although technically older
userspace should work with newer kernels I have noted some issues with
some really old supplicant on current kernels. I don't think there has
been enough motivation to track down the exact issues though, but your
best bet is to just upgrade the supplicant.

> At the moment I am running another test where it roams every 60
> seconds rather than 30 seconds to see what kind of difference that makes. I
> know that my kernel is old, but for now I don't have a choice. Does anyone
> have any experience like this or insight into this new problem? This is an
> embedded device that doesn't have the memory of a PC. Is there some way that
> I could instrument something to check this?

I'm testing roaming by using wpa_cli roam <bss> in an ESS every 5
seconds. To really stress test the hell out of this I force a roam
every second too, its quite fun, it created a crash but I think we now
know one of the main issues behind some warnings and Johannes has been
brainstorming some solution. I don't suspect you'll hit these corner
cases unless you roam every 2 seconds or so. The warnings are related
to the fact that we assume the STA peer channel is the currently
operating one when we TX a frame, and if we already associated to
another station when moving from 2.4 GHz to 5 GHz we can potentially
be trying to send a frame to a peer with no valid bitrate.

You can use my script to test stuff as well:

http://bombadil.infradead.org/~mcgrof/test-roam

For example if you already know your ESS just replace the ESS variable
with the set of BSSes for your ESS, they all most be on the same SSID
though.

  Luis
