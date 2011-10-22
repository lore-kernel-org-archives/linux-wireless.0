Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57758 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1JVR06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 13:26:58 -0400
Received: by wwe6 with SMTP id 6so7101623wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 10:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319290618.3956.6.camel@jlt3.sipsolutions.net>
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
	<1319290457.3956.3.camel@jlt3.sipsolutions.net>
	<1319290618.3956.6.camel@jlt3.sipsolutions.net>
Date: Sat, 22 Oct 2011 19:26:56 +0200
Message-ID: <CAA038468Y7T4BSAycqmNc0q+Ph1wSh07B57tV--O00kvDEp-wg@mail.gmail.com> (sfid-20111022_192701_834395_27820085)
Subject: Re: [PATCH 1/4] nl80211: Add probe response offload attribute
From: Guy Eilam <guy@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 22, 2011 at 3:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2011-10-22 at 15:34 +0200, Johannes Berg wrote:
>> On Sat, 2011-10-22 at 15:11 +0200, Guy Eilam wrote:
>>
>> > +enum nl80211_probe_resp_offload_support_attr {
>> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS,
>> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2,
>> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P,
>> > +};
>>
>> I think doing = 1<<N here would be nicer to use in drivers & userspace.
>
> Hm, also: should we call this WPS or WSC, and do we need to distinguish
> WPS and WPS2? My AP mode patch called it WSC in a different context but
> I can change, we just should be consistent.
>
>> > + * @get_probe_resp_offload: Get probe response offload support from driver.
>>
>> and this seems unnecessary -- why not just put a u32 value into struct
>> wiphy?
>
> Oh, and probably a regular WIPHY flag that indicates whether the
> attribute should be added at all so that it can also be 0 but present
> (presence with 0 value indicates something other than not present).

When this is not supported a -EOPNOTSUPP should be returned.
A 0 return means that it is supported.
I now see that I have a small mistake in the patch regarding this.
The check should be (res >= 0) and not (!res).
I'll fix it.

>
> johannes
>
>
