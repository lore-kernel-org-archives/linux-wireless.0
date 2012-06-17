Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44364 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757329Ab2FQCxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 22:53:50 -0400
Message-ID: <1339901627.7998.15.camel@hp-dhlii> (sfid-20120617_045431_274233_ED1AC06C)
Subject: CARL9170 driver/firmware questions
From: "David Lynch Jr." <ml@dlasys.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 16 Jun 2012 22:53:47 -0400
In-Reply-To: <201204252201.50803.chunkeey@googlemail.com>
References: <CADdUxCwt35GQU2j-a4AvvJVS=h93sgBqg09CZNxTivRfbYsqzg@mail.gmail.com>
	 <201204252201.50803.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am working on another AR9170 project. 
This essentially requires injecting broadcast packets of specific size,
frequency, ... at extremely precise intervals.

I am trying to understand the data flow in the firmware. 

Initially I was looking to generate the frames in the firmware. 
The payload is simple. Though I am pondering the wisdom of that right
now. Regardless, I will have to control my frames in firmware, so I need
to separate them from normal traffic and then feed them into the Radio
Queues at the appropriate times. 

Am I correct that the same struct dma_desc is being used by both USB and
the Radio ?

Each dma_desc points to a payload, for tx packets this is a  struct
carl9170_tx_superframe, which must also be what the skb pointed to by 
void carl9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb) is
sending ?

Can I construct a carl9170_tx_superframe on the host side, with
something to allow me to identify it in handle_download in the firmware,
perform minor mangling of the contents, and repeatedly transmit it at
fixed intervals using wlan_tx() ?


 

 

