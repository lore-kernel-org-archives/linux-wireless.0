Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:45171 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZGRVTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 17:19:37 -0400
Received: by gxk9 with SMTP id 9so2779280gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2009 14:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A61E436.9060808@lwfinger.net>
References: <4A611FC0.9040507@lwfinger.net>
	 <200907181433.47985.chunkeey@web.de> <4A61E436.9060808@lwfinger.net>
Date: Sat, 18 Jul 2009 17:19:36 -0400
Message-ID: <b6c5339f0907181419h28b84166s72ba9386f2833c61@mail.gmail.com>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111) with
	p54usb
From: Bob Copeland <me@bobcopeland.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 18, 2009 at 11:03 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Christian Lamparter wrote:
>> On Saturday 18 July 2009 03:05:04 Larry Finger wrote:
>>> Johannes and Christian,
>>>
>>> I am getting a WARN_ON from mac80211 in the location stated in the
>>> subject. I put in some test prints and got the following:
>>>
>>> sband->n_bitrates 8, Band 1, supp_rates 0x0
>> hmm, so something decides to talk to a 5GHz network here?
>> But the AP doesn't have any available rates in that band!?
>
> Ah, band 1 is 5GHz, not 2.4. There are no 802.11a AP's in my neighborhood.
>
>> If my memory serves my right some people have triggered the same WARN_ON
>> with the ath5k driver as well...
>> unfortunately, I didn't follow the thread and now I can't find it anymore.
>>
>> (btw: is your b43 11a capable as well?)
>
> Yes it is, but that section is software crippled.
>
> Thanks for the patch. I'll let you know what happens.

In the ath5k case as well, I'm willing to bet it has something to do with dual
band operation.  IIRC at least some instances of this in the past were due to
getting the rate after the band was changed, e.g. due to scanning, and the peer
of course didn't support any rates on that band.

-- 
Bob Copeland %% www.bobcopeland.com
