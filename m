Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0BSSyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:54:44 -0500
Received: by pwj8 with SMTP id 8so389059pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 10:54:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002182240.38016.8an@praha12.net>
References: <1266459208-12408-1-git-send-email-lrodriguez@atheros.com>
	<201002182240.38016.8an@praha12.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 19 Feb 2010 10:54:24 -0800
Message-ID: <43e72e891002191054jb537041g45c407cae860adf8@mail.gmail.com>
Subject: Re: [PATCH] iw: add country IE parsing
To: 8an@praha12.net
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 1:40 PM, Lukáš Turek <8an@praha12.net> wrote:
> On 18.2.2010 03:13 Luis R. Rodriguez wrote:
>> coverage = (distance + 449) / 450;
>> coverage/450 = distance + 499
>> (coverage/450) - 499 = distance
>
> Inverting the formula like this doesn't make much sense...
>
> The addition of 449 is there to round the resulting number up, because the
> coverage class limits maximum distance and if it was rounded down as normal
> integer division does, the resulting ACK timeout would be too low.
>
> However, if you subtract 449 in the inverted formula, you get something like a
> minimum distance for the coverage class - which doesn't mean anything,
> because higher ACK timeout and slot time works for smaller distances too.
> Maximum distance is what's interesting to the user. So the correct
> calculation is just multiplying the coverage class by 450 as I'm doing in
> print_phy_handler():
>
> printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);

Thanks I'll fix and resend.

  Luis
