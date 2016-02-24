Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36712 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbcBXSla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 13:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
Date: Wed, 24 Feb 2016 10:41:29 -0800
Message-ID: <CAM_iQpX3X6YoFeMw2KYjJM8yBHi9=3iapo0+a9Cqtc0cxM_QNA@mail.gmail.com> (sfid-20160224_194139_686418_6F2E3986)
Subject: Re: [PATCH v2 net] nfc: use GFP_USER for user-controlled kmalloc
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 11:24 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> These two functions are called in sendmsg path, and the
> 'len' is passed from user-space, so we should not allow
> malicious users to OOM kernel on purpose.
>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Ping...

David, this patch seems still not applied, I guess you expect NFC
maintainer to take it, but this doesn't happen. Could you take it?

(I can resend it if you need.)

Thanks!

> ---
>  net/nfc/llcp_commands.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 3621a90..3425532 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -663,7 +663,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
>                 return -ENOBUFS;
>         }
>
> -       msg_data = kzalloc(len, GFP_KERNEL);
> +       msg_data = kmalloc(len, GFP_USER | __GFP_NOWARN);
>         if (msg_data == NULL)
>                 return -ENOMEM;
>
> @@ -729,7 +729,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>         if (local == NULL)
>                 return -ENODEV;
>
> -       msg_data = kzalloc(len, GFP_KERNEL);
> +       msg_data = kmalloc(len, GFP_USER | __GFP_NOWARN);
>         if (msg_data == NULL)
>                 return -ENOMEM;
>
> --
> 1.8.3.1
>
