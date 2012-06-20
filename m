Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:35151 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab2FTRRn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 13:17:43 -0400
Received: by lban1 with SMTP id n1so790348lba.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 10:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340182072.4655.41.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-5-git-send-email-victorg@ti.com>
	<1340182072.4655.41.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 20:17:39 +0300
Message-ID: <CAK80WHYpxpPftCcO0+Uv4meZOg7h5Ys1GfJFg2SQDf3AiiJMNg@mail.gmail.com> (sfid-20120620_191749_448067_55248EE1)
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

On Wed, Jun 20, 2012 at 11:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-19 at 16:11 +0300, Victor Goldenshtein wrote:
>
>> @@ -565,6 +565,15 @@
>>   *   the time passed sines the beginning of the CAC is less than
>
> interestingly now I see a typo in the previous patch: "sines"?
>
>
>>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
>> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
>
> what point is there in separating these flags?
>

One may support AP channel switch without DFS support, i.e. switching
to non DFS channels.

>
>> +     int     (*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
>> +                                  u32 count, bool block_tx,
>> +                                  bool post_switch_block_tx,
>> +                                  struct ieee80211_channel *new_ch);
>
> If mac80211 needs a struct, why not have one here already rather than
> all the parameters?
>

OK, it I will just require additional mac patch before current one, I
will split the "mac80211: add ap channel switch command/event".

-- 
Thanks,
Victor.
