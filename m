Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750923AbeEUITm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 04:19:42 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [EXT] Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device
 coredump
Date: Mon, 21 May 2018 08:19:35 +0000
Message-ID: <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com> (sfid-20180521_101946_416434_CC598212)
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
 <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
 <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com> <5AFC7E01.3070503@broadcom.com>
In-Reply-To: <5AFC7E01.3070503@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi arend.vanspriel,
>
> ----------------------------------------------------------------------
> On 5/16/2018 3:50 PM, Kalle Valo wrote:
> > Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> >
> >> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> >> it is possible to initiate a device coredump from user-space. This
> >> patch adds support for it adding the .coredump() driver callback.
> >> As there is no longer a need to initiate it through debugfs remove
> >> that code.
> >>
> >> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> >> ---
> >>   V2:
> >>    - export mwifiex_send_cmd() needed by mwifiex_usb.ko.
> >> ---
> >>   drivers/net/wireless/marvell/mwifiex/cmdevt.c  |  1 +
> >>   drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +----------------------
> ---
> >>   drivers/net/wireless/marvell/mwifiex/pcie.c    | 18 +++++++++++++--
> >>   drivers/net/wireless/marvell/mwifiex/sdio.c    | 12 ++++++++++
> >>   drivers/net/wireless/marvell/mwifiex/usb.c     | 13 +++++++++++
> >>   5 files changed, 43 insertions(+), 32 deletions(-)
> >
> > You forgot to CC mwifiex maintainers, doing it now. Full patch here:
> >
> > https://patchwork.kernel.org/patch/10403717/
>
> Thanks, Kalle
>
> You would almost think I am not used to submit patches for drivers I do not
> actively maintain ;-)
>
> Gr. AvS
In V2:

        return ret;
 }
+EXPORT_SYMBOL_GPL(mwifiex_send_cmd);

Instead of exporting 'mwifiex_send_cmd'  we can prepare a wrapper for the command 'MWIFIEX_IFACE_WORK_DEVICE_DUMP' in mwifiex module. Let me know if we can send a follow up.

Thanks,
Ganapathi
