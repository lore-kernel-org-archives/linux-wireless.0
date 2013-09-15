Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f180.google.com ([209.85.213.180]:61185 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3IOU0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 16:26:38 -0400
Received: by mail-ye0-f180.google.com with SMTP id m15so1384221yen.11
        for <linux-wireless@vger.kernel.org>; Sun, 15 Sep 2013 13:26:37 -0700 (PDT)
Message-ID: <523617FA.1070508@lwfinger.net> (sfid-20130915_222644_703340_90B0B81D)
Date: Sun, 15 Sep 2013 15:26:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Olivier Reuland <olivier@reuland.ch>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <loom.20130915T101439-276@post.gmane.org> <5235BB3B.5030800@lwfinger.net> <5235F2D0.6090505@ilande.co.uk>
In-Reply-To: <5235F2D0.6090505@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2013 12:48 PM, Mark Cave-Ayland wrote:
> On 15/09/13 14:50, Larry Finger wrote:
>
>> There is a known problem with the dynamic power management code for this
>> chip. Unfortunately, the problem does not affect my system. At the
>> moment, my device that uses rtl8192cu has been connected for 12 hours
>> with no disconnects. The only evidence of a bug here is poor performance.
>
> Did my email to the list yesterday provide any further clues at all? I know that
> you're looking at re-working the power code, but if there is any chance of a
> stop-gap fix for 3.12 then I know it would be greatly appreciated :)

Yes, you provided some clues, but as I have no knowledge of the internal 
workings of the chips, I dare not set parameters willy-nilly as that might cause 
chips to burn out and fail.

The vendor driver provides better performance for my device than does rtl8192cu. 
I would provide the patches needed to compile it on a modern kernel; however, it 
causes a kernel panic whenever you try to unload it. I have no time nor 
inclination to debug that. Thus no one should use it unless you want to fix that 
problem.

I am trying to change the in-kernel dm code to match the vendor driver. That is 
difficult as nearly every variable is renamed.

Any patches will be pushed when they are ready, and not before. I will, however, 
provide them for testing. It remains to be seen if any such patches will be 
suitable for 3.12 and backporting to 3.11.

Larry


