Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:48324 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3AGBfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2013 20:35:51 -0500
Received: by mail-we0-f177.google.com with SMTP id x48so9407867wey.22
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2013 17:35:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357304757.11302.4.camel@jlt4.sipsolutions.net>
References: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
 <1357167319-13338-4-git-send-email-thomas@cozybit.com> <1357304757.11302.4.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sun, 6 Jan 2013 17:35:28 -0800
Message-ID: <CAG6hwVMdivdiJZE9qqtm2UXhZLFZ=tHeTyOuU_FGJR_rqr20sQ@mail.gmail.com> (sfid-20130107_023554_669372_A3744FA8)
Subject: Re: [PATCH v2 4/4] mac80211_hwsim: streamline beacon timestamp
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.org, j@w1.fi, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Jan 4, 2013 at 5:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-01-02 at 14:55 -0800, Thomas Pedersen wrote:
>
>> @@ -359,6 +359,8 @@ struct mac80211_hwsim_data {
>>       /* difference between this hw's clock and the real clock, in usecs */
>>       s64 tsf_offset;
>>       s64 bcn_delta;
>> +     /* absolute beacon transmission time. Used to cover up "tx" delay. */
>> +     u64 abs_bcn_tstamp;
>
> This can't work if you have multiple interfaces, as far as I can tell.

In practice, I think it'll be fine. abs_bcn_tstamp is only relevant
from the beacon timestamp to the rx mactime code, of which you have a
single (non-preemptible) path per hwsim hw. Per-vif beaconing (was) is
already not supported.

>> +             /*
>> +              * Account for delay from filling in the timestamp to mactime.
>> +              */
>> +             now = mac80211_hwsim_get_tsf_raw();
>> +             if (ieee80211_is_beacon(hdr->frame_control) ||
>> +                 ieee80211_is_probe_resp(hdr->frame_control))
>> +                     now -= now - data->abs_bcn_tstamp;
>
> Uhh.
>         now -= now - data->abs_bcn_tstamp;
> <=>     now = now - now + data->abs_bcn_tstamp;
> <=>     now = dat->abs_bcn_tstamp;

Oops. I guess that factors down to what I was really trying to do. No
wonder the test passed :P

> No? But it seems to me that you're trying to timestamp based on theT
> transmitter? This is weird anyway?

The global hwsim tsf is just ktime, so all interfaces have the same
reference. This might cause the beacon mactime to show as earlier than
just-received non-beacons, but it's only on the order of ~10 us, and
I'd rather have that uncertainty there than Toffset.

Will you take this patch after a little refactoring?

Thomas
