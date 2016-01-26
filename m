Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35165 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcAZW4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 17:56:15 -0500
MIME-Version: 1.0
In-Reply-To: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 27 Jan 2016 09:55:55 +1100
Message-ID: <CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com> (sfid-20160126_235621_296707_3458CAB7)
Subject: Re: [PATCH RESEND net] nfc: use GFP_USER for user-controlled kmalloc
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, dvyukov@google.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cong,

On Wed, Jan 27, 2016 at 4:53 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:

A commit message would be nice. A brief rundown of how this is called
from userspace would be nice (I'm talking a single sentence here, e.g.
"this is allocated when submitting a nfc packet") and what issue
__GFP_NOWARN is fixing. (I'm guessing log spam due to allocation
failures.)

> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/nfc/llcp_commands.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 3621a90..5d94055 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -729,7 +729,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>         if (local == NULL)
>                 return -ENODEV;
>
> -       msg_data = kzalloc(len, GFP_KERNEL);
> +       msg_data = kzalloc(len, GFP_USER | __GFP_NOWARN);
>         if (msg_data == NULL)
>                 return -ENOMEM;

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
