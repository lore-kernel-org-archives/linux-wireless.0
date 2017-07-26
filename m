Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37611 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdGZVIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 17:08:20 -0400
Received: by mail-wm0-f44.google.com with SMTP id c184so91696155wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jul 2017 14:08:20 -0700 (PDT)
Subject: Re: brcmfmac4356-pcie 4.13 regression (frequent kernel panics) not
 fixed by recent 4.13 regression fix
To: Hans de Goede <hdegoede@redhat.com>
Cc: russianneuromancer@ya.ru, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Igor Nikolic <nikolic.igor@gmail.com>
References: <b3b9dd19-a20d-ac4e-70f1-6059e7ec7d20@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1570e9f5-a52c-77d6-d391-ee8cff9fc3db@broadcom.com> (sfid-20170726_230824_395073_3934C5F7)
Date: Wed, 26 Jul 2017 23:08:17 +0200
MIME-Version: 1.0
In-Reply-To: <b3b9dd19-a20d-ac4e-70f1-6059e7ec7d20@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 23:03, Hans de Goede wrote:
> Hi,
> 
> I've been seeing frequent kernel panics on wifi activity
> (scp-ing a lot of files) with 4.13 on 2 different systems
> which both use a brcmfmac4356-pcie wifi chip.
> 
> This is with this fix:
> https://www.spinics.net/lists/linux-wireless/msg164178.html
> already applied.
> 
> Here is a picture of the panic:
> 
> https://fedorapeople.org/~jwrdegoede/brcmfmac4356-pcie-4.13-panic.jpg
> 
> Reverting commit 270a6c1f65fe ("brcmfmac: rework headroom check in
> .start_xmit()"):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=270a6c1f65fe68a28a5d39cd405592c550b496c7
> 
> 
> seems to fix this (I can no longer quickly reproduce the panic
> by scp-ing a large amount of files).
> 
> Note I've first reverted the:
> https://www.spinics.net/lists/linux-wireless/msg164178.html
> fix so that I could cleanly revert commit 270a6c1f65fe.
> 
> Given that no code seems to use the statics commit 270a6c1f65fe
> offers and it has been the cause of 2 different regressions now,
> it might be best to just revert 270a6c1f65fe for 4.13.

Hi Hans,

I suspect this patch [1] fixes that. Can you verify? And yes, I messed
up. Sorry.

Regards,
Arend
