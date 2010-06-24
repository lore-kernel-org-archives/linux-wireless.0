Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12966 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0FXV5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 17:57:12 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Christian P. Schmidt" <schmidt@digadd.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275669638.2091.34633.camel@rchatre-DESK>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>
	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>
	 <4BFF9FC6.4030101@digadd.de>
	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de>
	 <1275045843.3909.92.camel@jlt3.sipsolutions.net>
	 <4C07D0C7.8010907@digadd.de>
	 <1275634104.3694.0.camel@jlt3.sipsolutions.net>
	 <1275669638.2091.34633.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 14:57:11 -0700
Message-ID: <1277416631.13673.91.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-04 at 09:40 -0700, reinette chatre wrote:
> On Thu, 2010-06-03 at 23:48 -0700, Johannes Berg wrote:
> > On Thu, 2010-06-03 at 17:56 +0200, Christian P. Schmidt wrote:
> > 
> > > > Maybe try the rfkill tool:
> > > > http://wireless.kernel.org/en/users/Documentation/rfkill
> > > 
> > > Yes, it was the rfkill tool that caused my attempts to fail. However,
> > > this didn't change my association attempt problems.
> > > I also took my time to look at the PCIe port - steady 3.3V on the RFKILL
> > > pin, which means "no RFKILL".
> > > 
> > > Any further ideas?
> > 
> > Unfortunately not. It would seem that something is causing your frames
> > not to be transmitted correctly, but I see no reason for that right now.
> 
> The logs provided contains a lot of useful information. Among this is
> that the device is unable to transmit data with the firmware returning a
> "TX_LOCKED" status. From what I understand this is a regulatory check
> failure based on the channel type, which does not make sense in this
> regard since from what I can tell channel 8, which is an active channel,
> is used. I passed this question to our firmware folks and now waiting
> for an answer.

Unfortunately, since the firmware does not actually assert, the firmware
folks are unable to dig into this. I tried to take a second look at your
logs and one thing that I was able to see that is interesting is that,
when scanning, the device picks up very few frames that are good. I see
that there were five scans, none of which contained a since good frame
on 5GHz. On 2.4GHz there was a bit better success, but not consistent.
In the five scans there was the following on 2.4GHz:
1st scan: one good frame each on channels 5, 7, and 8.
2st scan: one good frame on channel 1
3st scan: one good frame each on channels 2, 7, and 9.
4st scan: one good frame each on channels 3, 5, 7, and 8.
5st scan: one good frame each on channels 1, 8, and 9.

If you want to check on this yourself, take a look at the lines:
[223263.179493] ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res:
2 [802.11bg] (TSF: 0x00000000:05627B90) - 1 elapsed=33837 usec

The number before "elapsed" indicates the number of good frames seen
while scanning the channel. In the above example there was one.

This seems to indicate that there is some trouble on this platform ...
and makes me start thinking that this card may not work well on this
platform.

Some things you can try:
- are any APs on A band? If not, can you try to activate an AP on A band
to see if you have better success there?
- monitor the RX statistics ...
(/sys/kernel/debug/ieee80211/phy0/iwlagn/debug/ucode_rx_stats) to see if
there is an issue with crc checks and perhaps false alarms and plcp
also.
- something that you could try ... not sure how much it will help if you
are having noise issues ... is to vary how you scan. Since you know
which AP you are associating with, perhaps you can try to limit your
scan to that channel ... and also try passive instead of active. This
can be done with iw.

These are the only things I can think of.

Reinette



