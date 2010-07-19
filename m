Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48619 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966407Ab0GSVGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 17:06:38 -0400
Received: by fxm14 with SMTP id 14so2421507fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 14:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279571235.30478.5.camel@jlt3.sipsolutions.net>
References: <4C449C67.6010004@davizone.at> <1279571235.30478.5.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 19 Jul 2010 23:06:17 +0200
Message-ID: <AANLkTimxBt7dPcZrmAihWq9UKs77qS0cnAxQXIY_55ci@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Gnedt <david.gnedt@davizone.at>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 19, 2010 at 10:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-07-19 at 20:41 +0200, David Gnedt wrote:
>> The cfg80211_set_freq function now also saves the channel for monitor
>> interfaces.
>> This fixes a issue were the WEXT ioctl GIWFREQ doesn't report the correct
>> channel when the channel was switched in monitor mode.
>
> This is still wrong, as discussed previously on this list.
>
> johannes
>

And the conclusion was... ?


(BTW, I say that a GIWFREQ on a monitor interface should always return
the channel the PHY is tuned to at the moment when it is issued. Most
tools seem to expect this behavior.)
