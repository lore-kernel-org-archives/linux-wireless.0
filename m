Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flokli.de ([78.46.104.9]:37430 "EHLO asterix.flokli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475Ab0GPXWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 19:22:32 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: commit 062bee448bd539580ef9f64efe50fdfe04eeb103 broke my iwlagn  5100
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Sat, 17 Jul 2010 01:22:30 +0200
From: Florian Klink <flokli@flokli.de>
Cc: Florian Klink <flokli@flokli.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-ID: <a10a4c76a95e1b3694489f0447967b94@imap.flokli.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 14 Jul 2010 10:44:21 -0700, "Guy, Wey-Yi"
<wey-yi.w.guy@intel.com> wrote:
> Hi Florian,
> 
> On Wed, 2010-07-14 at 10:36 -0700, Johannes Berg wrote:
>> On Wed, 2010-07-14 at 10:27 -0700, Guy, Wey-Yi wrote:
>> > Johannes,
>> >
>> > On Wed, 2010-07-14 at 09:36 -0700, Florian Klink wrote:
>> > > Hi,
>> > >
>> > > I did a dmesg with 2.6.35-rc5 and debug=0x43fff.
>> > > You can get it here: http://pastebin.com/Q6eCdPZR
>> >
>> > >
>> > >
>> > based on the log sent by Florian, I did not see bss_info_change with
>> > current BSSID from mac80211. any thought?
>> >
>> > I am expected to see something like this,
>> >
>> > [165796.572969] ieee80211 phy3: U iwl_bss_info_changed changes =
>> > 0xFD
>> > [165796.572972] ieee80211 phy3: U iwl_bss_info_changed BSSID
>> > 00:25:9c:d0:9f:e1
>> > [165796.572976] ieee80211 phy3: U iwl_bss_info_changed ERP_PREAMBLE 1
>>
>> That'd only happen _after_ association, not before, and assoc fails
>> here.
>>
> Could you try different channel instead of channel 12 to see if the
> problem still there?
> 
> Thanks
> Wey
>>


Hi,

very strange, now I can't reproduce the problem anymore, association
works with channel 12 and other ones, too!
I have no idea why it's now working...

Could this commit affect any link tolerance/timeouts, because I was
able to bisect the problem?

Florian

