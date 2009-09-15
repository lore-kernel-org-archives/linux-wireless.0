Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41416 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZIOIyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 04:54:03 -0400
Received: by ewy2 with SMTP id 2so246941ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 01:54:06 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: [RFC] ar9170usb: add ar9170 usbid
Date: Tue, 15 Sep 2009 10:54:00 +0200
Cc: Fabian Lenz <lenz_fabian@yahoo.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
References: <200909142046.07525.lenz_fabian@yahoo.de> <200909142308.19569.chunkeey@googlemail.com> <618D4DE9D5223A45A46C48063FD64045109947ACC0@TAEXMB-01.global.atheros.com>
In-Reply-To: <618D4DE9D5223A45A46C48063FD64045109947ACC0@TAEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909151054.00872.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 September 2009 01:39:40 Stephen Chen wrote:
> Hi Christian,
> 
> I could not find this VID/PID in INF file in Windows release.
> This ID combination could be obsolete.

you can get their vendor driver from here:
http://www.tp-link.com/support/download.asp?a=1&m=TL-WN821N

-> Driver Files/XP/arusb_xp.inf
--- snip --- Driver Files/${OS}/arusb_${OS}.inf
%ATHR.DeviceDesc.9170%       = ATHRXP9170.ndi,    USB\VID_0CF3&PID_1002
ATHR.DeviceDesc.9170     = "TP-LINK TL-WN821N 11N Wireless Adapter"
--- snip ---

Looks like they are trying to hijack Atheros' usbid space
by assigning custom product IDs.

This can confuse the unsuspected user and maybe break some stuff.
I'm not joking, this is an accident waiting to happen! 
(see "rt2500usb vs. rt73usb" => http://patchwork.kernel.org/patch/45342/
 for how this can go wrong.)

For now, you/[Atheros] should add the PID to your win driver as well
(so it's marked as _used_) and get in touch with TP-Link to come up
with a way for vendors - w/o their own VID - to get custom PIDs.

Regards,
    Chr
