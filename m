Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40675 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758650AbYHEBn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 21:43:26 -0400
Message-ID: <4897B037.5040300@lwfinger.net> (sfid-20080805_034342_803892_296F67E2)
Date: Mon, 04 Aug 2008 20:43:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Will Dyson <will.dyson@gmail.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
References: <200808041636.41189.IvDoorn@gmail.com> <8e6f94720808041821q760f8596g70a8ebc4c142989a@mail.gmail.com>
In-Reply-To: <8e6f94720808041821q760f8596g70a8ebc4c142989a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will Dyson wrote:
> On Mon, Aug 4, 2008 at 10:36 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> Hi John,
>>
>> Only 5 patches, but they do bump rt2x00 to a new version: 2.2.0
>> This series will add HW crypto support to rt2x00, by default it
>> has been enabled for rt61pci and rt73usb.
> 
> Seems to work well on my rt61pci card!
> 
> In fact, it reports a higher link quality (and maintains a higher
> bitrate) than the version in current wireless-testing. The quality
> report also fluctuates less than previously. This is consistent over a
> few hours of testing with streaming PCM audio.
> 
> I do get a lockdep warning when bringing up the device, however.
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.27-rc1-rt2-wl #1
> ---------------------------------------------
> rt61pci/4405 is trying to acquire lock:
>  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> ieee80211_scan_completed+0x172/0x320 [mac80211]
> 
> but task is already holding lock:
>  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> ieee80211_scan_completed+0x172/0x320 [mac80211]
> 

I get that same lockdep warning when using the mainline kernel with b43. It 
doesn't seem to cause any problems.

Larry

