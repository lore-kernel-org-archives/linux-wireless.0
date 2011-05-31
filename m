Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41099 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1EaR1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 13:27:11 -0400
Received: by vxi39 with SMTP id 39so3446573vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 10:27:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinoKZ7QB-eJH+peNg4HopHssZtofg@mail.gmail.com>
References: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
 <1304529896-20934-1-git-send-email-javier@cozybit.com> <BANLkTinoKZ7QB-eJH+peNg4HopHssZtofg@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 31 May 2011 10:26:50 -0700
Message-ID: <BANLkTimruu0+g8w3EGesvR12g7Yy55tmAA@mail.gmail.com> (sfid-20110531_192721_018915_90C1BEAF)
Subject: Re: [PATCH] cfg80211: Use capability info to detect mesh beacons.
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 3:51 AM, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
> On Wed, May 4, 2011 at 10:54 PM, Javier Cardona <javier@cozybit.com> wrote:
>> Mesh beacons no longer use all-zeroes BSSID.  Beacon frames for MBSS,
>> infrastructure BSS, or IBSS are differentiated by the Capability
>> Information field in the Beacon frame.  A mesh STA sets the ESS and IBSS
>> subfields to 0 in transmitted Beacon or Probe Response management
>> frames.
>
> This breaks P2P mode as a P2P STA also sets the ESS and IBSS subfields
> to zero. Is there any other way to find if it is a mesh other than
> this check?

Bummer.  I guess that's a collision between WiFi Alliance and IEEE,
respectively the organizations standardizing P2P and 802.11s.
The 11s draft is pretty clear about that.  I can consult the task
group and see if they have thought about this conflict.

>> index fbf6f33..62e542a 100644
>> --- a/net/wireless/scan.c
>> +++ b/net/wireless/scan.c
>
>> @@ -407,7 +407,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>>
>>        res->ts = jiffies;
>>
>> -       if (is_zero_ether_addr(res->pub.bssid)) {
>> +       if (WLAN_CAPABILITY_IS_MBSS(res->pub.capability)) {
>>                /* must be mesh, verify */
>
> Reverting the above change, makes P2P work. Any other better fix?

We could check that the WLAN_CAPABILITY_IS_MBSS *and* that the bssid
matches the TA.  Do you think that would work?

Thanks,

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
