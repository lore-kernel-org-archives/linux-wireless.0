Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45872 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0KBO64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 10:58:56 -0400
Received: by yxk8 with SMTP id 8so3749786yxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 07:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101102144625.GA32002@sig21.net>
References: <4CC0D0F6.4080507@web.de>
	<201010290017.13174.helmut.schaa@googlemail.com>
	<4CCB3F24.1030701@web.de>
	<201010301430.15868.helmut.schaa@googlemail.com>
	<20101102125007.GA30000@sig21.net>
	<20101102144625.GA32002@sig21.net>
Date: Tue, 2 Nov 2010 15:58:53 +0100
Message-ID: <AANLkTikYDHBSVuMEnUsR7WpPPo8rK0+OBm_Rd-H0znHT@mail.gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Sorry for slow response time.  I can confirm that changing
>>               rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
>>                                     intf->mac, intf->bssid);
>> to
>>               rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
>>                                     intf->mac, NULL);
>> in rt2x00mac_add_interface() fixes rt73usb AP mode for me, too.
>
> After studying the code some more, I'm confused by the
> comment for this code in rt2x00mac_add_interface():
>
>         * The BSSID address must only be configured in AP mode,
>         * however we should not send an empty BSSID address for
>         * STA interfaces at this time, since this can cause
>         * invalid behavior in the device.
>
> On the contrary I think the BSSID needs to be configured for STA mode
> since it acts as a receive filter for broadcase/multicast frames.
> The 802.11 standard says in 7.2.2 Data frames:
>
>        A STA uses the contents of the Address 1 field to perform address
>        matching for receive decisions. In cases where the Address 1 field
>        contains a group address, the BSSID also is validated to ensure that
>        the broadcast or multicast originated from a STA in the BSS of which
>        the receiving STA is a member.
>
> The ralinktech.com drivers seem to set the BSSID for STA mode and IBSS mode.

True, but the comment in rt2x00 says:
 'empty BSSID address' and 'at this time'

The legacy drivers from Ralink configure the BSSID, same as rt2x00 driver do,
when we start the association procedure. This complies with the 802.11 standard
for filtering the data frames.

Ivo
