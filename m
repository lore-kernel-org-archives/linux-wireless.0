Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33086 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752062AbdIKA2u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Sep 2017 20:28:50 -0400
Subject: Re: Patch "rtlwifi: btcoexist: Fix antenna selection code" has been
 added to the 4.13-stable tree
To: Sven Joachim <svenjoac@gmx.de>, gregkh@linuxfoundation.org
Cc: birming@realtek.com, kvalo@codeaurora.org, pkshih@realtek.com,
        shaofu@realtek.com, steventing@realtek.com, yhchuang@realtek.com,
        stable@vger.kernel.org, linux-wireless@vger.kernel.org
References: <1505043448199217@kroah.com> <87bmmib812.fsf@turtle.gmx.de>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2ba2d963-2db6-b889-aa1b-ea0a3bf340d6@lwfinger.net> (sfid-20170911_022903_839525_0545A9FF)
Date: Sun, 10 Sep 2017 19:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <87bmmib812.fsf@turtle.gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2017 03:42 PM, Sven Joachim wrote:
>> queue-4.13/rtlwifi-btcoexist-fix-antenna-selection-code.patch
> 
> After applying these patches on top of 4.13.1 the WiFi on my laptop
> works again (thanks, Larry!), but now rtl8723be needs the ant_sel=2
> parameter which is a bit odd, because previously it had been working
> (only) with ant_sel=1.  This looks like it has not been intended?

The changes in the BT coexistence are rather substantial, and I had no part in 
those changes. That code is used in both Windows and Linux, and the Linux group 
is presented with the package. The best we can do is divide their massive 
changes into pieces that are small enough to be accepted by the Linux community.

One thing I can say is that when a single antenna is connected to port 2 on my 
card, ant_sel=1 works. When it is connected to post 1, then ant_sel=0 works; 
however, my card is encoded to use two antennas. As I do not know what value is 
encoded in your EFUSE, I cannot predict what value should work for you.

What I am reasonably certain is that if you were to open your computer and move 
the single antenna lead to the other port, then you would not need to use any 
ant_sel command as the new port would match the EFUSE value. According to 
reports, that would break the Windows driver, but I do not have the setup 
necessary to test that assertion.

As I have stated before, this ant_sel code was implemented to provide a service 
for Linux users that were screwed by their vendor. If I had known how much grief 
this attempt would cause me, I would have told the affected users to complain to 
that vendor. It is clearly true that no good deed goes unpunished!

Larry
