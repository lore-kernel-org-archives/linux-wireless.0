Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47673 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1K1Meh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 07:34:37 -0500
Received: by wwp14 with SMTP id 14so9009952wwp.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 04:34:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322468173.4060.0.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322394638.4044.32.camel@jlt3.sipsolutions.net>
	<1322394800.4044.33.camel@jlt3.sipsolutions.net>
	<CALGY4fufCM2SvYLFaab1TzSr36b55bguFoZRtYZhLuXGMZLG1w@mail.gmail.com>
	<1322412918.4044.37.camel@jlt3.sipsolutions.net>
	<CANUX_P0E=bhBrGnYOJ7yt8mOgixNNPP5UKC_Cv5jL9uNiNFH9A@mail.gmail.com>
	<1322468173.4060.0.camel@jlt3.sipsolutions.net>
Date: Mon, 28 Nov 2011 14:34:35 +0200
Message-ID: <CANUX_P1c_-JcinU5iWiS5tZo-vvE+RECzW6P13S+JOfFAyH4Ag@mail.gmail.com> (sfid-20111128_133441_587598_D9933184)
Subject: Re: [PATCH v3] mac80211: fix race condition caused by late addBA response
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nikolay Martynov <mar.kolya@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 28, 2011 at 10:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-11-28 at 08:35 +0200, Emmanuel Grumbach wrote:
>
>> > /*
>> >  * addba_resp_timer may have fired before we got here, and
>> >  * caused WANT_STOP to be set. If the stop then was already
>> >  * processed further, STOPPING might be set.
>> >  */
>> >
>> >
>> > Did you notice that I moved this code to after the dialog token check?
>> >
>>
>> Don't you think we should also send a delBA ? The AP thinks we will Tx
>> in Agg and basically we are now out of sync.
>
> We do, during the timer stop path, afaict.
>

Yes, but obviously the AP didn't hear it since it sent the addBA resp.
IMHO, we should send it again.
