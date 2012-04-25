Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:22904 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932464Ab2DYXq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 19:46:27 -0400
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Andrew Chant <andrew.chant@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>
Subject: Re: AP mode my ath9k broke between 3.3 and 3.4-rc2
Date: Wed, 25 Apr 2012 23:46:26 +0000
Message-ID: <80FFDD6E-923A-4348-AEC0-2C85C60A0D22@watchguard.com> (sfid-20120426_014631_912353_52FF859D)
References: <CANugF37WSOdHODRXOb6nnBCh5HMTTUqf0VpyPuTDdNK80-LkAQ@mail.gmail.com>
 <CANugF37wdS3=u7grT3H6WAJM=XxTukZoWdj70SXLL8k_6t1b6A@mail.gmail.com>
 <4F9679AB.6010103@01019freenet.de> <20120424125429.GB3770@tuxdriver.com>
 <4F983795.3070906@openwrt.org>
In-Reply-To: <4F983795.3070906@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Apr 25, 2012, at 10:42 AM, Felix Fietkau wrote:

> On 2012-04-24 2:54 PM, John W. Linville wrote:
>> On Tue, Apr 24, 2012 at 12:00:11PM +0200, Andreas Hartmann wrote:
>>> Andrew Chant wrote:
>>>> 3.4-rc4 doesn't work either.
>>>> If I revert the patch on 3.4-rc4, the Intel card is able to associate again.
>>>> -Andrew
>>>> 
>>>> On Tue, Apr 24, 2012 at 12:11 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>>>>> Hello,
>>>>> my Atheros AR9300 PCIe card (168c:0030) stopped working as an AP on
>>>>> the 5GHz band between 3.3 and 3.4-rc2.
>>>>> After 14 git bisects, I believe I have narrowed it down to the following patch:
>>>>> 
>>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=293702a3fb75832613e2af097bdc3ac8ef775b33
>>>>> 
>>>>> mac80211: use common radiotap code for cooked monitors
>>> 
>>> Same problem here with ar9285 / 2.4GHz / eap-tls / 802.11n / hostapd
>>> 0.7.3 / compat-wireless-3.4-rc3-1.tar.bz2
>>> 
>>> Removing "mac80211: use common radiotap code for cooked monitors" solves
>>> the problem here, too.
>>> 
>>> Using rt2860 as AP seems not to be a problem.
>> 
>> Sounds like we may need to revert it upstream.  Johannes, any comments?
> That's a known bug, which I submitted a fix for. When looking at the
> 3.4-rc4 log, I don't see my fix in there. It was submitted as
> "[PATCH] mac80211: fix truncated packets in cooked monitor rx"


Just as another data-point, I'm using ath9k for an AR9300 Rev:3 chipset
with compat-wireless-v3.4-rc3-1, and it doesn't work as an AP in any case:

Stock code:
  fails
Reverting [PATCH] mac80211: use common radiotap code for cooked monitors:
  fails
Leaving the above in place and applying Felix's radiotap patch:
  fails

I get a lot of these logs from hostapd:

1335397090.413064: Could not parse ProbeReq from 00:24:44:f5:e3:c2

I'm using hostapd 0.7.3.  If I rewind to an earlier "stable", it works -
at least the AP works; there is a bug in client mode when connecting to
a WEP AP, which is fixed in v3.4-rc3-1.

Should I try switching from "stable" to "next"?

--
-bp


