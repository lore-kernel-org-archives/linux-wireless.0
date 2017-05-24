Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35152 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752153AbdEXRFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 13:05:49 -0400
Received: by mail-io0-f181.google.com with SMTP id f102so121034209ioi.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 10:05:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170524104226.14841-1-mjurczyk@google.com>
References: <20170524104226.14841-1-mjurczyk@google.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 10:05:48 -0700
Message-ID: <CAGXu5jK3aX-AFXCk9=hhX49scgGOHBYXocsNJb8u+ienMuM65g@mail.gmail.com> (sfid-20170524_190655_617956_DBF6EE3F)
Subject: Re: [PATCH] nfc: Ensure presence of required attributes in the
 activate_target netlink handler
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

On Wed, May 24, 2017 at 3:42 AM, Mateusz Jurczyk <mjurczyk@google.com> wrote:
> Check that the NFC_ATTR_TARGET_INDEX and NFC_ATTR_PROTOCOLS attributes (in
> addition to NFC_ATTR_DEVICE_INDEX) are provided by the netlink client
> prior to accessing them. This prevents potential unhandled NULL pointer
> dereference exceptions which can be triggered by malicious user-mode
> programs, if they omit one or both of these attributes.
>
> Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  net/nfc/netlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 6b0850e63e09..b251fb936a27 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -907,7 +907,9 @@ static int nfc_genl_activate_target(struct sk_buff *skb, struct genl_info *info)
>         u32 device_idx, target_idx, protocol;
>         int rc;
>
> -       if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> +       if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
> +           !info->attrs[NFC_ATTR_TARGET_INDEX] ||
> +           !info->attrs[NFC_ATTR_PROTOCOLS])
>                 return -EINVAL;
>
>         device_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> --
> 2.13.0.219.gdb65acc882-goog
>



-- 
Kees Cook
Pixel Security
