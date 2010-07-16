Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:42735 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0GPRNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 13:13:05 -0400
Received: by pxi14 with SMTP id 14so1007056pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 10:13:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C402360.5050502@marvell.com>
References: <4C3F0AA3.4050706@marvell.com> <AANLkTiljhQpDh_20zEf8HjYnk82BpUi4Gctu9G90aqpS@mail.gmail.com>
	<4C402360.5050502@marvell.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Jul 2010 10:12:44 -0700
Message-ID: <AANLkTim2fLLZfD5xrUtioY5mZaF-PgLwrVlMHQHwsL41@mail.gmail.com>
Subject: Re: [RFC] mac80211: indicate BA window size with IEEE80211_AMPDU_TX_OPERATIONAL
	drv_ampud_action
To: yogeshp <yogeshp@marvell.com>
Cc: Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 16, 2010 at 2:16 AM, yogeshp <yogeshp@marvell.com> wrote:
> Hi Luis,
>  Please see inline comments
>
> Luis R. Rodriguez wrote:
>> On Thu, Jul 15, 2010 at 6:18 AM, yogeshp <yogeshp@marvell.com> wrote:
>>> BA window size for a successful BA setup is not made available to the driver by
>>> mac80211. The patch below gets the BA window size from addba response and
>>> indicates it to driver through IEEE80211_AMPDU_TX_OPERATIONAL drv_ampdu_action.
>
>> But why do you want that? Your patch and commit log do not mention why
>> you need this.
> BA window size from ADDBA response defines how many outstanding MPDUs are allowed for the BA stream by recipient. Since ADDBA response is processed in mac80211 stack, mac80211 should communicate the BA window size to driver (and may be from driver it is further communicated to firmware/hardware) to control the number of outstanding MPDUs while transmitting MPDUs for the stream.

What driver requires this? Your patch does all these changes but do
not show any secondary patch of a user, so the patch is pointless
right now.

>> When I compile mac80211 with your patch it fails compilation
> I do not see this compilation error, I think the patch did not apply cleanly. I will send out another patch without extra white spaces that should solve the compilation issue. If the change is fine, we can then send patches to fix the compilation issues for other drivers too.
>

..

  Luis
