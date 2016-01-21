Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248AbcAUOon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 09:44:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arend van Spriel <arend@broadcom.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2] wl1251: add sysfs interface for bluetooth coexistence mode configuration
References: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
	<5696D08F.9030906@broadcom.com> <20160114091654.GA15380@amd>
	<20160121085331.GO7192@pali> <87d1svyrfl.fsf@kamboji.qca.qualcomm.com>
	<20160121135110.GH7192@pali>
Date: Thu, 21 Jan 2016 16:44:33 +0200
In-Reply-To: <20160121135110.GH7192@pali> ("Pali =?utf-8?Q?Roh=C3=A1r=22's?=
 message of "Thu, 21
	Jan 2016 14:51:10 +0100")
Message-ID: <871t9byotq.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_154504_955187_E64D6862)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár <pali.rohar@gmail.com> writes:

> On Thursday 21 January 2016 15:48:14 Kalle Valo wrote:
>> Pali Rohár <pali.rohar@gmail.com> writes:
>> 
>> > On Thursday 14 January 2016 10:16:54 Pavel Machek wrote:
>> >> On Wed 2016-01-13 23:32:47, Arend van Spriel wrote:
>> >> > On 12/26/2015 12:45 PM, Pali Rohár wrote:
>> >> > >Port the bt_coex_mode sysfs interface from wl1251 driver version included
>> >> > >in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
>> >> > >This enables userspace applications to set one of the modes
>> >> > >WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
>> >> > >The default mode is WL1251_BT_COEX_OFF.
>> >> > >It should be noted that this driver always enabled bt-coexistence before
>> >> > >and enabled bt-coexistence directly affects the receiving performance,
>> >> > >rendering it unusable in some low-signal situations. Especially monitor
>> >> > >mode is affected very badly with bt-coexistence enabled.
>> >> > 
>> >> > So what user-space process will be using this interface. Did you consider
>> >> > adding debugfs interface? In case of monitor mode you could consider
>> >> > disabling bt-coex from within the driver itself.
>> >> 
>> >> This aint no debugging feature.
>> >
>> > Right, bt-coex is not for debugging purpose, but for normal usage, when
>> > user want to use together bluetooth and wifi or just one of those.
>> 
>> I think most of other drivers have a debugfs interface for btcoex, I
>> guess mostly for testing purposes. But this really should be added to
>> cfg80211.
>
> All other TI wireless drivers have "bt_coex_state" sysfs node.

Then that's a mistake, they shouldn't have that.

-- 
Kalle Valo
