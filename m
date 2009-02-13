Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:24009 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZBMHID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:08:03 -0500
Received: by yw-out-2324.google.com with SMTP id 5so581354ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:08:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234507985.1327.15.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234507985.1327.15.camel@johannes.local>
Date: Thu, 12 Feb 2009 23:08:02 -0800
Message-ID: <43e72e890902122308x375cc22fu1c27f8fe9aaac524@mail.gmail.com> (sfid-20090213_080810_512426_8AEF3AD3)
Subject: Re: [PATCH 2/6] cfg80211: add wiphy_idx_valid to check for wiphy_idx
	sanity
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 21:35 -0800, Luis R. Rodriguez wrote:
>
>> -     if (unlikely(drv->wiphy_idx < 0)) {
>> +     if (!wiphy_idx_valid(drv->wiphy_idx)) {
>
>> +/* Note 0 is valid, hence phy0 */
>> +static inline
>> +bool wiphy_idx_valid(int wiphy_idx)
>> +{
>> +     return (likely(wiphy_idx >= 0));
>> +}
>
> Does that really work properly with the likely in there?

Oh you mean !likely() won't give me my unlikely() effect? I think so
as the path is meant to not be optimized so the optimized path would
be put first, no?

  Luis
