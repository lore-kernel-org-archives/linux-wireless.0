Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33555 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935720Ab3DJRin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 13:38:43 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg1so379438bkc.23
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 10:38:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365500525.8465.8.camel@jlt4.sipsolutions.net>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-6-git-send-email-thomas@cozybit.com> <1365500301.8465.6.camel@jlt4.sipsolutions.net>
 <1365500525.8465.8.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 10 Apr 2013 10:38:21 -0700
Message-ID: <CAG6hwVM5qmQ=mk6hR7-uioz7vEZdRNH8Z1cTgf4FT=9kBnxKKQ@mail.gmail.com> (sfid-20130410_193848_185441_E1EF7A74)
Subject: Re: [PATCH 6/6] mac80211: avoid mesh peer rate update warning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 9, 2013 at 2:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-04-09 at 11:38 +0200, Johannes Berg wrote:
>> On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
>> > Some drivers (like ath9k_htc) will take a mutex in
>> > rate_control_rate_update(), so drop the sta lock before we
>> > get there.
>>
>> That driver is broken then. rate_control_rate_update() can be called
>> from the RX path where this also isn't allowed.
>
>  * @sta_rc_update: Notifies the driver of changes to the bitrates that
> can be
>  *      used to transmit to the station. The changes are advertised with
> bits
>  *      from &enum ieee80211_rate_control_changed and the values are
> reflected
>  *      in the station data. This callback should only be used when the
> driver
>  *      uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL)
> since
>  *      otherwise the rate control algorithm is notified directly.
>  *      Must be atomic.
>
> (note last line)

Ah alright. Thanks.

-- 
Thomas
