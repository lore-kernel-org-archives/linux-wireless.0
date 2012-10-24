Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44810 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348Ab2JXGfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 02:35:44 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so48520bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 23:35:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <ml@dlasys.net>
Subject: Re: Bandwidth monitoring
Date: Wed, 24 Oct 2012 08:35:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <1351018719.3663.30.camel@hp-dhlii>
In-Reply-To: <1351018719.3663.30.camel@hp-dhlii>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210240835.29411.chunkeey@googlemail.com> (sfid-20121024_083548_767987_E773CAD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 23, 2012 08:58:39 PM David H. Lynch Jr. wrote:
>> On Sunday, October 21, 2012 09:58:18 PM David H. Lynch Jr. wrote:
>>> I am looking for an easy means to determine the characteristics of a
>>> transmitted packet. 
>>> Particularly whether it is HT20/HT40-/HT40+ I have used a variety of
>>> sniffers, airodump, wireshark, ... and I can not seem to find anything
>>> that will tell me what I am after - or I do not know how to use them.
>>differentiating between HT40+ and HT40- will be difficult to do with
>>just one standard wifi device (should be possible with two though).
>>
>>If you use mac80211, have you setup your monitor channel by adding
>>the HT20/HT40+/HT40- flag? 
>># iw dev wlanX set channel 1 HT40+ (or HT40-/HT20)
> 
> This is setting up to send on channel 1 HT40+ correct ?
yes, I hope so.

> >As for retrieving the information:
> >If a HT20/HT40  frame was received, it should have a radiotap
> >IEEE80211_RADIOTAP_MCS header element (on the monitor interface dump).
> >In this element should provide the MCS and flags for 
> > - BW40 (if false => HT20, if true => HT40+ or HT40- depending
> >   on the channel configuration)
> > - Short GI
> > - Greenfield flag
> > - (LDPC)
> 
> Wireshark appears to handle RadioTap - I am seeing lots of other flags
> etc. but not BW40.
It depends on the version. Here's a screenshot
from wireshark 1.8.2: <http://imageshack.us/f/703/mcsinfo.png/>

>> But I don't know if any of this information is parsed by any of the
>> current tools (depends on the version I guess). At least for wireshark
>> you can always look at the raw hex dump of the package, so it should
>> be there! The definitions of what RADIOTAP_MCS bit means what are in:
>> <include/net/ieee80211_radiotap.h>
> 
> Googling Radiotap produces lots of comments that suggest that Radiotap
> headers - send and receive are not necescarily complete or accurate from
> device to device - is that a reasonable conclusion ?
Most mac80211 driver should report rx'ed MCS information.
At least ath9k, ath9k_htc, brcmsmac, carl9170, iwlagn, iwllegacy, mwl8k,
rt2800*, rtl8192* do.

What might not work is: injecting frames with MCS rates [no code
in ieee80211_parse_tx_radiotap for that?]... So maybe the issue
is indeed at the other end?

Regards,
	Chr
