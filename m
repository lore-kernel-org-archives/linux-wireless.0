Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:34271 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934Ab2FTNcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 09:32:50 -0400
Received: by eaai12 with SMTP id i12so2517616eaa.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 06:32:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340197920.4655.62.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-3-git-send-email-victorg@ti.com>
	<1340181856.4655.37.camel@jlt3.sipsolutions.net>
	<1340181992.4655.39.camel@jlt3.sipsolutions.net>
	<4FE1B9CB.2090206@neratec.com>
	<1340193471.4655.57.camel@jlt3.sipsolutions.net>
	<4FE1C8EC.4040902@neratec.com>
	<1340197920.4655.62.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 16:32:47 +0300
Message-ID: <CAK80WHZjvUPvzdKARJF9Z4yOuK8AJW=4v4rWN7ozEU8pyAqg_Q@mail.gmail.com> (sfid-20120620_153256_623225_C5503DAC)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 4:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-20 at 14:58 +0200, Zefir Kurtisi wrote:
>
>> >> No, if you bring it back up on the same DFS channel,
>> >> radar_detection_timeout will be set back to +60s by
>> >> start_radar_detection(). Looks safe to me.
>> >
>> > You need to think a bit more outside the regular code flows ... What if
>> > I'm not calling start_radar_detection()?
>
>> If you are not calling start_radar_detection() you are not using
>> hostapd. With the design approach we agreed on (when we initially
>> discussed DFS years ago) to have all the logic located in hostapd, it is
>> inevitable that those who intentionally want to bypass DFS regulatory
>> restrictions actually can. You can always replace hostapd by some
>> component that handles DFS control without caring the wait times.
>
> But this kernel patch is attempting to enforce the wait time. Are you
> saying it shouldn't even pretend to enforce it?
>

It's not just attempts, it's ensures that no transmission will occur
until we perform a radar detection on the channel.
It's doesn't matter if the usermode use hostapd or some other applications.

-- 
Thanks,
Victor.
