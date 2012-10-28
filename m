Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2J1U75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 16:59:57 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1718763bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2012 13:59:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: dhlii@dlasys.net
Subject: Re: Bandwidth monitoring
Date: Sun, 28 Oct 2012 21:59:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <1351438667.3551.29.camel@hp-dhlii>
In-Reply-To: <1351438667.3551.29.camel@hp-dhlii>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210282159.41759.chunkeey@googlemail.com> (sfid-20121028_220001_324787_0F4B9244)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, October 28, 2012 04:37:47 PM David H. Lynch Jr. wrote:
> > From: Christian Lamparter
> >What might not work is: injecting frames with MCS rates [no code
> >in ieee80211_parse_tx_radiotap for that?]... So maybe the issue
> >is indeed at the other end?
> 
> Assuming Carl9170/AR9170's at both ends
Ah, any mac80211 device should do.

> But if I am am using iw to set monitor mode mode, channel, and
> bandwidth, And using Raw sockets injection with a radiotap header
> that has no frequency/channel/bandwidth information, 
> I should then be able to receive that packet on another system
> with an AR9170 and 1.8.2 Wireshark and the BW40 flag should be true?
Ah now I see where the problem is.
You see, the "40MHz bit" is part of the MCS rate meta info (aka flags).
(See enum mac80211_rate_control_flags in include/net/mac80211.h)

This stuff is usually set by the rate control algorithm. But because
you are injecting frames there's not alot of rate control and the frame
is usually send at the lowest possible data rate for the channel (usually
these are the 1MBit/6Mbit legacy rates and not HT20 or HT40 rates).
This is true for almost all mac80211 devices which don't feature a rate
control offload option in firmware (i.e.: ath9k_htc does have a firmware
rc and might do things differently).

OffTopic:
There is also a legacy duplicate flag IEEE80211_TX_RC_DUP_DATA that
duplicates the 20MHz legacy packet in two 20MHz halves of a 40MHz
channel. (The downside is that there's no dedicated RX_FLAG for
that and this information is not available in the radiotap)
 
> I need to do something that involves sending HT40 packets in a
> completely different context.
The receiving part should be handled by all of the mac80211 devices
I listed in the previous post out-of-the-box.

The sending part is not. AFAICT you'll have to start by declaring
and defining a new radiotap rate info element (IEEE80211_RADIOTAP_RATE
can only handle the bit rate and that is not enough). Then you have
to add a parser which translate the rate info in the radiotap header
into mac80211 ieee80211_tx_rate and tell mac80211 to bypass rate_ctrl
tx handler in this case so the info won't be overwritten again...
And finally you'll have to add a header with this new rate info element
into the radiotap header of all the frames you send through the raw
monitor interface.

A proof-of-concept should be easily doable within a day. But getting this
new radiotap to be part of the spec will take longer ;).

> But I do not have a spectrum analyzer to
> confirm that i am actually sending what I want.
I don't think you need a spectrum analyzer... unless of course 
it can also HT40 generate frames.

> So I have been using airmon, wireshark, ....
> But i need to be able to send and verify an HT40 packet by some somewhat
> normal means, to assure myself that my receiving end wireshark
> hardware/driver/software combination can tell me what i need to know. 
Well, you should be able to verify if your device picks up HT40 frames
easily. All you need is any busy 11n network with a 11n AP and a 11n
client. Just setup the receiver device (correct channel and HT40+/-
setting) and start listening.

Regards,
	Chr 
