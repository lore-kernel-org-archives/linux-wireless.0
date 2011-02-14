Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52371 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1BNK2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:28:18 -0500
Received: by wwa36 with SMTP id 36so4701485wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 02:28:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297678357.3785.14.camel@jlt3.sipsolutions.net>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
	<AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
	<1297678357.3785.14.camel@jlt3.sipsolutions.net>
Date: Mon, 14 Feb 2011 15:58:16 +0530
Message-ID: <AANLkTimnx9sz0gUmzd1-yj7Y-CQh4MOQWYxe4=LfeStp@mail.gmail.com>
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 3:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-02-08 at 16:41 +0530, Mohammed Shafi wrote:
>> On Tue, Feb 1, 2011 at 6:19 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > At least the WMM spec says we should reply to
>> > unicast probe request frames that go to us.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > ---
>> >  net/mac80211/ibss.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > --- wireless-testing.orig/net/mac80211/ibss.c   2011-02-01 12:58:16.000000000 +0100
>> > +++ wireless-testing/net/mac80211/ibss.c        2011-02-01 13:47:44.000000000 +0100
>> > @@ -689,7 +689,7 @@ static void ieee80211_rx_mgmt_probe_req(
>> >               mgmt->bssid, tx_last_beacon);
>> >  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>> >
>> > -       if (!tx_last_beacon)
>> > +       if (!tx_last_beacon && !(status->rx_flags & IEEE80211_RX_RA_MATCH))
>> >                return;
>> >
>> >        if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
>>
>> Hi Johannes,
>>              tested with the same thing (in addition of passing the
>> rx_status structure) and it is working fine.
>
> Yeah, I clearly missed that, guess I wasn't paying attention.
>
> The real question though is -- do we want/need this? I can only find
> reference to this behaviour in the WMM spec.

Yes, Test Engineers say this is necessary for IBSS test case-5.3.1 to pass.
thanks,
shafi

>
> johannes
>
>
