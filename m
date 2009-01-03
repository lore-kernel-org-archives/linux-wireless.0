Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:59712 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbZACPHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 10:07:44 -0500
Received: by ewy10 with SMTP id 10so7151734ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 07:07:41 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: HW CRYPTO: rt2500usb
Date: Sat, 3 Jan 2009 16:07:38 +0100
Cc: linux-wireless@vger.kernel.org
References: <200812302055.18017.IvDoorn@gmail.com>
In-Reply-To: <200812302055.18017.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901031607.38915.IvDoorn@gmail.com> (sfid-20090103_160750_233495_23056027)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 December 2008, Ivo van Doorn wrote:
> Hi,
> 
> Currently HW crypto support has been implemented for rt2500usb,
> but has been disabled by default since it only works for TKIP.
> I am currently investigating why WEP and AES are failing, I am currently
> hitting a deadend so I hope somebody else has some suggestions.
> 
> With the current implementation which works for TKIP I noticed that WEP128
> and AES will neither transmit any data after the succesfull association. Upon
> investigation I discovered that below patch was required to make the transmitting
> of frames possible, _but_ none of the frames receive a proper reply from the AP.
> 
> The strange part is that the data length of the frame must be increased by a number
> of bytes depending on the crypto algorithm. From what I gather, the value most likely
> represents the icv_len value from the ieee80211_key structure. The weird part is that
> TKIP apparently does not require this additional length.
> 
> So far I haven't found the legacy driver adding these extra bytes to the length either,
> which sounds a bit suspicious as well.
> 
> Frames caught using wireshark from a second computer look a bit suspicious,
> a ping command from my PC will be received as broadcast frames on wireshark
> with a size of 32 bytes. (I have changed the size of the ping request, but the received
> frames don't change in size)
> 
> I'll try to do some more research later this week, but hopefully somebody has some
> suggestions on where to look for me. :)

Never mind, issue has been fixed. Well at least it is working on WEP 128
but my laptop died before I could test AES. Patch will be send to linux-wireless in
a few minutes.

Ivo
