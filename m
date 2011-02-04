Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35996 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1BDHjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 02:39:21 -0500
Received: by iwn9 with SMTP id 9so1889979iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 23:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=sBohy=tiYJ00k5mMS2mUBRmztB9hRht1d-9js@mail.gmail.com>
References: <10052860.45456.1296639849605.JavaMail.www@wwinf1e10> <AANLkTi=sBohy=tiYJ00k5mMS2mUBRmztB9hRht1d-9js@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Feb 2011 23:39:00 -0800
Message-ID: <AANLkTi=3L0TubSXvP2dDaKwUv9giQ21Z6pN=VvdpUPJC@mail.gmail.com>
Subject: Re: HOW TO enable UAPSD and WMM on ath9k
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 2, 2011 at 2:56 AM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Wed, Feb 2, 2011 at 3:14 PM, Prigent Xavier MAPS LIS LANNION
> <labolis2@orange.fr> wrote:
>>
>> Hello ALL,
>>
>> I have an AR9280 on debian version 2.6.32. I tried to enable UAPSD and WMM on all queue but I can not. I install compat-
>> wirelless and load ath9k.
>> I saw with iw you can 't enable wmm or UAPSD. I remenbered with iwpriv you could do this but it does not work with this
>> driver.
>> I saw on" http://wireless.kernel.org/en/developers/Documentation/kerneldoc/include/net/mac80211.h" you could change WMM
>> and UAPSD value.So I decide to make change in source and header code
>> but it seems to be difficult and I does not understand all.
>> * @IEEE80211_HW_SUPPORTS_UAPSD:
>> * Hardware supports Unscheduled Automatic Power Save Delivery
>> * (U-APSD) in managed mode. The mode is configured with
>> * conf_tx() operation.
>
> UAPSD is not supported in ath9k.I am saying this based on looking at
> init.c of ath9k

You first need to add support for uAPSD to mac80211 for drivers which
need this completely in software, and then add it to ath9k.

  Luis
