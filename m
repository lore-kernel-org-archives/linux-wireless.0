Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:39863 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965451AbeEIVxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:53:33 -0400
Received: by mail-wm0-f48.google.com with SMTP id f8-v6so930470wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 14:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
References: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 9 May 2018 23:53:31 +0200
Message-ID: <CACna6rzp50vYaHR_YdzeFz6V39VYP8TUEjWbVmfjU2UWgDLT0g@mail.gmail.com> (sfid-20180509_235337_407481_D54238D6)
Subject: Re: [PATCH] ssb: Fix regression caused by disabling PCI cores on
 non-MIPS architecture
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 May 2018 at 18:42, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some MPIS-based SoCs use chips driven by b43 for wireless capability.
> When ssb is configured as a module, build errors happen on these
> platforms as described in the commit 882164a4a928 ("ssb: Prevent build
> of PCI host features in module"). Unfortunately that change leads to
> the removal of code needed for correct operation on platforms that use
> PCI cores on the chip bus. The fix allows ssb to be build as a module
> for all architectures other than MIPS. This approach is ad-hoc, but it
> is the same as done in commit a9e6d44ddecc ("ssb: Do not disable PCI
> host on non-Mips").
>
> This problem was reported and discussed in
> https://bugzilla.redhat.com/show_bug.cgi?id=1572349.

I'll try to look at that tomorrow
