Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:54807 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab2DYUuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 16:50:06 -0400
Message-ID: <4F9862E9.3020007@01019freenet.de> (sfid-20120425_225046_372727_9059B130)
Date: Wed, 25 Apr 2012 22:47:37 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	Andrew Chant <andrew.chant@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: AP mode my ath9k broke between 3.3 and 3.4-rc2
References: <CANugF37WSOdHODRXOb6nnBCh5HMTTUqf0VpyPuTDdNK80-LkAQ@mail.gmail.com> <CANugF37wdS3=u7grT3H6WAJM=XxTukZoWdj70SXLL8k_6t1b6A@mail.gmail.com> <4F9679AB.6010103@01019freenet.de> <20120424125429.GB3770@tuxdriver.com> <4F983795.3070906@openwrt.org>
In-Reply-To: <4F983795.3070906@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> On 2012-04-24 2:54 PM, John W. Linville wrote:
>> On Tue, Apr 24, 2012 at 12:00:11PM +0200, Andreas Hartmann wrote:
>>> Andrew Chant wrote:
>>>> 3.4-rc4 doesn't work either.
>>>> If I revert the patch on 3.4-rc4, the Intel card is able to associate again.
>>>> -Andrew
>>>>
>>>> On Tue, Apr 24, 2012 at 12:11 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>>>>> Hello,
>>>>>  my Atheros AR9300 PCIe card (168c:0030) stopped working as an AP on
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

Well, there is another patch missing, too:

"[PATCH] rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"

This patch should be applied, too, in order to get APs with Ralink PCI
chipsets working again.


Thank you,
kind regards,
Andreas
