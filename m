Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49246 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1KHPyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:54:10 -0500
Received: by bke11 with SMTP id 11so521897bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 07:54:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320766291.24797.4.camel@jlt3.sipsolutions.net>
References: <1320762928-6782-1-git-send-email-arik@wizery.com> <1320766291.24797.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 8 Nov 2011 17:53:53 +0200
Message-ID: <CA+XVXfcrbfVvs+PQCjyrW_QZSKZiAzKUvrqbjqJr47dU73=n2A@mail.gmail.com> (sfid-20111108_165419_736575_B41BB3E6)
Subject: Re: [PATCH v3 1/3] nl80211: Add probe response offload attribute
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 17:31, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
>> Notify user-space about probe-response offloading support in the driver.
>>
>> A wiphy flag is used to indicate support and a bitmap of protocols
>> determines which protocols are supported.
>
>> + * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates support for probe
>> + *   response offloading by the driver/firmware.
>> + *   In addition this attribute holds a bitmap of the supported protocols
>> + *   for offloading using &enum nl80211_probe_resp_offload_support_attr.
>
> I wonder if this should make it more clear that probe requests will be
> replied to, and this is not optional?

Actually wl12xx "supports" the legacy way as well. We can operate
without wpa_s explicitly setting the probe-resp (even though we just
piece it together in other ways).
In this sense, it's not a mandatory feature. If wpa_s fails to
generate it for some reason, we don't want it to fail the AP load. The
AP will operate just fine.

>
>> +++ b/include/net/cfg80211.h
>> @@ -1693,6 +1693,7 @@ enum wiphy_flags {
>>       WIPHY_FLAG_AP_UAPSD                     = BIT(14),
>>       WIPHY_FLAG_SUPPORTS_TDLS                = BIT(15),
>>       WIPHY_FLAG_TDLS_EXTERNAL_SETUP          = BIT(16),
>> +     WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD   = BIT(17),
>
> Ditto here, maybe WIPHY_FLAG_HAS_PROBE_RESP_OFFLOAD?
>
> As we discussed, ath6kl & similar full-mac drivers with AP SME in the
> device should set this to advertise the probe protocol feature set they
> support (by passing up), and even for wl12xx it's not optional.

All this has to do with user-space semantics. Currently hostap always
sets the probe-resp IEs, without checking offloading support.

Jouni/ath6kl people - are you ok with adding some checks before
sending the extra IEs to kernel, as ath6kl is using them?

Arik
