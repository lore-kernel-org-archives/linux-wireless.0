Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46379 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0IMWXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 18:23:04 -0400
Received: by iwn5 with SMTP id 5so5485230iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 15:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik=1LX_12ZskP5vwkSrTVFO9jH6uu8pyByGmLg6@mail.gmail.com>
References: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
 <AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
 <AANLkTinch-sygnRmB6LKi6xLNYVKY6Ap3YL4_PMNdmKQ@mail.gmail.com> <AANLkTik=1LX_12ZskP5vwkSrTVFO9jH6uu8pyByGmLg6@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Sep 2010 15:22:43 -0700
Message-ID: <AANLkTi=JPG5X6=i=q1jeKH1uueqF0g_9eXuihzdP4_Mk@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix sw scan bracketing
To: Johannes Berg <johannes@sipsolutions.net>,
	Paul Stewart <pstew@google.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 2:22 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jul 27, 2010 at 1:27 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Tue, Jul 27, 2010 at 1:04 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Fri, Jun 18, 2010 at 3:32 AM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> From: Johannes Berg <johannes.berg@intel.com>
>>>>
>>>> Currently, detection in hwsim and ath9k can
>>>> detect that two sw scans are in flight at the
>>>> same time, which isn't really true. It is
>>>> caused by a race condition, because the scan
>>>> complete callback is called too late, after
>>>> the lock has been dropped, so that a new scan
>>>> can be started before it is called.
>>>>
>>>> It is also called too early semantically, as
>>>> it is currently called _after_ the return to
>>>> the operating channel -- it should be before
>>>> so that drivers know this is the operating
>>>> channel again.
>>>>
>>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>>> ---
>>>>  net/mac80211/scan.c |    4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> --- wireless-testing.orig/net/mac80211/scan.c   2010-06-18 12:22:56.000000000 +0200
>>>> +++ wireless-testing/net/mac80211/scan.c        2010-06-18 12:23:25.000000000 +0200
>>>> @@ -287,6 +287,8 @@ void ieee80211_scan_completed(struct iee
>>>>        local->scanning = 0;
>>>>        local->scan_channel = NULL;
>>>>
>>>> +       drv_sw_scan_complete(local);
>>>> +
>>>>        /* we only have to protect scan_req and hw/sw scan */
>>>>        mutex_unlock(&local->scan_mtx);
>>>>
>>>> @@ -296,8 +298,6 @@ void ieee80211_scan_completed(struct iee
>>>>
>>>>        ieee80211_configure_filter(local);
>>>>
>>>> -       drv_sw_scan_complete(local);
>>>> -
>>>>        ieee80211_offchannel_return(local, true);
>>>>
>>>>  done:
>>>
>>> Leaving the entire patch in the e-mail reply as the patch is small to
>>> help with context.
>>>
>>> Turns out this patch broke ath9k in the sense that right after a scan
>>> we get disconnected from the AP. I just bisected wireless-testing by
>>> master-tag dates and found 2010-06-18 to be where we hit poo in. I
>>> reverted this patch and its cured. I'm going to test a recent
>>> wireless-testing now and then just try reverting this to see if its OK
>>> even on a recent wireless-testing, and then see if we can fix this
>>> properly on ath9k or whatever.
>>
>> Yeap, reverting this patch alone today on wireless-testing makes me
>> ath9k happy once again.
>
> So after some though and review in order to fix this we need a little
> more time and thought. The above patch changes the order in which we
> configure hardware upon a scan complete. It used to be we would
> configure the hardware, configure the filter and then scan complete.
> By then we'd be on the home channel and the filters would be set
> correctly. ath9k's scan complete routine does a few things which
> depend on the channel and will make hardware poo otherwise or do
> stupid things:
>
>  * start TX poll routine, due to the new latency introduced to
> configure hardware and configure the RX filter the TX polll routine
> now has some extra work done by hardware before it actually starts
> TXing. I don't suspect this could introduce a huge regression but it
> is worth noting.
>  * ANI gets started, and the wrong channel is used if we're not yet
> on the home channel. A simple patch to test if this may be causing the
> disconnect issue I am seeing I just tried was to increase the delay
> before starting ANI, this did indeed help.
>  * ath_beacon_config() which I suspect means that if we now scan in
> AP mode/IBSS mode we could potentially be leaking beacons on the last
> channel of a scan, prior to sending them on the actual desired home
> channel.

Fun enough reverting this change also created one side regression
caused by some new patch merged in 2.6.36-rc series (ath9k: prevent
calibration during off-channel activity). Since the scan was not yet
completed after reverting this patch the flag for scanning was still
true in ath9k when changing the to the last home channel, this mean
ath_beacon_config() for STA mode was not being called, and its
required since otherwise we do not set the beacon timers and get
disassociated after a bg scan.

I'll be addressing a fix for this next, but I just wanted to highlight
this for future scan completion work.

  Luis
