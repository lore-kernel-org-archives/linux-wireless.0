Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61155 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2LrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 07:47:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1915952bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 04:47:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: dhlii@dlasys.net
Subject: Re: Bandwidth monitoring
Date: Mon, 29 Oct 2012 12:46:54 +0100
Cc: linux-wireless@vger.kernel.org
References: <1351471475.3551.44.camel@hp-dhlii>
In-Reply-To: <1351471475.3551.44.camel@hp-dhlii>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210291246.54328.chunkeey@googlemail.com> (sfid-20121029_124714_926769_D4ED7F31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 29, 2012 01:44:35 AM David H. Lynch Jr. wrote:
> I would be happy with any other means of forcing the transmission of an
> HT40 packet. RADIOTAP injection is just the only means I am aware of to
> do so - and from what I am gathering not an effective one.
Depends, hostapd uses it a lot. But it doesn't need to do any HT40
transmissions. I know that other people had similar issues as well,
but with ath9k. AFAICT, someone posted a patch on ath9k-devel which
made it possible to force the rate of outgoing frames, but you'll
have to google that.  
 
> > The sending part is not. AFAICT you'll have to start by declaring
> > and defining a new radiotap rate info element (IEEE80211_RADIOTAP_RATE
> > can only handle the bit rate and that is not enough). Then you have
> > to add a parser which translate the rate info in the radiotap header
> > into mac80211 ieee80211_tx_rate and tell mac80211 to bypass rate_ctrl
> > tx handler in this case so the info won't be overwritten again...
> > And finally you'll have to add a header with this new rate info element
> > into the radiotap header of all the frames you send through the raw
> > monitor interface.
> 
> > A proof-of-concept should be easily doable within a day. But getting
> > this new radiotap to be part of the spec will take longer ;)
> with my level of Radiotap/mac80211/wifi knowledge this is much more
> than a days work.
How do you know? The parser code is in ieee80211_parse_tx_radiotap and
all you would have to do is to extend it with another case and tell
mac80211 not to overwrite the rate in ieee80211_tx_h_rate_ctrl when
it was set by ieee80211_parse_tx_radiotap.
 
> Any other ideas for forcing transmission of an HT40 packet?
> What If I omit radiotap and just send an ieee80211 raw packet?
Sure, you can that. Just get a skb. Fill it with the data you
want to send and initialize the ieee80211_tx_control and
ieee80211_tx_info (in skb's cb) and call carl9170_op_tx.

If you want it to be done by the fw: Just reserve some space in 
ar9170_dma_memory and fill out the tx header carl9170_tx_superdesc
(header declarations and definitions are in include/shared/wlan.h)
and call wlan_tx_fw.

> >> So I have been using airmon, wireshark, ....
> >> But i need to be able to send and verify an HT40 packet by some
> >>somewhat
> >> normal means, to assure myself that my receiving end wireshark
> >> hardware/driver/software combination can tell me what i need to
> >know. 
> >Well, you should be able to verify if your device picks up HT40 frames
> >easily. All you need is any busy 11n network with a 11n AP and a 11n
> >client. Just setup the receiver device (correct channel and HT40+/-
> >setting) and start listening.
> still not easy - no 80211n AP's just alot of AR9170's.
> I guess I am going to be looking for a cheap 80211n AP. 

if you have two devices to spare you can setup one as AP and the other
as a client [this can be done on the same machine if you have network
namespaces].

AP:
 # hostapd hostapd.conf 

--- hostapd.conf ---
interface=wlanX
driver=nl80211
ssid=TESTN
hw_mode=g
channel=1
wmm_enabled=1
ieee80211n=1
ht_capab=[HT40+]
--- hostapd.conf ---


client:
 # iw dev wlanY connect TESTN

---
Then assign both AP and client ip addresses in the same subnet and
ping each other.

Regards,
	Chr
