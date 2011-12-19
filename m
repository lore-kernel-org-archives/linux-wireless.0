Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LSQiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:38:51 -0500
Received: by dajs34 with SMTP id s34so3523544daj.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 08:38:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324310187.3414.4.camel@jlt3.sipsolutions.net>
References: <1324291194-28203-1-git-send-email-helmut.schaa@googlemail.com>
	<1324310187.3414.4.camel@jlt3.sipsolutions.net>
Date: Mon, 19 Dec 2011 17:38:50 +0100
Message-ID: <CAGXE3d8DR1MhzM6Hykx37VfWpwtRFBCNxnaA0j=x1XNvfdfVxQ@mail.gmail.com> (sfid-20111219_173854_257354_D03A88AE)
Subject: Re: [PATCH] mac80211: Remove superfluous ieee80211_rx_h_remove_qos_control
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 4:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-12-19 at 11:39 +0100, Helmut Schaa wrote:
>> This seems to not serve any purpose anymore, at least all frame
>> processing afterwards seems to be able to deal with QoS frames. So,
>> let's save the expensive memmove and just leave the QoS header in the
>> 802.11 frame for further processing.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>
>> It wouldn't hurt if a second pair of eyes looks through the rx path
>> to see if there's any possible problem with QoS frames in later rx
>> handlers.
>
> Ok, but I'm on vacation until next year, so I don't know if I'll get to
> it.

Sure, have a nice holiday.

> In principle, this seems fine, but I'd feel more comfortable if
> somebody else took another look. Not that I don't trust you, just more
> eyes see more things :-)

No worries, I'd also like to have somebody else looking through
the code since it's not quite a trivial change.

Helmut
