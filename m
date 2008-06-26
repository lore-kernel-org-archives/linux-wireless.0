Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:54721 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYFZVv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:51:58 -0400
Received: by rv-out-0506.google.com with SMTP id k40so232542rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 14:51:58 -0700 (PDT)
Message-ID: <1ba2fa240806261451n53e5cb8an70aad7b072121c2e@mail.gmail.com> (sfid-20080626_235207_205592_0C5E272B)
Date: Fri, 27 Jun 2008 00:51:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: add power management support
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Samuel Ortiz" <samuel@sortiz.org>,
	"=?ISO-8859-1?Q?Miguel_Bot=F3n?=" <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <1214504623.3783.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711161929.36283.mboton.lkml@gmail.com>
	 <200711161953.26801.mboton.lkml@gmail.com>
	 <20080626174058.GA3063@sortiz.org>
	 <20080626175507.GA23142@tuxdriver.com>
	 <1214504623.3783.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 9:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-26 at 13:55 -0400, John W. Linville wrote:
>> On Thu, Jun 26, 2008 at 07:40:58PM +0200, Samuel Ortiz wrote:
>> > Hi John,
>> >
>> > On Fri, Nov 16, 2007 at 07:53:26PM +0100, Miguel Bot=F3n wrote:
>> > > Ok, the previous patch had a little error.
>> > >
>> > > --
>> > >
>> > > This patch adds power management support in mac80211.
>> > Sorry for being late to the game, but would a similar patch agains=
t your
>> > -next-2.6 tree be considered for inclusion ?
>>
>> It seems like a reasonable start to me.  Anyone else have comments?
>
> I had one about it returning -EINVAL for all errors that was never
> addressed afaict.

Didn't Yi submitted this one like year ago and rejected?

This is why we have currently implemented in iwlwif sysfs.

/sys/class/net/wlanX/devices/power_level
there are defined 6 power levels
0 - CAM mode (Continuous Aware Mode)
6 - AUTO
1 to 5 levels that specifies power save aggressiveness  empirically dev=
eloped.
AUTO - depends on system power source/level
system power level is AC or BATTERY  - currently we do not have
anything that tells us whether we run on battery or ac.
Other factor is association state.

This can be expressed as
iwconfig power saving 1..5
iwconfig power off - > CAM mode
iwconfig power auto - this is unfortunately not defined by iwconfig

If this acceptable we can submit the patch

Thanks
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
