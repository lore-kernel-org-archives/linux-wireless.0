Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62231 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCX0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 19:26:43 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so1429136eae.9
        for <linux-wireless@vger.kernel.org>; Thu, 03 Oct 2013 16:26:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F451FB266@SC-VEXCH1.marvell.com>
References: <1380824600-13655-1-git-send-email-bzhao@marvell.com>
	<CAJdJm_N1=a7URKmU8xOsOzOaYHKQdNXiR7VryeOc4+i2uf7RqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430F451FB266@SC-VEXCH1.marvell.com>
Date: Thu, 3 Oct 2013 19:26:41 -0400
Message-ID: <CAJdJm_NJe-wrAHFgrGP5ytMxfgP0RREJCqnE9L=hAbVXbNqFdQ@mail.gmail.com> (sfid-20131004_012656_451074_95A4C154)
Subject: Re: [PATCH] Bluetooth: btmrvl: operate on 16-bit opcodes instead of ogf/ocf
From: Anderson Lizardo <anderson.lizardo@openbossa.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: BlueZ development <linux-bluetooth@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Thu, Oct 3, 2013 at 5:06 PM, Bing Zhao <bzhao@marvell.com> wrote:
>> >         hdr = (struct hci_command_hdr *)skb_put(skb, HCI_COMMAND_HDR_SIZE);
>> > -       hdr->opcode = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
>> > +       hdr->opcode = cpu_to_le16(opcode);
>>
>> Are you sure the callers of btmrvl_send_sync_cmd() do not need to be
>> changed to pass an opcode instead of just the OCF?
>
> Previously we pass the cmd_no which is the OCF bits to the function, and the function packs it to opcode.
>
> Now I changed the macros of the cmd_no from OCF to opcode as shown below, so no change to the callers.
>
> -/* Bluetooth commands  */
> -#define BT_CMD_AUTO_SLEEP_MODE         0x23
> -#define BT_CMD_HOST_SLEEP_CONFIG       0x59
> -#define BT_CMD_HOST_SLEEP_ENABLE       0x5A
> -#define BT_CMD_MODULE_CFG_REQ          0x5B
> -#define BT_CMD_LOAD_CONFIG_DATA                0x61
> +/* Vendor specific Bluetooth commands */
> +#define BT_CMD_AUTO_SLEEP_MODE         0xFC23
> +#define BT_CMD_HOST_SLEEP_CONFIG       0xFC59
> +#define BT_CMD_HOST_SLEEP_ENABLE       0xFC5A
> +#define BT_CMD_MODULE_CFG_REQ          0xFC5B
> +#define BT_CMD_LOAD_CONFIG_DATA                0xFC61

Now I got it :)

Best Regards,
-- 
Anderson Lizardo
Instituto Nokia de Tecnologia - INdT
Manaus - Brazil
