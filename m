Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:51730 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469Ab3DHIB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 04:01:57 -0400
Message-ID: <51627793.1040505@lri.fr> (sfid-20130408_100202_322269_B6FDE101)
Date: Mon, 08 Apr 2013 09:53:55 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <50E400A7.5060100@lri.fr> <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr> <1359151524.4655.37.camel@jlt4.sipsolutions.net> <5103C774.4080403@lri.fr> <1359459469.8108.11.camel@jlt4.sipsolutions.net> <5107D5D5.3070601@lri.fr> <1359639241.8415.17.camel@jlt4.sipsolutions.net> <510A7D40.2030206@lri.fr> <1359642373.8415.57.camel@jlt4.sipsolutions.net> <20130407211654.GA6083@open-mesh.com>
In-Reply-To: <20130407211654.GA6083@open-mesh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2013 23:17, Antonio Quartulli wrote:
> Hi all,
> 
> let's resurrect this thread :)
> 
> On Thu, Jan 31, 2013 at 06:26:13AM -0800, Johannes Berg wrote:
>> On Thu, 2013-01-31 at 15:18 +0100, Nicolas Cavallari wrote:
>>
>>>> I think that's acceptable, but if it requires a wpa_s change anyway we
>>>> could just implement reboot detection there instead of adding all these
>>>> new events etc.? I.e. rather than having a new supplicant say "OK I will
>>>> listen to the right event when handling reboot detection", it could just
>>>> use the existing infrastructure and implement it itself?
>>>
>>> Well i already have wpa_supplicant patches for that. Might just need to clean that up a
>>> bit so it's at least configurable.
>>>
> 
> Would you mind sharing this code?

Well yes, i just need to untangle it with some other local policies ;)

> Maybe I can help and offload some work. :)
> Anyhow I did not understand how you can detect a node reboot from userspace if, as
> you stated, wpa_s is not able to distinguish encrypted from un-encrypted frames.

Well, you do it the same way as you do in the kernel, using auth frames. Except you're not
in the kernel.

>>> But now i'm reminded that transmitting management frames from userspace requires a
>>> frequency. For wpasupp to be race-free during ibss merges, we should have a way to
>>> transmit management frames to the current bss without specifying a frequency...
>>
>> That seems reasonable.
>>
> 
> This is a common problem I faced in other contexts too...

I sent a patch shorty after this message, trying to solve the problem, except Johannes
pointed out that it could still introduce races, at least in some non-mac80211 drivers,
the most problematic being ath6kl. I don't have any ath6kl hardware here, and i don't like
patching things that i can't test.
