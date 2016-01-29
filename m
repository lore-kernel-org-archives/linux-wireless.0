Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32986 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbcA2Tmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 14:42:55 -0500
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
To: Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
 <1453983185.2217.12.camel@sipsolutions.net>
 <CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
 <1454013625.2332.9.camel@sipsolutions.net>
 <CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
 <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
 <1454019155.2332.15.camel@sipsolutions.net>
 <CA+55aFxjpdepHYD_6uU48kW38Z9bmf2wwA8yPZt4ibhkofmfQA@mail.gmail.com>
 <56AAC66C.1080800@lwfinger.net> <1454056380.3369.2.camel@sipsolutions.net>
 <CAP71bdVZzUUNwP3py_m1pwU21qMKth=0BmMfLuUb7=B-1840zg@mail.gmail.com>
 <1454084146.2800.0.camel@sipsolutions.net> <56ABA73C.1060504@lwfinger.net>
 <CA+55aFysqqp-BCZs1ue6_1tE=h9SOUZTH_o7TwGbsaBnaFvXGA@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56ABC0BC.9010202@lwfinger.net> (sfid-20160129_204259_634646_F6E902AC)
Date: Fri, 29 Jan 2016 13:42:52 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFysqqp-BCZs1ue6_1tE=h9SOUZTH_o7TwGbsaBnaFvXGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2016 12:39 PM, Linus Torvalds wrote:
> On Fri, Jan 29, 2016 at 9:54 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> The test patch that Johannes sent earlier was close. The section needed to
>> add VHT rates is:
>
> Hmm. This looks pretty much exactly like what I already tried (I had
> fixed Johannes' patch to use "vht_cap" already, since it didn't
> compile otherwise).
>
> So the only difference is that it only checks WIRELESS_MODE_AC_5G.
>
> But it worked for me this time. I have no idea why.
>
> Maybe Johannes' patch actually always worked for me, but I just had a
> transient problem that made me think it didn't. I think I only booted
> it once, and went "oh, ok, no network, that didn't work".

Thanks for testing.

Upon reflection, it really should check the other WIRELESS_MODE_AC_x bits. 
Johannes' patch was indeed correct.

With my AP setup changed, I get about 100 Mb/s RX using netperf. TX is still bad.

@Johannes: OK if I make you the author of the final version of the patch?

Larry



