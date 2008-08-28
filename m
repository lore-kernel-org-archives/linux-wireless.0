Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:30336 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYH1J3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:40 -0400
Received: by ey-out-2122.google.com with SMTP id 6so87405eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 02:29:38 -0700 (PDT)
Message-ID: <1ba2fa240808280229t112639a8re10dc93c778aaf7d@mail.gmail.com> (sfid-20080828_115051_677190_920F044E)
Date: Thu, 28 Aug 2008 12:29:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200808281031.06529.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
	 <200808272225.10557.mb@bu3sch.de>
	 <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
	 <200808281031.06529.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 11:31 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 28 August 2008, Tomas Winkler wrote:
>> On Wed, Aug 27, 2008 at 11:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
>> > On Wednesday 27 August 2008, Tomas Winkler wrote:
>> >> > John W. Linville (1):
>> >> >      mac80211: quiet chatty IBSS merge message
>> >>
>> >> This patch is correct yet it suppresses an important warning, meaning
>> >> that you have constant IBSS reconnection, remove all connected station
>> >> and adding them again, This greatly degraded performance. This is
>> >> caused by inability to adjust to TSF of the IBSS leader
>> >>
>> >> <snipt>
>> >> static int ieee80211_sta_join_ibss(struct net_device *dev,
>> >>                                  struct ieee80211_if_sta *ifsta,
>> >>                                  struct ieee80211_sta_bss *bss)
>> >> .....
>> >> /* Remove possible STA entries from other IBSS networks. */
>> >>       sta_info_flush_delayed(sdata);
>> >> </snip>
>> >
>> > I fail to see how the TSF could be related to an ever reconnecting
>> > station. Can you elaborate on what happens?
>> >
>> > I was under the impression that the firmware would handle TSF stuff.
>> > Also the "IBSS leader" is a new thing to me. I remember from the specs
>> > that the device should accept the TSF from _any_ beacon. Not just a
>> > "leader". Am I mislead? :)
>>
>> What is happening that IBSS station should adopt TSF of  the oldest
>> station i.e. with highest
>> TSF. This is also leader of the IBSS (this is not spec definition just
>> local jargon)  Adaptation
>> mean we adjust to the same clock
>>
>> if (beacon_timestamp > rx_timestamp)
>>     merge
>
> Well, I was pretty sure the firmware did this for us.
> I can recheck that later.

Other option might that rx_timestamp is just not computed correctly
for your HW in the first place and then this code is triggered in the
mac.
Tomas
