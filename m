Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64921 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE1MJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 08:09:58 -0400
Received: by mail-oa0-f52.google.com with SMTP id eb12so10804136oac.25
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 05:09:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrWdQwvMcgC=PESyECzkyMD8-vzjNEHOCkm5z=ENH7coHg@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
	<CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
	<CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
	<CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
	<CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com>
	<CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
	<CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
	<CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com>
	<CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com>
	<CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com>
	<CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com>
	<CALCETrW0NQ6aW06WD6ZAi8-o7fZSiKPOf0xYCSEw2egYBfqyQQ@mail.gmail.com>
	<CALCETrUTsKCw_G7V=YDeP-v_GF8cK8ezY-wqcpxeuw3dzBQhQg@mail.gmail.com>
	<CANUX_P2_GZGhd7X4Ntzi5Jeng52i9Jam22DQTTU2akESPL1ffQ@mail.gmail.com>
	<CALCETrWdQwvMcgC=PESyECzkyMD8-vzjNEHOCkm5z=ENH7coHg@mail.gmail.com>
Date: Wed, 28 May 2014 15:09:57 +0300
Message-ID: <CANUX_P2AKnUvUyddsGC5JST51bbjpavG3X-VbJhS1Mf7fDNPcw@mail.gmail.com> (sfid-20140528_141023_506920_E981DFD9)
Subject: Re: Help debugging iwldvm / ath10k stalls
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I doubt I can bisect -- the trigger was a new AP, not a new kernel.  I
> can't exactly cut the AP in half :)

I see.. This is really weird though. Anyway.

>
>
> Pre-suspend, i.e., working:
>
> [   20.949900] enabled = 1, wowlan = 0
> [   20.950177] enabled = 1, wowlan = 0
> [   21.614016] enabled = 1, wowlan = 0
> [   21.614658] enabled = 1, wowlan = 0
> [   42.667586] enabled = 0, wowlan = 0
> [   42.672514] enabled = 1, wowlan = 0
> [   53.088165] fuse init (API version 7.23)
> [   53.102082] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
> [   53.130945] SELinux: initialized (dev fusectl, type fusectl), uses
> genfs_contexts
> [   85.627558] enabled = 0, wowlan = 0
> [   85.631686] enabled = 1, wowlan = 0
> [  134.649346] e1000e: em1 NIC Link is Down
> [  137.682277] wlan0: deauthenticating from 02:c6:26:cc:b4:c7 by local
> choice (Reason: 3=DEAUTH_LEAVING)
> [  137.682780] enabled = 0, wowlan = 0
> [  137.693889] enabled = 0, wowlan = 0
>
> Post-suspend, i.e., not working:
>
> [  144.406303] enabled = 1, wowlan = 0
> [  144.406496] enabled = 1, wowlan = 0
> [  145.026827] enabled = 1, wowlan = 0
> [  145.028211] enabled = 1, wowlan = 0
> [  165.688632] enabled = 0, wowlan = 0
> [  165.689960] enabled = 0, wowlan = 0
> [  165.693988] enabled = 1, wowlan = 0
> [  165.694245] enabled = 1, wowlan = 0
> [  208.641426] enabled = 0, wowlan = 0
> [  208.641786] enabled = 0, wowlan = 0
> [  208.647499] enabled = 1, wowlan = 0
> [  208.647639] enabled = 1, wowlan = 0
> [  271.435558] enabled = 0, wowlan = 0
> [  271.435767] enabled = 0, wowlan = 0
> [  271.440125] enabled = 1, wowlan = 0
> [  271.440405] enabled = 1, wowlan = 0
>
> With even more instrumentation added, I did get a glitch before
> suspend/resume, but it came with more than two power setting updates.
> Logs and patch attached, complete with call stacks.
>

I don't see any callstacks?
Doesn't matter though.

> Is it possible that part of the problem is that the firmware doesn't
> like being spammed with power config changes so frequently?
>
Don't think so.
But the suspend / resume thing is not the kind of things that are fun to debug.
I am afraid that I will disable power save completely since I don't
really have the time to dig into that.
