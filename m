Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7136 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab3IPQDb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 12:03:31 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "'Mike Frysinger'" <vapier@chromium.org>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>
Date: Mon, 16 Sep 2013 08:51:11 -0700
Subject: RE: [PATCH v4] Bluetooth: btmrvl: add calibration data download
 support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59510BD88214E@SC-VEXCH1.marvell.com> (sfid-20130916_180342_857962_B36FD5DF)
In-Reply-To: <CAAbOScnG8RHWbPdjq6=e=EBJPr_f6+R4o36f3h0T=NxGgQt7AQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mike,

Thanks for your comments. We will take care of them in updated version.

> 
> On Fri, Sep 13, 2013 at 7:32 PM, Bing Zhao wrote:
> > --- a/drivers/bluetooth/btmrvl_main.c
> > +++ b/drivers/bluetooth/btmrvl_main.c
> >
> > +static int btmrvl_parse_cal_cfg(const u8 *src, u32 len, u8 *dst, u32
> dst_size)
> 
> would be nice if you put a comment above this func explaining the
> expected format.  otherwise, we see arbitrary parsing with no idea if
> it's correct.

Sure. We will add below information.

Calibrated input data should contain hex bytes separated by space or
new line character. Here is an example
00 1C 01 37 FF FF FF FF 02 04 7F 01
CE BA 00 00 00 2D C6 C0 00 00 00 00
00 F0 00 00

> 
> > +       while ((s - src) < len) {
> > +               if (isspace(*s)) {
> > +                       s++;
> > +                       continue;
> > +               }
> > +
> > +               if (isxdigit(*s)) {
> > +                       if ((d - dst) >= dst_size) {
> > +                               BT_ERR("calibration data file too
> big!!!");
> > +                               return -EINVAL;
> > +                       }
> > +
> > +                       memcpy(tmp, s, 2);
> > +
> > +                       ret = kstrtou8(tmp, 16, d++);
> > +                       if (ret < 0)
> > +                               return ret;
> > +
> > +                       s += 2;
> > +               } else {
> > +                       s++;
> > +               }
> > +       }
> 
> so if it's a space, you skip it.  if it's a hexdigit, you parse two
> bytes.  if it's anything else, you skip it.  i'd imagine the "non
> space and non hexdigit" case should throw a warning if not reject the
> file out right.  otherwise, if you want to keep this logic, punt the
> explicit "isspace" check.

You are right. Rejecting the file containing non space, non new line and non hexdigit character makes sense.

> 
> you might also copy one more byte than you should ?  your limit is "(s
> - src) < len", yet the isxdigit code always copies two bytes.

Thanks for pointing this out. We will replace "(s - src) < len" with "(s -src) <= (len - 2)". 

> 
> > +static int btmrvl_load_cal_data(struct btmrvl_private *priv,
> > +                               u8 *config_data)
> > +{
> > +       struct sk_buff *skb;
> > +       struct btmrvl_cmd *cmd;
> > +       int i;
> > +
> > +       skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
> 
> maybe i'm unfamiliar with bluetooth and this is common, but why is
> your code so special as to require GFP_ATOMIC allocations ?

GFP_ATOMIC was used to match other usages in bluetooth code.
I just found that as per commit "Remove GFP_ATOMIC usage from l2cap_core.c"(commit id: 8bcde1f2ab..), since bluetooth core is now running in process context, we don't need to use GFP_ATOMIC.

We will replace it with GFP_KERNEL in updated version.

> 
> > +       for (i = 4; i < BT_CMD_DATA_SIZE; i++)
> > +               cmd->data[i] = config_data[(i/4)*8 - 1 - i];
> 
> style nit, but there should be spacing around those math operators.
> ignoring the fact that this is some funky funky buffer offsets.
> 
> i = 4
>  config_data[(4 / 4) * 8 - 1 - 4] ->
>  config_data[8 - 1 - 4] ->
>  config_data[3]
> 
> i = 5
>  config_data[(5 / 4) * 8 - 1 - 5] ->
>  config_data[8 - 1 - 5] ->
>  config_data[2]
> 
> i = 6
>  config_data[(6 / 4) * 8 - 1 - 6] ->
>  config_data[8 - 1 - 6] ->
>  config_data[1]
> 
> i = 7
>  config_data[(7 / 4) * 8 - 1 - 7] ->
>  config_data[8 - 1 - 7] ->
>  config_data[0]
> 
> i = 8
>  config_data[(8 / 4) * 8 - 1 - 8] ->
>  config_data[16 - 1 - 8] ->
>  config_data[7]
> 
> i = {4,5,6,7} -> config_data[{3,2,1,0}]
> i = {8,9,10,11} -> config_data[{7,6,5,4}]
> 
> that really could do with a comment explaining the mapping of input
> bytes to output bytes.

Sure. We add a comment here.
Actually each 4 bytes are being swapped. Considering 4 byte SDIO header offset, it becomes
input{3, 2, 1, 0} -> output{0+4, 1+4, 2+4, 3+4}

Regards,
Amitkumar Karwar

> -mike
