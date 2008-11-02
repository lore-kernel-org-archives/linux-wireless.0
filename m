Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:17249 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYKBWdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 17:33:46 -0500
Message-ID: <43e72e890811021433q61fe925bt5817f9e1ab0ba581@mail.gmail.com> (sfid-20081102_233349_867409_7287B6FD)
Date: Sun, 2 Nov 2008 14:33:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	michael+ath5k@stapelberg.de, linville@tuxdriver.com
In-Reply-To: <20081102215218.GA6203@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
	 <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com>
	 <20081102215218.GA6203@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 1:52 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Nov 02, 2008 at 01:00:27PM -0800, Luis R. Rodriguez wrote:
>> >, and, since
>> > 63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup", we do not fall back to the basic rate, such packets would trigger
>> > the following WARN_ON:
>>
>> So its slow because using rate 0 takes a while? If indeed you don't
>> see a valid use for this rate I'd say to completely disallow it and
>> use BUG_ON() on it.
>
> Not sure I follow - these are incoming frames, which all had a status_0
> of 0x1a40 (rs_more=0x1000 & length=0xa40).  So hw rate index was zero
> on these for some reason, but in my testing the rate index of all other
> packets was something reasonable, e.g. 0x27.

Interesting -- I will have to check on what this means.

> I looked over the rate tables compared to hal-legacy; I think what we
> have now is correct, just the old ath5k code in hw_to_driver_rix would
> set rate=1 for any hw rate index that we didn't know about:
>
> -       /* Something went wrong, fallback to basic rate for this band */
> -       if ((mac80211_rix >= sc->curband->n_bitrates) ||
> -               (mac80211_rix <= 0 ))
> -               mac80211_rix = 1;
>
> That's gone now, and that's why we didn't have the WARN_ON previously.
>
> For TX-side, I think we don't use rate 0 already since Bruno's cleanup,
> we should just use the hw_value fields in ath5k_rates which are all
> nonzero.

Oh ok thanks.

  Luis
