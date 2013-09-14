Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45564 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3INEEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 00:04:46 -0400
Received: by mail-ie0-f169.google.com with SMTP id tp5so4359659ieb.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 21:04:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379115162-10194-1-git-send-email-bzhao@marvell.com>
References: <1379115162-10194-1-git-send-email-bzhao@marvell.com>
From: Mike Frysinger <vapier@chromium.org>
Date: Sat, 14 Sep 2013 00:04:25 -0400
Message-ID: <CAAbOScnG8RHWbPdjq6=e=EBJPr_f6+R4o36f3h0T=NxGgQt7AQ@mail.gmail.com> (sfid-20130914_060451_448107_26126CD0)
Subject: Re: [PATCH v4] Bluetooth: btmrvl: add calibration data download support
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 13, 2013 at 7:32 PM, Bing Zhao wrote:
> --- a/drivers/bluetooth/btmrvl_main.c
> +++ b/drivers/bluetooth/btmrvl_main.c
>
> +static int btmrvl_parse_cal_cfg(const u8 *src, u32 len, u8 *dst, u32 dst_size)

would be nice if you put a comment above this func explaining the
expected format.  otherwise, we see arbitrary parsing with no idea if
it's correct.

> +       while ((s - src) < len) {
> +               if (isspace(*s)) {
> +                       s++;
> +                       continue;
> +               }
> +
> +               if (isxdigit(*s)) {
> +                       if ((d - dst) >= dst_size) {
> +                               BT_ERR("calibration data file too big!!!");
> +                               return -EINVAL;
> +                       }
> +
> +                       memcpy(tmp, s, 2);
> +
> +                       ret = kstrtou8(tmp, 16, d++);
> +                       if (ret < 0)
> +                               return ret;
> +
> +                       s += 2;
> +               } else {
> +                       s++;
> +               }
> +       }

so if it's a space, you skip it.  if it's a hexdigit, you parse two
bytes.  if it's anything else, you skip it.  i'd imagine the "non
space and non hexdigit" case should throw a warning if not reject the
file out right.  otherwise, if you want to keep this logic, punt the
explicit "isspace" check.

you might also copy one more byte than you should ?  your limit is "(s
- src) < len", yet the isxdigit code always copies two bytes.

> +static int btmrvl_load_cal_data(struct btmrvl_private *priv,
> +                               u8 *config_data)
> +{
> +       struct sk_buff *skb;
> +       struct btmrvl_cmd *cmd;
> +       int i;
> +
> +       skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);

maybe i'm unfamiliar with bluetooth and this is common, but why is
your code so special as to require GFP_ATOMIC allocations ?

> +       for (i = 4; i < BT_CMD_DATA_SIZE; i++)
> +               cmd->data[i] = config_data[(i/4)*8 - 1 - i];

style nit, but there should be spacing around those math operators.
ignoring the fact that this is some funky funky buffer offsets.

i = 4
 config_data[(4 / 4) * 8 - 1 - 4] ->
 config_data[8 - 1 - 4] ->
 config_data[3]

i = 5
 config_data[(5 / 4) * 8 - 1 - 5] ->
 config_data[8 - 1 - 5] ->
 config_data[2]

i = 6
 config_data[(6 / 4) * 8 - 1 - 6] ->
 config_data[8 - 1 - 6] ->
 config_data[1]

i = 7
 config_data[(7 / 4) * 8 - 1 - 7] ->
 config_data[8 - 1 - 7] ->
 config_data[0]

i = 8
 config_data[(8 / 4) * 8 - 1 - 8] ->
 config_data[16 - 1 - 8] ->
 config_data[7]

i = {4,5,6,7} -> config_data[{3,2,1,0}]
i = {8,9,10,11} -> config_data[{7,6,5,4}]

that really could do with a comment explaining the mapping of input
bytes to output bytes.
-mike
