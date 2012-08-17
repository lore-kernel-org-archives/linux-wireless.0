Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:24003
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab2HQR4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 13:56:43 -0400
Message-ID: <502E85D9.5050301@posedge.com> (sfid-20120817_195647_536324_7DDEF7DF)
Date: Fri, 17 Aug 2012 23:26:41 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local> <20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com> <20120817140657.GA1645@redhat.com>
In-Reply-To: <20120817140657.GA1645@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/17/2012 7:36 PM, Stanislaw Gruszka wrote:
> On Thu, Aug 16, 2012 at 06:47:09PM +0530, Mahesh Palivela wrote:
>> On 8/16/2012 3:52 PM, Stanislaw Gruszka wrote:
>>> On Tue, Aug 14, 2012 at 03:55:26PM +0000, Mahesh Palivela wrote:
>>>> Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac) Regulatory
>>>> and setting channel flags for allowed bandwidths.
>>>>
>>>> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
>>>> ---
>>>>
>>>> Sending patch second time as Stanislaw Gruszka complained its malformed.
>>>
>>> And now complaining that patch is ugly. There is really on other,
>>> simpler way to handle that?
>>>
>>> Stanislaw
>>>
>> oh, you mean my implementation is ugly? Not a problem. Give me some
>> clue, I will work on it.
>
> We can not extend channel, if regulatory disallow to use some
> nearby channels or disallow HT at all.
>
> So it's not possible that for particular channel that we can extend it
> to let say -160|0+ and -0|160+, but can not extend it to -40|120+. So
> we do not need zilion flags, but just specify left and right borders,
> inside which we can extend channel.
>
> For example: channel 36 (5180 MHz) is prohibited and all channels
> above are allowed. For channel 52 (5260 MHz) left border will be
> -60 and right border +160 (max). That will allow to support
> VHT160: -60|100+, -40|120+, -20|140+, -0|160+ ;
> VHT80: -60|20+, -40|40+, -20|60+, -0|80+ ;
> HT40 :-40|0+, -0|40+
>
> Stanislaw
>
Thanks for the description. I will get back to you soon.
-- 
Thanks,
Mahesh
