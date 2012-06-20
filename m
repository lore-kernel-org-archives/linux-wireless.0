Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50783 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756608Ab2FTOez convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:34:55 -0400
Received: by lbgc1 with SMTP id c1so751653lbg.29
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 07:34:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340181856.4655.37.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-3-git-send-email-victorg@ti.com>
	<1340181856.4655.37.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 17:34:47 +0300
Message-ID: <CAK80WHbpCKu2VYQu+k05wYsWuJdMQwD2O8BxvQMCep0OKrushA@mail.gmail.com> (sfid-20120620_163458_719543_01D61E4B)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on op-channel
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

On Wed, Jun 20, 2012 at 11:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +     if ((!chan->radar_detect_timeout ||
>> +          time_is_after_jiffies(chan->radar_detect_timeout)) &&
>> +         (chan->flags & IEEE80211_CHAN_RADAR))
>> +             return -EPERM;
>
> Ok so you reject it if it's 0, but the jiffies calculation could return
> 0 too.. in fact, since jiffies start at -5 minutes on boot, you might
> even hit it if you start radar detection 4 minutes after boot.
>

good point, I will add additional flag to cover this corner case.

-- 
Thanks,
Victor.
