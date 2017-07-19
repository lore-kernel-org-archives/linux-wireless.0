Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49034 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752840AbdGSJdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 05:33:49 -0400
Subject: Re: brcmfmac bus level addressing issues.
To: Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
 <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk>
 <6fe08666ca09bf3c1d4476fdad8ce97a@mail.gmail.com>
 <222e2bc1-4d8f-8133-4fa7-51a48f3de785@mnementh.co.uk>
 <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk>
 <701af0be-87b6-a397-ae29-a5ba75605588@broadcom.com>
 <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
 <1ca886ff99c569faad930b6b4d6c0d3f@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <6b40c7b1-d786-baef-8c82-84412507c956@mnementh.co.uk> (sfid-20170719_113354_582443_569E6D48)
Date: Wed, 19 Jul 2017 10:33:47 +0100
MIME-Version: 1.0
In-Reply-To: <1ca886ff99c569faad930b6b4d6c0d3f@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/07/17 09:39, Hante Meuleman wrote:
> Dear Ian,

Hi,

> Stuff like " The PCIe code sets the window *regardless* of wether its
> changed, on *every single* write." Is totally incorrect. Sure if you limit
> yourself to the function brcmf_pcie_buscore_{read,write}32(). But you
> talked about performance, and msgbuf prototocol is where performance
> counts and that don't use those functions. You wrote: " The PCIe code uses
> brcmf_pcie_select_core(), which, ultimately, appears to be totally
> redundant" and that is simply not true.

This actually kinda underlines my point - at the time I was, as you say,
referring to the _{read,write}32() functions (which is where I'd been
cleaning up in the sdio code too.

> So I decided to answer that mail
> and provoke you a bit. I'm sorry for that, I shouldn't have done that.

Fair enough. I lost my cool in my reply to that too, so lets just start
again. Fair?

> You obviously spent some time on creating all these patches, but why
> provoke/agitate people? Why use such strong words? You may not consider
> them personally, but I just explained why I do. Can you at least
> understand that?

Sorry it came over as personal. Its not. And yes, it sometimes hurts
when people are critical about code you've written - and I've been on
the receiving end of it before now - and they were correct, and I was
wrong at the time. It has to be said though - that code is not pretty
(sdio side in particular - as mentioned before, the PCIe side is a fair
bit better).

> Just some word of advice and then I hope we can leave it to that.
Yes, lets.

-Ian
