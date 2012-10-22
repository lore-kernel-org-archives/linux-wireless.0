Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61121 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2JVKnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 06:43:17 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so946921bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 03:43:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <ml@dlasys.net>
Subject: Re: Bandwidth monitoring
Date: Mon, 22 Oct 2012 12:43:01 +0200
Cc: linux-wireless@vger.kernel.org
References: <1350849498.4859.27.camel@hp-dhlii>
In-Reply-To: <1350849498.4859.27.camel@hp-dhlii>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210221243.02059.chunkeey@googlemail.com> (sfid-20121022_124321_106011_59D61FC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, October 21, 2012 09:58:18 PM David H. Lynch Jr. wrote:
> I am looking for an easy means to determine the characteristics of a
> transmitted packet. 
> Particularly whether it is HT20/HT40-/HT40+ I have used a variety of
> sniffers, airodump, wireshark, ... and I can not seem to find anything
> that will tell me what I am after - or I do not know how to use them.
differentiating between HT40+ and HT40- will be difficult to do with
just one standard wifi device (should be possible with two though).

If you use mac80211, have you setup your monitor channel by adding
the HT20/HT40+/HT40- flag? 
# iw dev wlanX set channel 1 HT40+ (or HT40-/HT20)

This might help.

As for retrieving the information:
If a HT20/HT40  frame was received, it should have a radiotap
IEEE80211_RADIOTAP_MCS header element (on the monitor interface dump).
In this element should provide the MCS and flags for 
 - BW40 (if false => HT20, if true => HT40+ or HT40- depending
   on the channel configuration)
 - Short GI
 - Greenfield flag
 - (LDPC)

But I don't know if any of this information is parsed by any of the
current tools (depends on the version I guess). At least for wireshark
you can always look at the raw hex dump of the package, so it should
be there! The definitions of what RADIOTAP_MCS bit means what are in:
<include/net/ieee80211_radiotap.h>

Regards,
	Chr
