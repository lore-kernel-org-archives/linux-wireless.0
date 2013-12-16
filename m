Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57138 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3LPO5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:57:52 -0500
Received: from [192.168.1.138] ([93.218.116.213]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LslCb-1VPww92w4P-012LMI for
 <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 15:57:51 +0100
Message-ID: <52AF14EC.9010803@rempel-privat.de> (sfid-20131216_155801_518313_40581FA6)
Date: Mon, 16 Dec 2013 15:57:48 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [BUG] P2P setup timeout
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>	<1387197416.4665.15.camel@jlt4.sipsolutions.net>	<CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>	<1387201528.2057.1.camel@jlt4.sipsolutions.net> <CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com>
In-Reply-To: <CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.12.2013 14:51, schrieb David Herrmann:
> Hi
> 
> On Mon, Dec 16, 2013 at 2:45 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:
>>
>>>> Can you check in a sniffer what the frame bitrates are that go out? This
>>>> seems suspicious:
>>>>
>>>> nl80211: Set TX rates failed: ret=-100 (Network is down)
>>>
>>> I looked at the sniffer data and all I see is a huge amount of p2p
>>> probe requests from my local device, the successful p2p-invitation and
>>> invitation response and then lots of go-negotiation requests that
>>> never get any response.
>>
>> Right, and I suspect they don't get a response because (as the sniffer
>> trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
>> in the P2P spec (must use OFDM).
>>
>> Thus something is wrong with the TX bitrates stuff, but I can't tell you
>> where that would be ...
> 
> Ok, I will try hooking into the ath9k driver then and see why setting
> TX rates fails. Thanks a lot! Maybe Oleksij has some more ideas on
> that.

ath9k_htc has it own rate controller insight of firmware. We wont to
move this functionality to the host and use minstreal-rt, but currently
this project is not started and currently there is no clear start time
:( Beside, there are more problems with FWs rate controller.

David, if you need to fix this bug, i would you suggest you to
investigate in firmware. I will help you as match as i can.

-- 
Regards,
Oleksij
