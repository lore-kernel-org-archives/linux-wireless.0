Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4164 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab0DJI5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 04:57:08 -0400
Message-ID: <4BC03D61.1010501@gmail.com>
Date: Sat, 10 Apr 2010 10:57:05 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 4/9] rt2x00: Remove rt2800 version constants.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> 	<1270763437-29526-5-git-send-email-gwingerde@gmail.com> <201004090032.53842.IvDoorn@gmail.com> 	<j2p646765f41004081653vcb4e0178k374a203da36a9f1@mail.gmail.com> 	<k2ra32f33a41004082354y2bf33919y7f0f476b62612cf6@mail.gmail.com> <h2t646765f41004090000o607f02al34df4b3556019a24@mail.gmail.com>
In-Reply-To: <h2t646765f41004090000o607f02al34df4b3556019a24@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 09:00, Julian Calaby wrote:
> On Fri, Apr 9, 2010 at 16:54, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
>> On Fri, Apr 9, 2010 at 1:53 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>> On Fri, Apr 9, 2010 at 08:32, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>>>> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>>>>> The rt2800 version constants are inconsistent, and the version number don't
>>>>> mean a lot of things anyway. Use the literal values in the code instead of
>>>>> some sort of fabricated version name macro.
>>>>>
>>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>>
>>>> Perhaps a more elegant way of using and defining needs to be found.
>>>> But at least the defined show what the purpose for the values is
>>>> rather then having magical values spread around the code.
>>>
>>> Maybe something like:
>>>
>>> #define RTDEV_IS_RT2883_R1(dev) (rt2x00_rt(dev, RT2883) && \
>>>                                                   rt2x00_rev(dev) < 0x0300)
>>
>> I considered this as well, but we have many checks which either do
>>    rt2x00_rev() < 0xffff
>> but also
>>    rt2x00_ref() == 0xffff
> 
> I assume that there are certain ranges of revisions that correspond to
> certain chips with certain ... features. So, you could have:
> 
> #define RTDEV_IS_RT2883_R1(dev) (rt2x00_rt(dev, RT2883) && \
>                                                   rt2x00_rev(dev) < 0x0300)
> 
> for the original chip, then
> 
> #define RTDEV_IS_RT2883_R2(dev) (rt2x00_rt(dev, RT2883) && \
>                                                   rt2x00_rev(dev) >= 0x0300 && \
>                                                   rt2x00_rev(dev) < 0x1000)
> 
> for the troubled second version and
> 
> #define RTDEV_IS_RT2883_R3(dev) (rt2x00_rt(dev, RT2883) && \
>                                                   rt2x00_rev(dev) >= 0x1000)
> 
> as a catch all for newer chips.

OK. After spending the entire morning trying to understand the Ralink numbering scheme,
I think I have come up with some sensible constant naming scheme and a set of helpers
to clarify the code. As you can see below there is no constant numbering scheme for all
chipsets, and the revision codes are chipset specific.

First of all, we would define the following chipset revision constants:

#define REV_RT2860C	0x0100
#define REV_RT2860D	0x0101
#define REV_RT2870D	0x0101
#define REV_RT2872E	0x0200
#define REV_RT3070E	0x0200
#define REV_RT3070F	0x0201
#define REV_RT3071E	0x0211
#define REV_RT3090E	0x0211
#define REV_RT3390E	0x0211

Next, we would create three helper functions:

bool rt2x00_rt_rev(struct rt2x00_dev *rt2x00dev, u16 rt, u16 rev);
bool rt2x00_less_than_rt_rev(struct rt2x00_dev *rt2x00dev, u16 rt, u16 rev);
bool rt2x00_at_least_rt_rev(struct rt2x00_dev *rt2x00dev, u16 rt, u16 rev);

This would cover all the usages that we currently have inside the code.

Obviously more can be added once needed.

Are you guys OK with this proposal?
If yes, I'll update the series to change the version constants removal
patch into a patch converting to the above scheme.

---
Gertjan.
