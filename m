Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48593 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbbBIV2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 16:28:02 -0500
Received: by mail-qg0-f48.google.com with SMTP id a108so23763539qge.7
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 13:28:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJAp7OjLDCzLYeb3LHNs1sOHWM64XZWzr46UQ2vNirH_2JibNg@mail.gmail.com>
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
	<20150118051111.31866.39208.stgit@114-36-241-182.dynamic.hinet.net>
	<CAJAp7OhcFTuYfc7JOKW1SrVRbucuSWg5jcFaoVnSDgBxsyo2ng@mail.gmail.com>
	<CAAfg0W6dPupGLgwDF5FtNqEFvC4Y+GvFBAmXWcUQwXr2y6KugQ@mail.gmail.com>
	<CAJAp7OjLDCzLYeb3LHNs1sOHWM64XZWzr46UQ2vNirH_2JibNg@mail.gmail.com>
Date: Tue, 10 Feb 2015 05:28:01 +0800
Message-ID: <CAAfg0W58Wssa=OKRSGtxY4rQJCzP0uTw__Rd278fc1v7Q0fqUw@mail.gmail.com> (sfid-20150209_222809_275215_CCB27216)
Subject: Re: [PATCH 6/7] net: wireless: wcn36xx: remove powersaving for wcn3620
From: Andy Green <andy.green@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: netdev <netdev@vger.kernel.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 February 2015 at 05:11, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Feb 9, 2015 1:07 PM, "Andy Green" <andy.green@linaro.org> wrote:
>>
>> On 10 February 2015 at 01:54, Bjorn Andersson <bjorn@kryo.se> wrote:
>> > On Sat, Jan 17, 2015 at 9:11 PM, Andy Green <andy.green@linaro.org>
>> > wrote:
>> >> WCN3620 powersaving mode is not stable.  Disable it if we're
>> >> on a wcn3620 chip type.
>> >>
>> >> Signed-off-by: Andy Green <andy.green@linaro.org>
>> >> ---
>> >>  drivers/net/wireless/ath/wcn36xx/main.c |    4 ++++
>> >>  1 file changed, 4 insertions(+)
>> >>
>> >> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c
>> >> b/drivers/net/wireless/ath/wcn36xx/main.c
>> >> index c4178c7..569d45b 100644
>> >> --- a/drivers/net/wireless/ath/wcn36xx/main.c
>> >> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>> >> @@ -924,6 +924,10 @@ static int wcn36xx_init_ieee80211(struct wcn36xx
>> >> *wcn)
>> >>                 IEEE80211_HW_AMPDU_AGGREGATION |
>> >>                 IEEE80211_HW_TIMING_BEACON_ONLY;
>> >>
>> >> +       /* 3620 powersaving currently unstable */
>> >> +       if (wcn->chip_version == WCN36XX_CHIP_3620)
>> >> +               wcn->hw->flags &= ~IEEE80211_HW_SUPPORTS_PS;
>> >> +
>> >
>> > Hi Andy,
>> >
>> > I have the same problem (Data Abort Exception in wcnss) on 3680, this
>> > with my wip smd code and a hacked up remoteproc-pil. I haven't spent
>> > any effort on debugging this, but it looks like it's something related
>> > to what we have ported to mainline (or lack thereof) rather than a
>> > 3620 specific issue.
>>
>> Makes sense since I only have 3620, I assumed it's related to that.
>>
>> However he can work for a while with powersaving on, but ping
>> latencies are +600-800ms and he's shaky.
>>
>> Later I found something mac80211 generic scan preparation or post-scan
>> code (for scan initiated by wpa_supplicant) is able to stop wlan
>> traffic after a few goes even if the actual scan mode smd is not sent.
>>
>> At that point I think a nice solution would be a donation of time from
>> guys who specialize in wcn for a living to come and hand out a pony or
>> two...
>>
>
> I agree, my goal is that we get this running in mainline (smd, smsm, smp2p
> and remoteproc-tz) so that people with the domain knowledge can go in and
> make it work well.

Sounds great thanks.

I also tried hostapd which is fully workable without encryption, plus
or minus the instabilities mentioned.  But for wpa, he chokes trying
to inject a packet.  So it's another pony needed from somewhere.

Can I ask if smdtty will also appear?  I uplevelled and hacked smdtty
a bit from a 3.10 reference tree for 8916-qrd, and I was able to get
wcn3620 BT working stably for BT keyboard + mouse and even ad2p.

However the hack bound together smdtty ch2 + 3 in smdtty driver and
made it understand about the missing hci protocol byte... this is far
from reasonable for upstream, but it works like the 3.10 except needs
no special bluez / userland treatment.  So I'm curious if no smdtty
how the split smd hci / acl link in firmware will appear coherently to
userspace as a normal uart.

-Andy

> Regards,
> Bjorn
