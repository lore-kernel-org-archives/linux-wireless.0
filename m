Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35605 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcJLEeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 00:34:24 -0400
MIME-Version: 1.0
In-Reply-To: <1476180668.17022.21.camel@tiscali.nl>
References: <20161010071943.4717-1-chris@rorvick.com> <1476108164.5210.11.camel@coelho.fi>
 <1476180668.17022.21.camel@tiscali.nl>
From: Chris Rorvick <chris@rorvick.com>
Date: Tue, 11 Oct 2016 23:32:47 -0500
Message-ID: <CAEUsAPbEf=hr1ki267qKpenWW_UBO93KY8q6-EdqWpk15Yhcnw@mail.gmail.com> (sfid-20161012_063501_910309_BD5721AA)
Subject: Re: [PATCH] iwlwifi: pcie: reduce "unsupported splx" to a warning
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Luca Coelho <luca@coelho.fi>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oren Givon <oren.givon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2016 at 5:11 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> For what it's worth, on my machine I have twenty (!) SPLX entries, all
> reading:
>     Name (SPLX, Package (0x04)
>     {
>         Zero,
>         Package (0x03)
>         {
>             0x80000000,
>             0x80000000,
>             0x80000000
>         },
>
>         Package (0x03)
>         {
>            0x80000000,
>            0x80000000,
>            0x80000000
>         },
>
>         Package (0x03)
>         {
>             0x80000000,
>             0x80000000,
>             0x80000000
>         }
>     })

I actually see exactly the same on my Dell XPS 13 (9350) when I  use
acpidump, etc.  I typed the entry I included in the commit log by hand
based on what the driver gets back from the SPLC method (I added a
function to dump the returned object.)

Chris
