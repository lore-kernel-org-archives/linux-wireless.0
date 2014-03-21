Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45630 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaCUO6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:58:45 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so2646540oac.16
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 07:58:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395411440.4164.15.camel@jlt4.sipsolutions.net>
References: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
	<1395411440.4164.15.camel@jlt4.sipsolutions.net>
Date: Fri, 21 Mar 2014 15:58:44 +0100
Message-ID: <CA+BoTQk5RiFPjDGMSwFHd6GGt=x9M6QXGZcdENtMjQrDcORicg@mail.gmail.com> (sfid-20140321_155849_300912_43F8C9F9)
Subject: Re: [PATCH] ath10k: dont call csa_finish more than once
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 March 2014 15:17, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-21 at 15:02 +0100, Michal Kazior wrote:
>> Driver is supposed to call it only once for each
>> scheduled channel_switch_beacon().
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>> This is required for multi-vif csa but since that
>> isn't merged yet I'm not including any specifics
>> in the commit log itself.
>>
>> Preventing multiple ieee80211_csa_finish() calls
>> sounds like a good idea in general to me.
>
> Didn't we have this discussion on the hwsim patch before?

Oh. I'm not aware of the discussion. Probably missed it.


> I'd argue that if all drivers must track this, then the mac80211 API is
> defective.

I can make this a mac80211 patch then?


Michał
