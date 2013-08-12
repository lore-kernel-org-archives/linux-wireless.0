Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64327 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3HLXzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:55:07 -0400
Received: by mail-oa0-f54.google.com with SMTP id o6so10683327oag.27
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:55:05 -0700 (PDT)
Message-ID: <520975D8.8040908@lwfinger.net> (sfid-20130813_015512_833751_59341DB5)
Date: Mon, 12 Aug 2013 18:55:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Colleen Josephson <cjoseph@mit.edu>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com> <520968B0.80301@lwfinger.net> <CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com> <520971BA.6040503@lwfinger.net> <CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com>
In-Reply-To: <CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2013 06:44 PM, Colleen Josephson wrote:
>> If you install the baclports drivers, they will replace the standard ones.
>
> Even for drivers built into my kernel (not as modules?). Just making
> sure, as I seem to have encountered a problem:
>
> After installing the backports version of rtl8192ce and rebooting,
> wlan0 is not longer showing up when I run "ifconfig".
>
> lsmod shows compat and rtl8192c_common, but not rtl8192ce. If I try
> 'modprobe rtl8192ce' I get this error: "Unknown symbol in module, or
> unknown parameter  (see dmesg)"
>
> dmesg shows "rtlwifi: Unknown symbol mac80211_ieee80211_rx (err 0)"

I'm not sure, but I would expect you need the standard ones to be modules. I 
always build all wireless devices as modules. That way when one goes bad, you 
have a chance to recover with an unload/load sequence with modprobe. If it 
works, you save a reboot.

I am assuming that you built mac80211 from the backported source. That is required.

Larry




