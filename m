Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42070 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbBXL3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 06:29:35 -0500
Received: by wghl2 with SMTP id l2so4625562wgh.9
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 03:29:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424774105.2192.29.camel@sipsolutions.net>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
 <1424772587.2192.14.camel@sipsolutions.net> <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
 <1424774105.2192.29.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 24 Feb 2015 16:59:01 +0530
Message-ID: <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com> (sfid-20150224_122942_707224_D679457C)
Subject: Re: Connection issues with BW Tracking in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 4:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-02-24 at 15:58 +0530, Krishna Chaitanya wrote:
>
>> STA (mac80211) connects to AP in VHT-80.
>> AP is reconfigured to 11n40 (stops beaconing for about 30secs and then
>> starts again).
>> STA loses connection (HW_CONN_TRACK), iee80211_connection_loss is called.
>> STA see's AP again and tries to connect,
>
> But this goes through the supplicant, right? You actually get a full
> connection loss (which I certainly would expect after 30 seconds)

Our HW N/W lost event timeout is 5secs.

>>  but due to BW tracking in
>> mac80211 it doesn't connect.
>>
>> So i guess we are not resetting the tracking after losing connection.
>
> Right, some flag is not getting reset correctly I suppose. I thought we
> had pretty robust code for this, but I guess not.
>
> Easiest might be to print the flags and other state for during all
> connection attempts, and then compare
>  * VHT connection
>  * subsequent HT connection
>  * HT connection after reloading the driver
Sure Johannes, will share the info.
