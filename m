Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41439 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1K1OVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 09:21:45 -0500
Received: by eaak14 with SMTP id k14so1832603eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 06:21:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322486285.4060.5.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322394638.4044.32.camel@jlt3.sipsolutions.net>
	<1322394800.4044.33.camel@jlt3.sipsolutions.net>
	<CALGY4fufCM2SvYLFaab1TzSr36b55bguFoZRtYZhLuXGMZLG1w@mail.gmail.com>
	<1322412918.4044.37.camel@jlt3.sipsolutions.net>
	<CANUX_P0E=bhBrGnYOJ7yt8mOgixNNPP5UKC_Cv5jL9uNiNFH9A@mail.gmail.com>
	<1322468173.4060.0.camel@jlt3.sipsolutions.net>
	<CANUX_P1c_-JcinU5iWiS5tZo-vvE+RECzW6P13S+JOfFAyH4Ag@mail.gmail.com>
	<1322486285.4060.5.camel@jlt3.sipsolutions.net>
Date: Mon, 28 Nov 2011 09:21:43 -0500
Message-ID: <CALGY4fvDa=8ppwAoSFhYP8Dd40xJ5nhsNUochQfbik9QU+ajtg@mail.gmail.com> (sfid-20111128_152152_443009_65EB40BD)
Subject: Re: [PATCH v3] mac80211: fix race condition caused by late addBA response
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/28 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2011-11-28 at 14:34 +0200, Emmanuel Grumbach wrote:
>> On Mon, Nov 28, 2011 at 10:16, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2011-11-28 at 08:35 +0200, Emmanuel Grumbach wrote:
>> >
>> >> > /*
>> >> >  * addba_resp_timer may have fired before we got here, and
>> >> >  * caused WANT_STOP to be set. If the stop then was already
>> >> >  * processed further, STOPPING might be set.
>> >> >  */
>> >> >
>> >> >
>> >> > Did you notice that I moved this code to after the dialog token check?
>> >> >
>> >>
>> >> Don't you think we should also send a delBA ? The AP thinks we will Tx
>> >> in Agg and basically we are now out of sync.
>> >
>> > We do, during the timer stop path, afaict.
>> >
>>
>> Yes, but obviously the AP didn't hear it since it sent the addBA resp.
>> IMHO, we should send it again.
>
> I don't think so? This is addressing a race between the timer &
> receiving the frame, so typically the delBA would not have gone out yet.

  IMHO if we hit the fact that timer has already gone off and we got
addba this normally means that we did send dellba. But it just didn't
have a chance to reach remote side before addba left if.
  On the other hand, even if other side doesn't get dellba eventually
(~5 seconds) it'll timeout rx session and we come to sync again. The
whole timer-vs-addba race doesn't happen that often, so this seems
acceptable.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
