Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59001 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216Ab2FUFfb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 01:35:31 -0400
Received: by obbuo13 with SMTP id uo13so427341obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 22:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340213979.4655.78.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-5-git-send-email-victorg@ti.com>
	<1340182072.4655.41.camel@jlt3.sipsolutions.net>
	<CAK80WHYpxpPftCcO0+Uv4meZOg7h5Ys1GfJFg2SQDf3AiiJMNg@mail.gmail.com>
	<1340213979.4655.78.camel@jlt3.sipsolutions.net>
Date: Thu, 21 Jun 2012 08:35:29 +0300
Message-ID: <CAK80WHabv2ajEKREHLgnrezs7ydjpyOXWq7DNQOtdaA0WsCELA@mail.gmail.com> (sfid-20120621_073534_681924_B7CC693A)
Subject: Re: [PATCH v2 5/7] nl80211/cfg80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 8:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-20 at 20:17 +0300, Goldenshtein, Victor wrote:
>
>> >>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
>> >> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
>> >
>> > what point is there in separating these flags?
>> >
>>
>> One may support AP channel switch without DFS support, i.e. switching
>> to non DFS channels.
>
> Oh, right, makes sense, though I'd enforce that DFS must support
> chanswitch?
>

we already do that, hostapd can start working on DFS channels only if
both flags are set.

>> >
>> >> +     int     (*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
>> >> +                                  u32 count, bool block_tx,
>> >> +                                  bool post_switch_block_tx,
>> >> +                                  struct ieee80211_channel *new_ch);
>> >
>> > If mac80211 needs a struct, why not have one here already rather than
>> > all the parameters?
>> >
>>
>> OK, it I will just require additional mac patch before current one, I
>> will split the "mac80211: add ap channel switch command/event".
>
> Well, you'll have to move the struct definition into cfg80211 and into
> this patch I think.
>

The STA channel switch struct (struct ieee80211_channel_switch) is
defined in mac80211.h, thus I think the new struct for the ap channel
switch should be also there, I will just split the mac patch into two.


And, almost forgot, thanks for reviewing so many patches in one day ;-)

-- 
Victor.
