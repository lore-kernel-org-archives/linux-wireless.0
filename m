Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:58260 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753905AbdHWM1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 08:27:21 -0400
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Julian Calaby <julian.calaby@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
 <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
 <CAGRGNgXWg6Gj4ND+BrfziX9Je5=b8Ovv=6fafYmg1CiSh6m9Mw@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <2ef60e61-1a55-21c9-744e-39bb5dadfa66@mnementh.co.uk> (sfid-20170823_142726_179493_131807EC)
Date: Wed, 23 Aug 2017 13:27:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXWg6Gj4ND+BrfziX9Je5=b8Ovv=6fafYmg1CiSh6m9Mw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/08/17 11:09, Julian Calaby wrote:
> I don't think I explained my point well.
> 
> The description of this patch implies that this method
> brcmf_sdiod_ramrw(), now relies on the window being set elsewhere
> before it's called.

I don't think it does.

> I'm asking why we can't move the setting of the window inside this
> function and remove any redundant calls to
> brcmf_sdiod_set_backplane_window() outside of it.

We do call brcmf_sdiod_set_backplane_window() in this function. We just
dont need to call it a second time to restore the original window.

It may have been required in the past because the code relied on a value
not changing (swbadr) which was a poor assumption. In practice, the
current code does not provoke this potential bug, which I remove all
possibility of happening in patch 23/30

-Ian
