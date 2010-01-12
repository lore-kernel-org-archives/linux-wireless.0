Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52499 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0ALQvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 11:51:50 -0500
Received: by pwj9 with SMTP id 9so2209507pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 08:51:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4C622F.1050602@openwrt.org>
References: <4B4ABB54.7030600@openwrt.org> <20100112093733.GA2548@mail.wantstofly.org>
	<4B4C622F.1050602@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 Jan 2010 08:51:30 -0800
Message-ID: <43e72e891001120851m335dc605wbbc81c6cd5b7a792@mail.gmail.com>
Subject: Re: mac80211: fix queue selection for data frames on monitor
	interfaces
To: Felix Fietkau <nbd@openwrt.org>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 3:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-01-12 10:37 AM, Lennert Buytenhek wrote:
>> On Mon, Jan 11, 2010 at 06:47:00AM +0100, Felix Fietkau wrote:
>>
>>> When ieee80211_monitor_select_queue encounters data frames, it selects
>>> the WMM AC based on skb->priority and assumes that skb->priority
>>> contains a valid 802.1d tag. However this assumption is incorrect, since
>>> ieee80211_select_queue has not been called at this point.
>>> If skb->priority > 7, an array overrun occurs, which could lead to
>>> invalid values, resulting in crashes in the tx path.
>>
>> What you describe here was already reported and fixed:
>>
>>       http://marc.info/?l=linux-wireless&m=126287290723244&w=2
>>       http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=045cfb71a3901005bf6dcedae98cecb3360a0bfc
>>
>> Your commit message could at least acknowledge this.  I.e. write
>> that the existing fix doesn't handle QoS data frames in the optimal
>> way, and then mention this:
> Sorry, when I wrote and posted the patch, I hadn't seen your previous
> fix yet, because I was apparently looking at the wrong tree and had not
> noticed your submission yet.
> It only cleanly applied to a tree without your change, but it seems that
> John fixed it up and replaced your fix with it anyway.

John, did the new changes by Felix get marked for stable too? From
what I gather they apply on top of each other and are stable material.

  Luis
