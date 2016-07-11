Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:52481 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752413AbcGKHjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 03:39:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [RFC v2 1/3] nl80211: Add nl80211_notify_iface
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAGRGNgVxMZ03XCK1h45uwOdLW3g7VQ1nD23PDghJ5jfkkxqetw@mail.gmail.com>
Date: Mon, 11 Jul 2016 09:39:38 +0200
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Denis Kenzior <denkenz@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <2BC14E16-4071-443F-9679-55C3BF224380@holtmann.org> (sfid-20160711_093945_633989_FF9913A8)
References: <1468044967-9236-1-git-send-email-denkenz@gmail.com> <1468044967-9236-2-git-send-email-denkenz@gmail.com> <1601C89F-62D4-42F5-B5A4-2C9E2F02A673@holtmann.org> <ab4b33b0-cc34-80d1-49a0-51846bb7c7f2@broadcom.com> <5DF59CC1-84AA-45EF-B2EF-B16469A9D736@holtmann.org> <CAGRGNgVxMZ03XCK1h45uwOdLW3g7VQ1nD23PDghJ5jfkkxqetw@mail.gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

>>>>> This function emits NL80211_CMD_NEW_INTERFACE or
>>>>> NL80211_CMD_DEL_INTERFACE events.  This is meant to be used by the core
>>>>> to notify userspace applications such as wpa_supplicant when a netdev
>>>>> related to a wireless device has been added or removed.
>>>>> 
>>>>> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
>>>>> ---
>>>>> net/wireless/nl80211.c | 28 ++++++++++++++++++++++++++++
>>>>> net/wireless/nl80211.h |  3 +++
>>>>> 2 files changed, 31 insertions(+)
>>>>> 
>>>>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>>>>> index f39fd4d..da03e17 100644
>>>>> --- a/net/wireless/nl80211.c
>>>>> +++ b/net/wireless/nl80211.c
>>>>> @@ -11855,6 +11855,34 @@ void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
>>>>>                            NL80211_MCGRP_CONFIG, GFP_KERNEL);
>>>>> }
>>>>> 
>>>>> +void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
>>>>> +                           struct wireless_dev *wdev,
>>>>> +                           enum nl80211_commands cmd)
>>>>> +{
>>>>> +   struct sk_buff *msg;
>>>>> +   bool removal;
>>>>> +
>>>>> +   WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
>>>>> +           cmd != NL80211_CMD_DEL_INTERFACE);
>>>> 
>>>> I would assume that BUILD_BUG_ON does a way job better here.
>>> 
>>> Why? I don't see why the condition would be compile-time constant as it
>>> can be called from outside nl80211.c.
>> 
>> what has that to do with it. No matter who calls it, the point is to ensure that it is called for new/del interface. And if a caller uses it for something else, then it should fail and it should fail loudly.
> 
> Let me ask this question another way:
> 
> How is BUILD_BUG_ON going to warn about a runtime error?

how is this a runtime error in the first place? If you call it with any other nl80211_commands than the two explicitly allowed, you are doing something wrong. If BUILD_BUG_ON has limitations, then fine, but please don't tell me this is a runtime error.

Regards

Marcel

