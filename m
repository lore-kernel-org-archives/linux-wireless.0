Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHBNn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 09:43:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, mike@hellotwist.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Fix MMIC countermeasures.
References: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
        <20170802070117.GA2790@redhat.com>
        <1501676470.11126.2.camel@sipsolutions.net>
Date: Wed, 02 Aug 2017 16:43:53 +0300
In-Reply-To: <1501676470.11126.2.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 02 Aug 2017 14:21:10 +0200")
Message-ID: <87h8xqrso6.fsf@kamboji.qca.qualcomm.com> (sfid-20170802_154401_199586_DFC556A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2017-08-02 at 09:01 +0200, Stanislaw Gruszka wrote:
>
>> The relevant mac80211 code look like this:
>> 
>> ieee80211_rx_result
>> ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>
> I believe that ieee80211_rx_h_decrypt() will drop the frames you're
> looking at, and I do think the original patch is correct. If MMIC
> validation was (and could be) done, then the frame must have been
> decrypted properly.

Just to avoid any confusion, with original patch you mean this one?

rt2x00: Fix MMIC countermeasures.
https://patchwork.kernel.org/patch/9875647/

-- 
Kalle Valo
