Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50961 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab1JTRxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:53:31 -0400
Received: by wwe6 with SMTP id 6so4545714wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 10:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319133075.17101.4.camel@jlt3.sipsolutions.net>
References: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
	<1319070203-22097-2-git-send-email-thomas@cozybit.com>
	<1319109210.3959.6.camel@jlt3.sipsolutions.net>
	<CAG6hwVOVHSN_-vfvVNQsGrZZtipArNs9UoPQb-gy1ZhC0owC=w@mail.gmail.com>
	<1319133075.17101.4.camel@jlt3.sipsolutions.net>
Date: Thu, 20 Oct 2011 10:53:29 -0700
Message-ID: <CAG6hwVO2J185-k+cbNsAWybcBgZhH5Yek4NmybmKBCfw5p9Nxw@mail.gmail.com> (sfid-20111020_195334_060976_40F1381A)
Subject: Re: [PATCH 2/3] mac80211: find correct IE offset in mesh beacons
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 10:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-10-20 at 10:48 -0700, Thomas Pedersen wrote:
>> On Thu, Oct 20, 2011 at 4:13 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> -     baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
>> >> +     switch (stype) {
>> >> +     case IEEE80211_STYPE_PROBE_RESP:
>> >> +             ies = (u8 *) mgmt->u.probe_resp.variable;
>> >> +             break;
>> >> +     case IEEE80211_STYPE_BEACON:
>> >> +             ies = (u8 *) mgmt->u.beacon.variable;
>> >> +             break;
>> >> +     default:
>> >> +             return;
>> >> +     }
>> >> +
>> >
>> > Does that really make sense? the offset is the same anyway and we don't
>> > get here with other frames.
>>
>> I don't think so:
>>
>>                 struct {
>>                         __le64 timestamp;
>>                         __le16 beacon_int;
>>                         __le16 capab_info;
>>                         /* followed by some of SSID, Supported rates,
>>                          * FH Params, DS Params, CF Params, IBSS Params, TIM */
>>                         u8 variable[0];
>>                 } __attribute__ ((packed)) beacon;
>>                 struct {
>>                         /* only variable items: SSID, Supported rates */
>>                         u8 variable[0];
>>                 } __attribute__ ((packed)) probe_req;
>
> Err, probe_req != probe_resp.

Wow, I need glasses. In that case, I'll drop this patch and resubmit.

Thanks!
Thomas
