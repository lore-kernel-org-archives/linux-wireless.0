Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f190.google.com ([209.85.216.190]:34025 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZGBPgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 11:36:07 -0400
Received: by pxi28 with SMTP id 28so1626482pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2009 08:36:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
Date: Thu, 2 Jul 2009 11:36:08 -0400
Message-ID: <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Bob Copeland <me@bobcopeland.com>
To: Jasin Colegrove <j.wholesalesupply@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 6:50 PM, Jasin
Colegrove<j.wholesalesupply@gmail.com> wrote:
> I AM NOT A SUBSCRIBER. Please reply to me directly at this e-mail
> address j.wholesalesupply@gmail.com

No need to shout -- also common etiquette on Linux kernel lists is
to "reply-all" anyway :)

> Then I decided to see if it the card was working, So I tried to iwlist
> wlan0 scan, it returned the expected results.

> I would be glad to offer up as much
> information as I can, but I don't have the slightest on how to debug
> this issue?

So to summarize:

2.6.29 works, 2.6.30 doesn't, ath9k works, ath5k doesn't, userspace
setup is unchanged.  ath5k can get scan results (which means RX is
working at least some of the time) but dhcp does not.

You said you are comfortable with the command line, in that case the
easiest way to debug the change is to just bisect the ath5k changes
using git.  There were only 50 or so patches since 2.6.29 so you will
likely only need to compile the kernel 5 or 6 times.  You can do
something like:

$ git bisect start v2.6.30 v2.6.29 -- drivers/net/wireless/ath5k

> Any help on that issue is much appreciated. Where can I
> file the appropriate bug and what information do I need to post from a
> technical standpoint.

http://bugzilla.kernel.org/ is where you would file it, the information
you've already given here is a good start.

-- 
Bob Copeland %% www.bobcopeland.com
