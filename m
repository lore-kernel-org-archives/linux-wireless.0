Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44145 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0ASXHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 18:07:18 -0500
Received: by yxe17 with SMTP id 17so5573138yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 15:07:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC>
References: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC>
Date: Tue, 19 Jan 2010 18:07:17 -0500
Message-ID: <b6c5339f1001191507n427865a4p7ee469c7b0b69440@mail.gmail.com>
Subject: Re: wireless for manet experiments
From: Bob Copeland <me@bobcopeland.com>
To: "Frank W. Miller" <frankwmiller@frankwmiller.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 4:19 PM, Frank W. Miller
<frankwmiller@frankwmiller.net> wrote:
>
>
> Greetings,
>
> I'm interested in using my 802.11 interface to do some experimenting with
> manet protocols.  To that end I'd like to do two things:
>
> 1) disconnect the wireless interface from the IP stack and access it
> directly from user space
>
> 2) later, I'd like to interpose the Layer 2 protocol between the wireless
> interface and the IP network stack.
>
> What is the best way to go about these things?
>
> Thanks,
> FM

I have some code to make mac80211_hwsim controllable from user space.
Basically, you get a queue of packets in the driver that you can read
from a file descriptor and write to a different file descriptor to
simulate reception by a peer.  You can then make the user space part
probabilistically drop packets or whatever you like (I have code for
this too).

I'm not sure how well this meets your use case but I can post patches
if you're interested.

-- 
Bob Copeland %% www.bobcopeland.com
