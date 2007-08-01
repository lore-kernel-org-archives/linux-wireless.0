Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:39394 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759796AbXHAJxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 05:53:22 -0400
Message-ID: <46B0580F.3010403@warmcat.com>
Date: Wed, 01 Aug 2007 10:53:19 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: libertas: blows chunks on failed firmware load
References: <46AF913F.9010006@warmcat.com> <200708010900.00514.hs4233@mail.mn-solutions.de> <46B04704.3000409@warmcat.com> <200708011131.22390.hs4233@mail.mn-solutions.de>
In-Reply-To: <200708011131.22390.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
>> Sure I will try it tonight, where should I go to get it?  The
>> only trees with "libertas" in the name on git.kernel.org don't
>> seem to be the ones.
> 
> My driver is for sure in the libertas-dev tree from the OLPC 
> people. The SVN project that contains the firmware cutter also 
> contains code to checkout this tree and select the proper branch 
> in this tree.
> 
> 
> Basically, you do
> 
> git clone --reference XXXX git://git.infradead.org/libertas-2.6
> cd libertas-2.6
> git branch libertas-cf
> git checkout libertas-cf
> git pull origin libertas

OK I guess what I will try tonight is pulling that tree and then adding
the libertas dir into a copy of wireless-dev, since I want to stay close
to wireless-dev generally at the moment.  That worked for the rt73usb
tree yesterday.

> However, I've "Signed-Up" this driver and asked Dan to forward it 
> into wireless-dev. He hasn't done this yet :-(

I guess for patch providers patches are golden, valuable nuggets that
the world inexplicably hates on... for the upstream recipient it's
probably more like a terrifying unknown burden.  FWIW periodic polite
nagging seems to be a mutually acceptable way forward... hey.. it looks
like you discovered it already ;-)

> If anyone want's to review the patch (in addition to what people 
> did on the libertas-dev mailing list), here's an URL:
> 
> http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=9e25bb4c6ed9430e166b69f9f91bfccd96f0869d

I found that checkpatch.pl is pretty cool in a dominatrix kind of way:

$ ./scripts/checkpatch.pl
/home/agreen/libertas-2.6.git-9e25bb4c6ed9430e166b69f9f91bfccd96f0869d.patch
ERROR: do not initialise statics to 0 or NULL
#135: FILE: drivers/net/wireless/libertas/if_cs.c:76:
+static int debug_output = 0;

WARNING: line over 80 characters
#206: FILE: drivers/net/wireless/libertas/if_cs.c:147:
+static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint
addr, u8 reg)

WARNING: declaring multiple variables together should be avoided
#211: FILE: drivers/net/wireless/libertas/if_cs.c:152:
+               u8 val = if_cs_read8(card, addr);

WARNING: line over 80 characters
#324: FILE: drivers/net/wireless/libertas/if_cs.c:265:
+               if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause &
IF_CS_C_IC_MASK);

WARNING: declaring multiple variables together should be avoided
#353: FILE: drivers/net/wireless/libertas/if_cs.c:294:
+               u16 val = if_cs_read16(card, IF_CS_C_STATUS);

ERROR: "foo* bar" should be "foo *bar"
#411: FILE: drivers/net/wireless/libertas/if_cs.c:352:
+static int if_cs_receive_cmdres(wlan_private *priv, u8* data, u32 *len)

WARNING: line over 80 characters
#427: FILE: drivers/net/wireless/libertas/if_cs.c:368:
+               lbs_pr_err("card cmd buffer has invalid # of bytes
(%d)\n", *len);

WARNING: line over 80 characters
#453: FILE: drivers/net/wireless/libertas/if_cs.c:394:
+               lbs_pr_err("card data buffer has invalid # of bytes
(%d)\n", len);

WARNING: line over 80 characters
#459: FILE: drivers/net/wireless/libertas/if_cs.c:400:
+       //TODO: skb =
dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LEN+EXTRA_LEN);

ERROR: do not use C99 // comments
#459: FILE: drivers/net/wireless/libertas/if_cs.c:400:
+       //TODO: skb =
dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LEN+EXTRA_LEN);

WARNING: line over 80 characters
#599: FILE: drivers/net/wireless/libertas/if_cs.c:540:
+       ret = if_cs_poll_while_fw_download(card, IF_CS_C_SQ_READ_LOW,
IF_CS_C_SQ_HELPER_OK);

ERROR: braces {} are not necessary for single statement blocks
#616: FILE: drivers/net/wireless/libertas/if_cs.c:557:
+               } else {
+                       retry = 0;
+               }

ERROR: braces {} are not necessary for single statement blocks
#625: FILE: drivers/net/wireless/libertas/if_cs.c:566:
+               if (retry) {
+                       sent -= len;
+               }

ERROR: do not use C99 // comments
#743: FILE: drivers/net/wireless/libertas/if_cs.c:684:
+       //wlan_adapter *adapter = priv->adapter;

ERROR: braces {} are not necessary for single statement blocks
#772: FILE: drivers/net/wireless/libertas/if_cs.c:713:
+       if (*ireg & IF_CS_C_S_TX_DNLD_RDY) {
+               priv->dnld_sent = DNLD_RES_RECEIVED;
+       }

ERROR: braces {} are not necessary for single statement blocks
#782: FILE: drivers/net/wireless/libertas/if_cs.c:723:
+               } else {
+                       cmdbuf = priv->adapter->cur_cmd->bufvirtualaddr;
+               }

WARNING: line over 80 characters
#793: FILE: drivers/net/wireless/libertas/if_cs.c:734:
+       lbs_deb_leave_args(LBS_DEB_CS, "ret %d, ireg 0x%x, hisregcpy
0x%x", ret, *ireg, priv->adapter->hisregcpy);

WARNING: line over 80 characters
#802: FILE: drivers/net/wireless/libertas/if_cs.c:743:
+       priv->adapter->eventcause = (if_cs_read16(priv->card,
IF_CS_C_STATUS) & IF_CS_C_S_STATUS_MASK) >> 5;

ERROR: That open brace { should be on the previous line
#878: FILE: drivers/net/wireless/libertas/if_cs.c:819:
+       if ((ret = pcmcia_get_first_tuple(p_dev, &tuple)) != 0 ||
+           (ret = pcmcia_get_tuple_data(p_dev, &tuple)) != 0 ||
+           (ret = pcmcia_parse_tuple(p_dev, &tuple, &parse)) != 0)
+       {
ERROR: do not use assignment in if condition
#878: FILE: drivers/net/wireless/libertas/if_cs.c:819:
+       if ((ret = pcmcia_get_first_tuple(p_dev, &tuple)) != 0 ||

ERROR: braces {} are not necessary for single statement blocks
#889: FILE: drivers/net/wireless/libertas/if_cs.c:830:
+       if (cfg->irq.IRQInfo1) {
+               p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
+       }

-Andy
