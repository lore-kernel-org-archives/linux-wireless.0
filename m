Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48973 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaHKWZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 18:25:59 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so4994085wiw.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 15:25:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407770081.9844.12.camel@jlt4.sipsolutions.net>
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1407770081.9844.12.camel@jlt4.sipsolutions.net>
Date: Tue, 12 Aug 2014 00:25:58 +0200
Message-ID: <CAA2SeNLg3mktDY0u4=ksHr4QvXewx4koeGkCAW8upqrS6gMg0g@mail.gmail.com> (sfid-20140812_002603_494893_7C984666)
Subject: Re: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index f1db15b..0b2d55d 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -1594,6 +1594,9 @@ enum nl80211_commands {
>>   * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
>>   *   the TDLS link initiator.
>>   *
>> + * @NL80211_ATTR_WIPHY_DYN_ACK: whether dynamic ack timeout estimation
>> + *   algorithm is enabled
>
> You should probably describe that it's related to the
> NL80211_FEATURE_ACKTO_ESTIMATION feature (and you should document that
> it's a flag) since otherwise nobody will be able to correlate the two
> things easily. :)
>
>
>> +       if (info->attrs[NL80211_ATTR_WIPHY_DYN_ACK]) {
>> +               if (!(rdev->wiphy.features &
>> NL80211_FEATURE_ACKTO_ESTIMATION))
>> +                       return -EOPNOTSUPP;
>> +
>> +               changed |= WIPHY_PARAM_DYN_ACK;
>> +       }
>
> that doesn't really seem right, how do you turn it off??
>

dynack is disable by default at bootstrap and it is automatically
disabled as soon as you set coverage_class (coverage_class >= 0) after
dynack has been enabled (coverage_class = -1). E.g:

- iw phy phy0 set distance auto (to enable dynack)

- iw phy phy0 set distance x (to set coverage class and disable dynack)


This logic is implemented in dynack code. Is it fine for you?
Anyway documentation should be clearer on that stuff. :)

> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
