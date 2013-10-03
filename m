Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6800 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819Ab3JCVG6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 17:06:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Anderson Lizardo <anderson.lizardo@openbossa.org>
CC: BlueZ development <linux-bluetooth@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 3 Oct 2013 14:06:40 -0700
Subject: RE: [PATCH] Bluetooth: btmrvl: operate on 16-bit opcodes instead of
 ogf/ocf
Message-ID: <477F20668A386D41ADCC57781B1F70430F451FB266@SC-VEXCH1.marvell.com> (sfid-20131003_230718_301595_CF0F9859)
References: <1380824600-13655-1-git-send-email-bzhao@marvell.com>
 <CAJdJm_N1=a7URKmU8xOsOzOaYHKQdNXiR7VryeOc4+i2uf7RqQ@mail.gmail.com>
In-Reply-To: <CAJdJm_N1=a7URKmU8xOsOzOaYHKQdNXiR7VryeOc4+i2uf7RqQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anderson,

Thanks for your comments.

> > -               if (ogf == OGF) {
> > -                       BT_DBG("vendor event skipped: ogf 0x%4.4x ocf 0x%4.4x",
> > -                              ogf, ocf);
> > +               if ((opcode & 0xfc00) == 0xfc00) {
> > +                       BT_DBG("vendor event skipped: opcode=%#4.4x", opcode);
> 
> I think you could use "if (hci_opcode_ogf(opcode) == 0x3F)" to make it
> more readable.

Sure, I will make that change in v2.

> > @@ -179,7 +176,7 @@ static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
> >         }
> >
> >         hdr = (struct hci_command_hdr *)skb_put(skb, HCI_COMMAND_HDR_SIZE);
> > -       hdr->opcode = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
> > +       hdr->opcode = cpu_to_le16(opcode);
> 
> Are you sure the callers of btmrvl_send_sync_cmd() do not need to be
> changed to pass an opcode instead of just the OCF?

Previously we pass the cmd_no which is the OCF bits to the function, and the function packs it to opcode.

Now I changed the macros of the cmd_no from OCF to opcode as shown below, so no change to the callers.

-/* Bluetooth commands  */
-#define BT_CMD_AUTO_SLEEP_MODE		0x23
-#define BT_CMD_HOST_SLEEP_CONFIG	0x59
-#define BT_CMD_HOST_SLEEP_ENABLE	0x5A
-#define BT_CMD_MODULE_CFG_REQ		0x5B
-#define BT_CMD_LOAD_CONFIG_DATA		0x61
+/* Vendor specific Bluetooth commands */
+#define BT_CMD_AUTO_SLEEP_MODE		0xFC23
+#define BT_CMD_HOST_SLEEP_CONFIG	0xFC59
+#define BT_CMD_HOST_SLEEP_ENABLE	0xFC5A
+#define BT_CMD_MODULE_CFG_REQ		0xFC5B
+#define BT_CMD_LOAD_CONFIG_DATA		0xFC61

Thanks,
Bing
