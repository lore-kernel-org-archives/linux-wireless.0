Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52803 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3LDTew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 14:34:52 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so4428557wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 11:34:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOHe==HZrDHCA+L5-2+y-p68mRzpD1Vwye+1N48zhxoQEhU57A@mail.gmail.com>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
 <1386092034-13442-3-git-send-email-mcgrof@do-not-panic.com> <CAOHe==HZrDHCA+L5-2+y-p68mRzpD1Vwye+1N48zhxoQEhU57A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 4 Dec 2013 20:34:31 +0100
Message-ID: <CAB=NE6VJZyZJ-szz1Nid00q3d4VArhHGXor0KQdFTTGkWf8t9g@mail.gmail.com> (sfid-20131204_203455_925665_7D93052F)
Subject: Re: [RFT 2/2] cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG
To: Mihir Shete <mihirsht@gmail.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 4, 2013 at 8:15 PM, Mihir Shete <mihirsht@gmail.com> wrote:
>> @@ -1826,6 +1826,8 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
>>         if (WARN_ON(!alpha2 || !wiphy))
>>                 return -EINVAL;
>>
>> +       wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
>> +
> Clear REGULATORY_CUSTOM_REG

Thanks, yes, did you test it?

  Luis
