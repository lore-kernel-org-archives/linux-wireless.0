Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43207 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab2DZSZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:25:19 -0400
Received: by bkuw12 with SMTP id w12so1253049bku.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 11:25:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170 - monitor mode TP drop
Date: Thu, 26 Apr 2012 20:25:12 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> <201204252054.54123.chunkeey@googlemail.com> <CAFED-jkq58fjv2B+kOr5KJD4p7MUa35Pq6uP=yfCEfMa9Ujp=w@mail.gmail.com>
In-Reply-To: <CAFED-jkq58fjv2B+kOr5KJD4p7MUa35Pq6uP=yfCEfMa9Ujp=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201204262025.12410.chunkeey@googlemail.com> (sfid-20120426_202523_424394_4A6A7CEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, April 26, 2012 09:45:22 AM Janusz Dziedzic wrote:
> W dniu 25 kwietnia 2012 20:54 u¿ytkownik Christian Lamparter
> So, what steps you suggest?
> I would like to record traffic from channel 6 and would like to not
> have this SNIFFER ACK.
> 
> This is what I tried:
> - ifconfig wlan0 up (no matter if up or down)
> - iw phy phy0 interface add moni0 type monitor
> - iw phy phy0 set channel 6
> - ifconfig moni0 up
> 
> After last step I still see TP drop between AP and STA1 on channel6
Uh that's right. it was:

iw phy0 interface add moni type monitor flags none

the "flags none" is the important bit.

Regards,
	Christian
