Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10131 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYC0KLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 06:11:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
Date: Thu, 27 Mar 2008 11:08:23 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200803191524.21866.hs4233@mail.mn-solutions.de> <200803261637.45549.hs4233@mail.mn-solutions.de> <1206552791.31383.99.camel@localhost.localdomain>
In-Reply-To: <1206552791.31383.99.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803271108.23635.hs4233@mail.mn-solutions.de> (sfid-20080327_101128_127959_5EE7C4E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> struct lbs_event {

add "struct list_head list;"

> 	u32 event;  /* MACREG_INT_CODE_xxxxx */
> 	u32 len;
> 	u8 buf[LBS_UPLD_SIZE];
> };

Hmm, buf is LBS_UPLD_SIZE (2312 bytes). However, if_cs.c, 
if_sdio.c and if_usb.c use LBS_CMD_BUFFER_SIZE, which is 2048.


> void lbs_interrupt(struct lbs_private *priv, u32 event, u8
> *resp_data, u32 resp_len) {

With this approach, the driver would have copy the date from the 
hardware into local buffer. Then it would call lbs_interrupt() 
with a pointer to this local buffer. Then lbs_interrupt() would 
memcpy() this. Then something in main.c and/or cmd.c would again 
memcpy() this.

Let's split lbs_interrupt() into two functions:

struct lbs_event *lbs_get_free_event(struct lbs_private *priv);

void lbs_handle_event(struct lbs_private *priv, struct lbs_event 
*event);

Then the hardware driver can do:

  struct lbs_event *event = lbs_get_free_event(priv);
  if (!event)
     ...
  if_cs_receive_cmdres(priv, &event->buf, &event->len);
  lbs_handle_event(priv, event);
