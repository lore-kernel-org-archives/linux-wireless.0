Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab1KHQRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:17:47 -0500
Received: by bke11 with SMTP id 11so546255bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 08:17:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320767928.24797.14.camel@jlt3.sipsolutions.net>
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
 <1320766291.24797.4.camel@jlt3.sipsolutions.net> <CA+XVXfcrbfVvs+PQCjyrW_QZSKZiAzKUvrqbjqJr47dU73=n2A@mail.gmail.com>
 <1320767928.24797.14.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 8 Nov 2011 18:17:30 +0200
Message-ID: <CA+XVXfdqPtgkHzSy6Vb2_niQ-VCMVuRvUhQiG8NSEu2e8ARV6g@mail.gmail.com> (sfid-20111108_171756_310312_05377277)
Subject: Re: [PATCH v3 1/3] nl80211: Add probe response offload attribute
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 17:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-08 at 17:53 +0200, Arik Nemtsov wrote:
>> On Tue, Nov 8, 2011 at 17:31, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
>> Actually wl12xx "supports" the legacy way as well. We can operate
>> without wpa_s explicitly setting the probe-resp (even though we just
>> piece it together in other ways).
>> In this sense, it's not a mandatory feature. If wpa_s fails to
>> generate it for some reason, we don't want it to fail the AP load. The
>> AP will operate just fine.
>
> It'll operate, not sure about "just fine" :-) The way I see it that's
> mostly a backward compatibility feature, no?

I guess so. I can make the wording more explicit there so as not to confuse.

>
>> >> +++ b/include/net/cfg80211.h
>> >> @@ -1693,6 +1693,7 @@ enum wiphy_flags {
>> >>       WIPHY_FLAG_AP_UAPSD                     = BIT(14),
>> >>       WIPHY_FLAG_SUPPORTS_TDLS                = BIT(15),
>> >>       WIPHY_FLAG_TDLS_EXTERNAL_SETUP          = BIT(16),
>> >> +     WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD   = BIT(17),
>> >
>> > Ditto here, maybe WIPHY_FLAG_HAS_PROBE_RESP_OFFLOAD?

sure.

>> >
>> > As we discussed, ath6kl & similar full-mac drivers with AP SME in the
>> > device should set this to advertise the probe protocol feature set they
>> > support (by passing up), and even for wl12xx it's not optional.
>>
>> All this has to do with user-space semantics. Currently hostap always
>> sets the probe-resp IEs, without checking offloading support.
>
> Which is fine too, but I think ath6kl should set this value right?

I'll add this to the kernel side for now, with no checks in hostap.

Arik
