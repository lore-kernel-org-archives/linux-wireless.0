Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59004 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3LPPJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:09:38 -0500
Received: by mail-ig0-f179.google.com with SMTP id hk11so3959051igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 07:09:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52AF14EC.9010803@rempel-privat.de>
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	<1387197416.4665.15.camel@jlt4.sipsolutions.net>
	<CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>
	<1387201528.2057.1.camel@jlt4.sipsolutions.net>
	<CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com>
	<52AF14EC.9010803@rempel-privat.de>
Date: Mon, 16 Dec 2013 16:09:37 +0100
Message-ID: <CANq1E4S+u6UZf15fU9aO6JvY4OTE+RnOKGL0K16T9A_4vr+C6A@mail.gmail.com> (sfid-20131216_160952_591745_5D51F2D3)
Subject: Re: [BUG] P2P setup timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Dec 16, 2013 at 3:57 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 16.12.2013 14:51, schrieb David Herrmann:
>> Hi
>>
>> On Mon, Dec 16, 2013 at 2:45 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:
>>>
>>>>> Can you check in a sniffer what the frame bitrates are that go out? This
>>>>> seems suspicious:
>>>>>
>>>>> nl80211: Set TX rates failed: ret=-100 (Network is down)
>>>>
>>>> I looked at the sniffer data and all I see is a huge amount of p2p
>>>> probe requests from my local device, the successful p2p-invitation and
>>>> invitation response and then lots of go-negotiation requests that
>>>> never get any response.
>>>
>>> Right, and I suspect they don't get a response because (as the sniffer
>>> trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
>>> in the P2P spec (must use OFDM).
>>>
>>> Thus something is wrong with the TX bitrates stuff, but I can't tell you
>>> where that would be ...
>>
>> Ok, I will try hooking into the ath9k driver then and see why setting
>> TX rates fails. Thanks a lot! Maybe Oleksij has some more ideas on
>> that.
>
> ath9k_htc has it own rate controller insight of firmware. We wont to
> move this functionality to the host and use minstreal-rt, but currently
> this project is not started and currently there is no clear start time
> :( Beside, there are more problems with FWs rate controller.
>
> David, if you need to fix this bug, i would you suggest you to
> investigate in firmware. I will help you as match as i can.

Thanks, I tracked down the ENETDOWN. I'm not entirely sure but I think it's:

net/mac80211/cfg.c: ieee80211_set_bitrate_mask():
  if (!ieee80211_sdata_running())
    return -ENETDOWN;

I'm not sure what exactly the SDATA_RUNNING flag is for here, so I
cannot tell whether removing this check will fix it. I can give it a
try though. The function seems pretty simple and passive (except if
HW_HAS_RATE_CONTROL is set, which ath9k_htc probably has..).

The wpa_supplicant counter-part is src/drivers/driver_nl80211.c
obviously. The failing call is in:
  nl80211_disable_11b_rates(drv, ifidx, 1)
It is called from:
  nl80211_create_iface() with iftype==P2P_CLIENT

Which is weird, because according to the kernel sources you need
SDATA_RUNNING set (which is guess is not the case after the iface has
just been created as it mirrors netdev-UP right?). So we either need
to start the iface in wpa_supplicant or remove the flag from the
kernel helper, I guess. I will try some hacks..

@Oleksij, I actually have three ath9k-htc devices so I'd like to get
this working, and the devices are really nice apart from this bug. I
will keep you up to date, but if you have any hints where to continue
digging, lemme know. Until it's fixed, I'll just work on
wired-displays via ethernet instead of wifi-displays..

Thanks
David
