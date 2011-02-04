Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50561 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1BDO20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 09:28:26 -0500
Received: by wwa36 with SMTP id 36so2409526wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 06:28:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296828506.3671.8.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	<1296824920.3671.4.camel@jlt3.sipsolutions.net>
	<1296825156.3671.7.camel@jlt3.sipsolutions.net>
	<AANLkTim+g=qT1JHyK9--Tqw=NfE_ccFL+hiYzwz-m-V_@mail.gmail.com>
	<1296828506.3671.8.camel@jlt3.sipsolutions.net>
Date: Fri, 4 Feb 2011 19:58:13 +0530
Message-ID: <AANLkTi=oExUyV0VCmJL7QEr2fWXBmhmTXZj43muGw-O-@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 7:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-02-04 at 18:58 +0530, Vivek Natarajan wrote:
>> On Fri, Feb 4, 2011 at 6:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Fri, 2011-02-04 at 14:08 +0100, Johannes Berg wrote:
>> > Ok maybe I see how this helps -- but I don't think it's race-free. When
>> > the PS-pending flag is cleared here, the code above that checks it might
>> > already have passed and be in the driver callback or so.
>>
>> When it is in the driver callback, IEEE80211_CONF_PS would have been
>> set and when this is set, ieee80211_tx_h_dynamic_ps will disable PS
>> and there wont be any discrepancy in power save states between AP and
>> the station.
>
> Indeed, but the trace still exists between checking PS_PENDING and
> setting CONF_PS.

Agreed. :)
I will try this out and test a bit:
>
> Maybe the subif queues should be stopped, then flush, then tx nullfunc,
> then stop all queues to configure the HW or something like that?
>
> johannes
>

Thanks
Vivek.
