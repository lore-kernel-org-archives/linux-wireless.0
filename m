Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49032 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3JCUeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 16:34:12 -0400
Received: by mail-ea0-f181.google.com with SMTP id d10so1387054eaj.12
        for <linux-wireless@vger.kernel.org>; Thu, 03 Oct 2013 13:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380824600-13655-1-git-send-email-bzhao@marvell.com>
References: <1380824600-13655-1-git-send-email-bzhao@marvell.com>
Date: Thu, 3 Oct 2013 16:34:11 -0400
Message-ID: <CAJdJm_N1=a7URKmU8xOsOzOaYHKQdNXiR7VryeOc4+i2uf7RqQ@mail.gmail.com> (sfid-20131003_223416_088224_1741422B)
Subject: Re: [PATCH] Bluetooth: btmrvl: operate on 16-bit opcodes instead of ogf/ocf
From: Anderson Lizardo <anderson.lizardo@openbossa.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: BlueZ development <linux-bluetooth@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Thu, Oct 3, 2013 at 2:23 PM, Bing Zhao <bzhao@marvell.com> wrote:
> @@ -63,9 +61,8 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
>                         wake_up_interruptible(&priv->adapter->cmd_wait_q);
>                 }
>
> -               if (ogf == OGF) {
> -                       BT_DBG("vendor event skipped: ogf 0x%4.4x ocf 0x%4.4x",
> -                              ogf, ocf);
> +               if ((opcode & 0xfc00) == 0xfc00) {
> +                       BT_DBG("vendor event skipped: opcode=%#4.4x", opcode);

I think you could use "if (hci_opcode_ogf(opcode) == 0x3F)" to make it
more readable.

> @@ -166,7 +163,7 @@ exit:
>  }
>  EXPORT_SYMBOL_GPL(btmrvl_process_event);
>
> -static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
> +static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 opcode,
>                                 const void *param, u8 len)
>  {
>         struct sk_buff *skb;
> @@ -179,7 +176,7 @@ static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
>         }
>
>         hdr = (struct hci_command_hdr *)skb_put(skb, HCI_COMMAND_HDR_SIZE);
> -       hdr->opcode = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
> +       hdr->opcode = cpu_to_le16(opcode);

Are you sure the callers of btmrvl_send_sync_cmd() do not need to be
changed to pass an opcode instead of just the OCF?

Best Regards,
-- 
Anderson Lizardo
Instituto Nokia de Tecnologia - INdT
Manaus - Brazil
