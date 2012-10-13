Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52694 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JMIzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 04:55:52 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3063070wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 01:55:50 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Krishnan Manivannan <krishnan.manivannan@sasken.com>
Subject: Re: Receive all data packets in Managed mode
Date: Sat, 13 Oct 2012 10:55:45 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DBA@EXGMBX01.sasken.com>
In-Reply-To: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DBA@EXGMBX01.sasken.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210131055.46279.chunkeey@googlemail.com> (sfid-20121013_105556_163636_ADB03536)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2012 07:51:59 Krishnan Manivannan wrote:
> The VIF is in 'Managed mode' we want to receive data packets
> of other stations destined to a DS, and get it in the MAC
> reveive path.
Just to be clear, do you want to get these frames on the same
interface? And do you want the converted 802.3 or are "real"
802.11 frames that go over the air good enough (if so, please
read on!)?

> For example, In monitor mode, the VIF receives all packets, by
> sniffing in the medium & allows all packets of other stations
> being sent to AP, and deliver it to the upper layers. We want
> to receive all packets(of other Destination address) in
> managed mode.
You can do that with carl9170 (and in fact it should work with
all other mac80211 drivers too). What you want is an additional
monitor interface:
<http://wireless.kernel.org/en/users/Documentation/iw#Adding_interfaces_with_iw>

With it, you can receive and inject 802.11 frames without
worrying too much about filters and carl9170/mac80211
internals.

# iw dev wlanX interface add moni0 type monitor flags none
# ifconfig moni0 up
And then start your favorite sniffer (wireshark, or whatever
you want to use).

> Is it possible to sniff packets in Managed mode. where in data
> packets sent by other stations are also received?
If the solution above suits your needs, then the answer is YES.
You don't need to modify the firmware. However, please be
advised, that the hardware sniffer mode is more some sort
of debug operation. And that with the current kernel code
you might experience some interference trouble if you
use carl9170 as a pure monitor. In this case you want
to apply the following patch. 
https://patchwork.kernel.org/patch/1439881/

But you don't need it, if you are going with the
station/managed interface + monitor interface stuff
(the solution above).

> Although I tried couple of things in Firmware & Carl9170, I coudn't  achieve the result.
> 1.In ::carlfw/usb/main.c,
>    void handle_usb(void)
> ++   set(AR9170_MAC_REG_SNIFFER, 1);   //added this line to enable sniffing in Managed mode
> 
> 2. In ::carlfw/src/wlanrx.c
>     void handle_wlan_rx(void)
>   -- if (!(wlan_rx_filter(desc) & fw.wlan.rx_filter))   //changed this line to
>   ++ if( 1 )
> 
> 
> In carl9170 module, source code,
>   In fine mac.c
>   int carl9170_set_operating_mode(struct ar9170 *ar)
>   -- carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer);
>   ++ carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer | AR9170_MAC_SNIFFER_ENABLE_PROMISC );
> 
> 
> In order to achieve this, what changes in firmware/ Carl9170 module needs to be done?
the AR9170 is a pretty simple 802.11 chip, it only does some
filtering (frames with bad FCS/checksums, bad length, ...).
Most of the complex filtering happens in net/mac80211/rx.c
(linux kernel).

Regards,
	Chr
