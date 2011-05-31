Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64754 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab1EaSii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 14:38:38 -0400
Received: by vxi39 with SMTP id 39so3504660vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 11:38:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimphsVZsuji3T4yJt5hHdWtU65Z0g@mail.gmail.com>
References: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
 <1304529896-20934-1-git-send-email-javier@cozybit.com> <BANLkTinoKZ7QB-eJH+peNg4HopHssZtofg@mail.gmail.com>
 <BANLkTimruu0+g8w3EGesvR12g7Yy55tmAA@mail.gmail.com> <BANLkTimphsVZsuji3T4yJt5hHdWtU65Z0g@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 31 May 2011 11:38:17 -0700
Message-ID: <BANLkTi=9a-UCo=hgAr-sPvPiTM_jUKefjQ@mail.gmail.com> (sfid-20110531_203847_375957_A0ED5831)
Subject: Re: [PATCH] cfg80211: Use capability info to detect mesh beacons.
To: Eliad Peller <eliad@wizery.com>
Cc: Vivek Natarajan <vivek.natraj@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 11:10 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, May 31, 2011 at 8:26 PM, Javier Cardona <javier@cozybit.com> wrote:
>> On Mon, May 30, 2011 at 3:51 AM, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>>> On Wed, May 4, 2011 at 10:54 PM, Javier Cardona <javier@cozybit.com> wrote:
>>>> Mesh beacons no longer use all-zeroes BSSID.  Beacon frames for MBSS,
>>>> infrastructure BSS, or IBSS are differentiated by the Capability
>>>> Information field in the Beacon frame.  A mesh STA sets the ESS and IBSS
>>>> subfields to 0 in transmitted Beacon or Probe Response management
>>>> frames.
>>>
>>> This breaks P2P mode as a P2P STA also sets the ESS and IBSS subfields
>>> to zero. Is there any other way to find if it is a mesh other than
>>> this check?
>>
>> Bummer.  I guess that's a collision between WiFi Alliance and IEEE,
>> respectively the organizations standardizing P2P and 802.11s.
>> The 11s draft is pretty clear about that.  I can consult the task
>> group and see if they have thought about this conflict.
>>
>>>> index fbf6f33..62e542a 100644
>>>> --- a/net/wireless/scan.c
>>>> +++ b/net/wireless/scan.c
>>>
>>>> @@ -407,7 +407,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>>>>
>>>>        res->ts = jiffies;
>>>>
>>>> -       if (is_zero_ether_addr(res->pub.bssid)) {
>>>> +       if (WLAN_CAPABILITY_IS_MBSS(res->pub.capability)) {
>>>>                /* must be mesh, verify */
>>>
>>> Reverting the above change, makes P2P work. Any other better fix?
>>
>> We could check that the WLAN_CAPABILITY_IS_MBSS *and* that the bssid
>> matches the TA.  Do you think that would work?
>>
> i guess you are referring to SA (rather than TA).
> in that case, this solution is not enough, as SA==bssid also holds
> true for the p2p probe responses (at least when a single vif is being
> used).

Yes, you are right, SA or Address 2  (11s changes the address field
definitions from DA, SA, BSSID to Address 1, 2 and 3).  In mesh
management frames, Address 2 always equals Address 3.  Is this also
the case for some P2P management frames?

> btw, i've already submitted some workaround for this issue:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/70763
>
> in case we won't find a better solution...

OK.  If the answer to my question above is yes, then I guess we'll
have to do it as you suggest.  Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
