Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34276 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2EINzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 09:55:06 -0400
Received: by yenm10 with SMTP id m10so274088yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 06:55:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336554064.4323.6.camel@jlt3.sipsolutions.net>
References: <1336553772-7519-1-git-send-email-helmut.schaa@googlemail.com>
	<1336554064.4323.6.camel@jlt3.sipsolutions.net>
Date: Wed, 9 May 2012 15:55:06 +0200
Message-ID: <CAGXE3d-TRGs=H_8HioSWr=J3zPWsoFRdOm5vc9MgSrbqZJMcUQ@mail.gmail.com> (sfid-20120509_155512_061522_9B69ECD4)
Subject: Re: [PATCH] mac80211: Fix race between tx path and ___ieee80211_stop_tx_ba_session
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 9, 2012 at 11:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-05-09 at 10:56 +0200, Helmut Schaa wrote:
>> ___ieee80211_stop_tx_ba_session first deletes the tx aggregation session
>> timer and afterwards clears HT_AGG_STATE_OPERATIONAL. Hence, there is a
>> small time window where the tx path can call mod_timer after
>> del_timer_sync.
>>
>> When ieee80211_start_tx_ba_session runs before the timer the call to
>> init_timer will cause a BUG_ON:
>
> This may have been fixed by my other patch where I check the state?

I'll have to try but I'm not sure if these are two different issues ...
Helmut
