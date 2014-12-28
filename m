Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:33714 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaL1Vzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2014 16:55:35 -0500
Message-ID: <54A07C54.6040407@broadcom.com> (sfid-20141228_225539_536339_E3FDB49C)
Date: Sun, 28 Dec 2014 22:55:32 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Vaishali Thakkar <vthakkar1994@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] NFC: port100: Introduce the use of function put_unaligned_le16
References: <20141224131557.GA2591@vaishali-Ideapad-Z570>	<CAK-LDbJgwdWLZf9tH67sFdYodX0u+t2RGuwsJF3a1-8o0=RBPg@mail.gmail.com>	<54A01EBF.2020608@broadcom.com> <CAK-LDb+saP+1fXmOqmiKzBmBR2Bh-o0kdomkRBHY4uJG5DoemA@mail.gmail.com>
In-Reply-To: <CAK-LDb+saP+1fXmOqmiKzBmBR2Bh-o0kdomkRBHY4uJG5DoemA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/14 17:34, Vaishali Thakkar wrote:
>
> On Dec 28, 2014 8:46 PM, "Arend van Spriel" <arend@broadcom.com
> <mailto:arend@broadcom.com>> wrote:
>  >
>  > + Samuel
>  >
>  >
>  > On 12/28/14 12:33, Vaishali Thakkar wrote:
>  >>
>  >> On Wed, Dec 24, 2014 at 6:45 PM, Vaishali Thakkar
>  >> <vthakkar1994@gmail.com <mailto:vthakkar1994@gmail.com>> wrote:
>  >>>
>  >>> This patch introduces the use of function put_unaligned_le16.
>  >>>
>  >>> This is done using Coccinelle and semantic patch used is as follows:
>  >>>
>  >>> @a@
>  >>> typedef u16, __le16;
>  >>> {u16,__le16} e16;
>  >>> identifier tmp;
>  >>> expression ptr;
>  >>> expression y,e;
>  >>> type T;
>  >>> @@
>  >>>
>  >>> - tmp = cpu_to_le16(y);
>  >>>
>  >>> <+... when != tmp
>  >>> (
>  >>> - memcpy(ptr, (T)&tmp,
> \(2\|sizeof(u16)\|sizeof(__le16)\|sizeof(e16)\));
>  >>> + put_unaligned_le16(y,ptr);
>  >>> |
>  >>> - memcpy(ptr, (T)&tmp, ...);
>  >>> + put_unaligned_le16(y,ptr);
>  >>> )
>  >>> ...+>
>  >>> ? tmp = e
>  >>>
>  >>> @@ type T; identifier a.tmp; @@
>  >>>
>  >>> - T tmp;
>  >>> ...when != tmp
>  >>>
>  >>> Signed-off-by: Vaishali Thakkar<vthakkar1994@gmail.com
> <mailto:vthakkar1994@gmail.com>>
>  >>> ---
>  >>> Changes since v1:
>  >>> <asm/unaligned.h> has arch-specific knowlege of which of
>  >>> the implementations needs to be used. So, include it instaed
>  >>> of<linux/unaligned/access_ok.h>.
>  >>> Changes since v2:
>  >>> Fix typing mistake in subject
>  >>>
>  >>> drivers/nfc/port100.c | 6 ++----
>  >>> 1 file changed, 2 insertions(+), 4 deletions(-)
>  >>>
>  >>> diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
>  >>> index 4ac4d31..440f0f3 100644
>  >>> --- a/drivers/nfc/port100.c
>  >>> +++ b/drivers/nfc/port100.c
>  >>> @@ -18,6 +18,7 @@
>  >>> #include<linux/module.h>
>  >>> #include<linux/usb.h>
>  >>> #include<net/nfc/digital.h>
>  >>> +#include<asm/unaligned.h>
>  >>>
>  >>> #define VERSION "0.1"
>  >>>
>  >>> @@ -1136,7 +1137,6 @@ static int port100_in_send_cmd(struct
> nfc_digital_dev *ddev,
>  >>> {
>  >>> struct port100 *dev = nfc_digital_get_drvdata(ddev);
>  >>> struct port100_cb_arg *cb_arg;
>  >>> - __le16 timeout;
>  >>>
>  >>> cb_arg = kzalloc(sizeof(struct port100_cb_arg), GFP_KERNEL);
>  >>> if (!cb_arg)
>  >>> @@ -1145,9 +1145,7 @@ static int port100_in_send_cmd(struct
> nfc_digital_dev *ddev,
>  >>> cb_arg->complete_cb = cb;
>  >>> cb_arg->complete_arg = arg;
>  >>>
>  >>> - timeout = cpu_to_le16(_timeout * 10);
>  >>> -
>  >>> - memcpy(skb_push(skb, sizeof(__le16)),&timeout, sizeof(__le16));
>  >>>
>  >>> + put_unaligned_le16(_timeout * 10, skb_push(skb, sizeof(__le16)));
>  >>>
>  >>> return port100_send_cmd_async(dev, PORT100_CMD_IN_COMM_RF, skb,
>  >>> port100_in_comm_rf_complete, cb_arg);
>  >>> --
>  >>> 1.9.1
>  >>>
>  >>
>  >> Hello...Can someone please review my patch so that I can have idea
>  >> about I am on a right way or not??
>  >> I think this is missed by developers.
>  >
>  >
>  > Generally that's not how it works. You either get comments or not. It
> may also help to send the patch to the maintainer, ie. Samuel Ortiz.
>
> Oh.ok. Sorry for the noise.
>
> Actually original patch was Cc'd to maintainer also. But as a newbie, I
> thought may be it is missed or I am wrong somewhere. That's why just
> asked it on mailing list. Anyways got your point.

No problem. You were not that noisy ;-)

Regards,
Arend

> Thanks.
>
>  > Regards,
>  > Arend
>  >
>  >> Thank You.
>  >>
>  >
>

