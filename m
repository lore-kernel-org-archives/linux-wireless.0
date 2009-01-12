Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:64009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZALTb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:31:29 -0500
Received: by rv-out-0506.google.com with SMTP id k40so10353438rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 11:31:29 -0800 (PST)
Message-ID: <a7f8874a0901121131m75ffa5e0o246dee810eb29983@mail.gmail.com> (sfid-20090112_203146_262170_EAFDF409)
Date: Mon, 12 Jan 2009 11:31:29 -0800
From: "Hans Henry von Tresckow" <hvontres@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
In-Reply-To: <20090112191514.GA22112@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090112191514.GA22112@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 11:15 AM, Werner Almesberger
<werner@openmoko.org> wrote:
> I'd like to restart a discussion from last year, namely how aggressive
> an rfkill implementation is allowed to be when it comes to destroying
> MAC state.
>
> The design suggested in rfkill.txt and also implemented in the existing
> drivers basically assumes a simple on/off switch that cuts power to the
> transmitter but doesn't change anything else. The question is if this
> is already the full extent to which rfkill is allowed to affect MAC
> state or if it could go further.
>
> In the AR6k, we don't have such a simple switch for the transmitter. We
> can control what the transmitter does very indirectly by temporarily
> reconfiguring the MAC, but this creates a fair amount of complexity,
> which also seems to be at odds with the design of rfkill.
>
> Alternatively, we could just power down the whole WLAN module. That is
> easily done and very reliable. However, MAC state (ESSID, keys, and a
> host of other settings) is obliterated if we do this. A watchful user
> space (e.g., wpa_supplicant) could then restore the status quo ante.
>
> Now the question is whether this is still in the spirit of the design
> of rfkill of if it would take things too far.
>
> It seems that there is no consensus on this issue yet. I started the
> implementation with the assumption that rfkill should always behave as
> if it only cut transmitter power, so no other state of the MAC is
> allowed to be lost. This is also what Henrique suggested I should do.
>
> However, Andy and recently Michael suggested that, given that an
> interface that has no connectivity for an extended period of time is
> likely to get reconfigured anyway, it may be sufficient if rfkill
> leaves things in a state that allows user space to restore
> connectivity, without having to worry about details beyond that.
>
> rfkill.txt only specifies the minimum actions an RF kill is required
> to perform, but it's silent on how far it is allowed to go. Let's fix
> this :-)
>
> Thanks,
> - Werner
> --

As an interested User/lurker, it seems that allowing rfkill to power
down as much of the device as possible in the "killed" state would be
desirable. This would help extend battery life when wifi is not
needed. It seems reasonable to assume that the interface would need
reconfiguring once the rfkill switch is turned back on.

Just my $0.02 of course

-- 
Henry von Tresckow (hvontres)
Steve Martin  - "I like a woman with a head on her shoulders. I hate necks."
