Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55178 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3HMAID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 20:08:03 -0400
Received: by mail-ie0-f169.google.com with SMTP id qd12so9376079ieb.14
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 17:08:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <520975D8.8040908@lwfinger.net>
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com>
	<520968B0.80301@lwfinger.net>
	<CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com>
	<520971BA.6040503@lwfinger.net>
	<CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com>
	<520975D8.8040908@lwfinger.net>
Date: Mon, 12 Aug 2013 17:08:02 -0700
Message-ID: <CAN3-2D6KSsFXQ5QOGfp-1c69dCSrCEdcgXMfPcuEC+Hx_dX_zw@mail.gmail.com> (sfid-20130813_020808_279997_0BDB803C)
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
From: Colleen Josephson <cjoseph@mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After making the bultins into modules, the compat drivers are loaded and used.

Unfortunately, the same symptoms as my original e-mail persist, with
repeated deauthentication (reason=3).

I am using backports-3.11-rc3-1

On Mon, Aug 12, 2013 at 4:55 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/12/2013 06:44 PM, Colleen Josephson wrote:
>>>
>>> If you install the baclports drivers, they will replace the standard
>>> ones.
>>
>>
>> Even for drivers built into my kernel (not as modules?). Just making
>> sure, as I seem to have encountered a problem:
>>
>> After installing the backports version of rtl8192ce and rebooting,
>> wlan0 is not longer showing up when I run "ifconfig".
>>
>> lsmod shows compat and rtl8192c_common, but not rtl8192ce. If I try
>> 'modprobe rtl8192ce' I get this error: "Unknown symbol in module, or
>> unknown parameter  (see dmesg)"
>>
>> dmesg shows "rtlwifi: Unknown symbol mac80211_ieee80211_rx (err 0)"
>
>
> I'm not sure, but I would expect you need the standard ones to be modules. I
> always build all wireless devices as modules. That way when one goes bad,
> you have a chance to recover with an unload/load sequence with modprobe. If
> it works, you save a reboot.
>
> I am assuming that you built mac80211 from the backported source. That is
> required.
>
> Larry
>
>
>
>



-- 
Colleen Josephson
http://www.cjosephson.net
Dept. of Electrical Engineering and Computer Science
Massachusetts Institute of Technology
