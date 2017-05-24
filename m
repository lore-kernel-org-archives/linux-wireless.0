Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34629 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935795AbdEXQ6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 12:58:25 -0400
Received: by mail-io0-f178.google.com with SMTP id k91so121550650ioi.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 09:58:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170524102620.13806-1-mjurczyk@google.com>
References: <20170524102620.13806-1-mjurczyk@google.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 09:58:23 -0700
Message-ID: <CAGXu5jJRXhJSC34vSc19mPQ9Wetf92daar71He0OXDUebXu0bA@mail.gmail.com> (sfid-20170524_185909_375593_5233ADEE)
Subject: Re: [PATCH] nfc: Fix the sockaddr length sanitization in llcp_sock_connect
To: Mateusz Jurczyk <mjurczyk@google.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 3:26 AM, Mateusz Jurczyk <mjurczyk@google.com> wrote:
> Fix the sockaddr length verification in the connect() handler of NFC/LLCP
> sockets, to compare against the size of the actual structure expected on
> input (sockaddr_nfc_llcp) instead of its shorter version (sockaddr_nfc).
>
> Both structures are defined in include/uapi/linux/nfc.h. The fields
> specific to the _llcp extended struct are as follows:
>
>    276          __u8 dsap; /* Destination SAP, if known */
>    277          __u8 ssap; /* Source SAP to be bound to */
>    278          char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
>    279          size_t service_name_len;
>
> If the caller doesn't provide a sufficiently long sockaddr buffer, these
> fields remain uninitialized (and they currently originate from the stack
> frame of the top-level sys_connect handler). They are then copied by
> llcp_sock_connect() into internal storage (nfc_llcp_sock structure), and
> could be subsequently read back through the user-mode getsockname()
> function (handled by llcp_sock_getname()). This would result in the
> disclosure of up to ~70 uninitialized bytes from the kernel stack to
> user-mode clients capable of creating AFC_NFC sockets.
>
> Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  net/nfc/llcp_sock.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> index 2ffb18e73df6..d0d12bea65cb 100644
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -662,8 +662,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
>
>         pr_debug("sock %p sk %p flags 0x%x\n", sock, sk, flags);
>
> -       if (!addr || len < sizeof(struct sockaddr_nfc) ||
> -           addr->sa_family != AF_NFC)
> +       if (!addr || len < sizeof(*addr) || addr->sa_family != AF_NFC)
>                 return -EINVAL;
>
>         if (addr->service_name_len == 0 && addr->dsap == 0)
> --
> 2.13.0.219.gdb65acc882-goog
>



-- 
Kees Cook
Pixel Security
