Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41937 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0G0XYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:24:35 -0400
Received: by pxi14 with SMTP id 14so667384pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 16:24:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimr-tyyNfLz7c9hKVMwWm-5qQcsUniKmv8kvC8U@mail.gmail.com>
References: <AANLkTimo4RV6UMgti0ng1rQYE2eUVh2WLv_WHQZkz30j@mail.gmail.com>
	<AANLkTimr-tyyNfLz7c9hKVMwWm-5qQcsUniKmv8kvC8U@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 27 Jul 2010 19:24:15 -0400
Message-ID: <AANLkTi=rNVifMZ_8UzmWH=f26X0pT9UM5XT7U7wE2FWd@mail.gmail.com>
Subject: Re: iwlagn: two regressions 2.6.34->2.6.35-rc6
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 3:48 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> In the attached log, you'll see the one successful connection to
>> 00:02:6f:6e:d7:6c as well as a failure.  The failure is just:
>>
>> [  668.569218] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 1)
>> [  668.769269] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 2)
>> [  668.969150] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 3)
>> [  669.169262] wlan0: authentication with 00:02:6f:6e:d7:6c timed out
>
> This time with actual attachment.

Not sure if this is the same issue, but I've got another AP here
(Ubiquiti RouterStation Pro + R52N ath9k minipci card running latest
OpenWRT "backfire") that works quite nicely on 2.6.34 but requires me
to reconnect every minute or so on 2.6.35-rc6+ to keep it working.

I'm getting tempted to just revert the whole driver back to 2.6.34 and
use the rest of 2.6.35 when it comes out.  I can also try to bisect,
either the normal way or just the iwlwifi driver, but that'll have to
wait until the Monday after next at least because I'm leaving town.
If any of you have any ideas to test *today*, I can do it.

This is a 5350, which I guess is somewhat rare given the general lack
of WiMAX coverage.

--Andy
