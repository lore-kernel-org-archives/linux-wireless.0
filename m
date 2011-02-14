Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64738 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1BNKsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:48:39 -0500
Received: by wyb28 with SMTP id 28so4562464wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 02:48:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimnx9sz0gUmzd1-yj7Y-CQh4MOQWYxe4=LfeStp@mail.gmail.com>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
	<AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
	<1297678357.3785.14.camel@jlt3.sipsolutions.net>
	<AANLkTimnx9sz0gUmzd1-yj7Y-CQh4MOQWYxe4=LfeStp@mail.gmail.com>
Date: Mon, 14 Feb 2011 16:18:38 +0530
Message-ID: <AANLkTikP5kTZe06zBd5iUZq7wKZBo4ipX0cZHHmt7xDZ@mail.gmail.com>
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 3:58 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Mon, Feb 14, 2011 at 3:42 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2011-02-08 at 16:41 +0530, Mohammed Shafi wrote:
>>> On Tue, Feb 1, 2011 at 6:19 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > From: Johannes Berg <johannes.berg@intel.com>
>>> >
>>> > At least the WMM spec says we should reply to
>>> > unicast probe request frames that go to us.
>>> >
>>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>> > ---
>>> >  net/mac80211/ibss.c |    2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > --- wireless-testing.orig/net/mac80211/ibss.c   2011-02-01 12:58:16.000000000 +0100
>>> > +++ wireless-testing/net/mac80211/ibss.c        2011-02-01 13:47:44.000000000 +0100
>>> > @@ -689,7 +689,7 @@ static void ieee80211_rx_mgmt_probe_req(
>>> >               mgmt->bssid, tx_last_beacon);
>>> >  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>>> >
>>> > -       if (!tx_last_beacon)
>>> > +       if (!tx_last_beacon && !(status->rx_flags & IEEE80211_RX_RA_MATCH))
>>> >                return;
>>> >
>>> >        if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
>>>
>>> Hi Johannes,
>>>              tested with the same thing (in addition of passing the
>>> rx_status structure) and it is working fine.
>>
>> Yeah, I clearly missed that, guess I wasn't paying attention.
>>
>> The real question though is -- do we want/need this? I can only find
>> reference to this behaviour in the WMM spec.
>
> Yes, Test Engineers say this is necessary for IBSS test case-5.3.1 to pass.

Sorry for the incomplete information, few details of the test case is
5.3.1 IBSS Active Scanning Test
Purpose and Description
Active scan tests verify that the STAUT can create an IBSS, respond to
active scans, and pass data.

References
Test case 6.1 in “Wi-Fi 802.11 with WPA2, WPA, and WEP System
Interoperability Test Plan for IEEE
802.11a, b & g Devices”

For the Active Probe

STAUT responds with
Basic rate enumerated in beacon message is per default
channel is correct
record BSSID for
alter comparison to ensure
that it is a random value

> thanks,
> shafi
>
>>
>> johannes
>>
>>
>
