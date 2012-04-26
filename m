Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2DZDe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 23:34:27 -0400
Received: by iadi9 with SMTP id i9so967977iad.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 20:34:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F983795.3070906@openwrt.org>
References: <CANugF37WSOdHODRXOb6nnBCh5HMTTUqf0VpyPuTDdNK80-LkAQ@mail.gmail.com>
 <CANugF37wdS3=u7grT3H6WAJM=XxTukZoWdj70SXLL8k_6t1b6A@mail.gmail.com>
 <4F9679AB.6010103@01019freenet.de> <20120424125429.GB3770@tuxdriver.com> <4F983795.3070906@openwrt.org>
From: Andrew Chant <andrew.chant@gmail.com>
Date: Wed, 25 Apr 2012 20:33:47 -0700
Message-ID: <CANugF37pwxu2+Fgm5E0gFi4ZaFXoQJag-_TrZGTxovP4w7=buQ@mail.gmail.com> (sfid-20120426_053431_494800_9D7B9B0A)
Subject: Re: AP mode my ath9k broke between 3.3 and 3.4-rc2
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix's patch directly applied on top of 3.4.0-rc4 works in my case.

-Andrew

On Wed, Apr 25, 2012 at 10:42 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-04-24 2:54 PM, John W. Linville wrote:
>> On Tue, Apr 24, 2012 at 12:00:11PM +0200, Andreas Hartmann wrote:
>>> Andrew Chant wrote:
>>> > 3.4-rc4 doesn't work either.
>>> > If I revert the patch on 3.4-rc4, the Intel card is able to associate again.
>>> > -Andrew
>>> >
>>> > On Tue, Apr 24, 2012 at 12:11 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>>> >> Hello,
>>> >>  my Atheros AR9300 PCIe card (168c:0030) stopped working as an AP on
>>> >> the 5GHz band between 3.3 and 3.4-rc2.
>>> >> After 14 git bisects, I believe I have narrowed it down to the following patch:
>>> >>
>>> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=293702a3fb75832613e2af097bdc3ac8ef775b33
>>> >>
>>> >> mac80211: use common radiotap code for cooked monitors
>>>
>>> Same problem here with ar9285 / 2.4GHz / eap-tls / 802.11n / hostapd
>>> 0.7.3 / compat-wireless-3.4-rc3-1.tar.bz2
>>>
>>> Removing "mac80211: use common radiotap code for cooked monitors" solves
>>> the problem here, too.
>>>
>>> Using rt2860 as AP seems not to be a problem.
>>
>> Sounds like we may need to revert it upstream.  Johannes, any comments?
> That's a known bug, which I submitted a fix for. When looking at the
> 3.4-rc4 log, I don't see my fix in there. It was submitted as
> "[PATCH] mac80211: fix truncated packets in cooked monitor rx"
>
> - Felix
