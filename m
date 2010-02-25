Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53519 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab0BYUqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 15:46:30 -0500
Received: by wya21 with SMTP id 21so2091476wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 12:46:29 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: prahal@yahoo.com
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation. (without fallback change)
Date: Thu, 25 Feb 2010 21:46:22 +0100
Cc: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Josef Bacik <josef@redhat.com>
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj> <4B86D0BD.3000803@yahoo.com>
In-Reply-To: <4B86D0BD.3000803@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002252146.22846.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Overall this patch has great similarities to something which Josef (CC added)
has posted earlier. The patch in question was not merged due to some issues,
but he is working on an updated. You might want to synchronize your work
with him. :)

> >> +	for (i=0; i<256; i++) {
> >>      
> > checkpatch.pl complains about spacing.  There should be spaces around
> > "=" and"<"

Also I prefer the:
	while (!rt2x00queue_empty(queue)) {

version from Josef's patch.

> >> +		rt2x00_desc_read(txwi, 1,&word);
> >> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> >> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> >> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> >> +
> >> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
> >> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
> >>      
> > Can we make this sanity check optional?
> >
> >    
> Is this a showstopper ? Do you mean only enabling this message telling 
> something totally
> unexpected happened in debug mode ? The sanity of the queue is pretty 
> critical for operation.

I don't think this should be a showstopper, in fact how often would this error be printed?
Is it regularly, like the rt61pci bug where not all TX done events were raised, or is it really
a very rare case?

Ivo
