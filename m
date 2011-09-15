Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f170.google.com ([209.85.161.170]:49348 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1IOJJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:09:35 -0400
Received: by gxk27 with SMTP id 27so3211161gxk.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 02:09:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316077390.3992.1.camel@jlt3.sipsolutions.net>
References: <1316076781-12580-1-git-send-email-eliad@wizery.com>
	<1316077390.3992.1.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Sep 2011 12:09:35 +0300
Message-ID: <CAB3XZEeLcXCdk7LBBNqqCeQJ84v0Fxv1JqtOUcBU8CBHjipMHw@mail.gmail.com> (sfid-20110915_110940_037417_20E5DEFD)
Subject: Re: [PATCH] cfg80211: add cfg80211_find_vendor_ie() function
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
>> +                               const u8 *ies, int len)
>> +{
>> +     struct ieee80211_vendor_ie *ie;
>> +     const u8 *pos = ies, *end = ies + len;
>> +     int ie_oui;
>> +
>> +     while (pos < end) {
>> +             pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
>> +                                    end - pos);
>> +             if (!pos)
>> +                     return NULL;
>> +
>> +             if (end - pos < sizeof(*ie))
>> +                     return NULL;
>> +
>> +             ie = (struct ieee80211_vendor_ie *)pos;
>> +             ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
>> +             if (ie_oui == oui && ie->oui_type == oui_type)
>> +                     return pos;
>> +
>> +             pos += 2 + ie->len;
>
> I think it should also check that the whole IE including ie->len (not
> just sizeof(*ie) fits into the buffer, before returning it. That is, add
> something like
>
> if (end - pos < 2 + ie->len)
>        return NULL;
>
> after the sizeof(*ie) check.
>
cfg80211_find_ie() already checks for it.

Eliad.
