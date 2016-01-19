Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:35046 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184AbcASUT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 15:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <1453234283.23600.5.camel@sipsolutions.net>
References: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
 <1453218163-31998-2-git-send-email-jprvita@endlessm.com> <1453234283.23600.5.camel@sipsolutions.net>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 19 Jan 2016 15:19:16 -0500
Message-ID: <CA+A7VXU3VDyMHWDjtqNgHDydCcEcEDFO-ZBGAZEz9CB2Lh1gPA@mail.gmail.com> (sfid-20160119_212018_702279_AF14F3BB)
Subject: Re: [PATCH 1/8] rfkill: Documentation and style fixes
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
	linux@endlessm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 January 2016 at 15:11, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>>  /**
>>   * rfkill_resume_polling(struct rfkill *rfkill)
>>   *
>> - * Pause polling -- say transmitter is off for other reasons.
>> + * Resume polling previously paused with rfkill_pause_polling.
>>   * NOTE: not necessary for suspend/resume -- in that case the
>> - * core stops polling anyway
>> + * core restarts polling anyway, even if was explicitly paused
>> + * before suspending.
>>   */
>
> If this is true, that's a bug, no? Drivers would call pause/resume when
> their status changes, and shouldn't be required to check status at
> resume time?
>

I did not dive too much into the logic here, but
rfkill_resume_polling() is called unconditionally on rfkill_resume(),
so it seems that if a driver call rfkill_pause_polling() before
suspend, on resume polling will be "un-paused". That indeed looks
strange.

--
João Paulo Rechi Vita
http://about.me/jprvita
