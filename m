Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751826AbdKHLfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 06:35:24 -0500
Date: Wed, 8 Nov 2017 12:35:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
Message-ID: <20171108113521.GD2641@redhat.com> (sfid-20171108_123539_232799_F3CAB122)
References: <1509983829.10974.2.camel@gmail.com>
 <20171107085327.GA11380@redhat.com>
 <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
 <20171107101320.GA12140@redhat.com>
 <1510052483.24015.1.camel@gmail.com>
 <20171108103729.GA2641@redhat.com>
 <1510139235.10467.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1510139235.10467.1.camel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 08, 2017 at 12:07:15PM +0100, Richard Genoud wrote:
> > No, that not I wanted you to do. Please remove those options and just
> > do
> > below on tracing directory.
> > 
> > echo 0 > tracing_on 
> > cat trace >  /dev/null
> > echo "function_graph" > current_tracer 
> > echo "rt2*" > set_ftrace_filter 
> > echo 1 > tracing_on
> > echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
> > echo 0 > tracing_on
> > cat trace > ~/trace.txt
> 
> Well, there's clearly a misunderstanding here :
> After the command "echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind"
> I can't type *anything*
> The only thing I can do is plug off the board.
> This command never returns, so I can't stop the tracing...
> 
> Or I missed something ?
> 
> (maybe if there was more than one CPU on the board, I could do
> something, but that's not the case)

I was not aware that soft-lock up can hung the system.

Below patch should prevent/help with the issue. This is
not right fix, it's for futher debugging.

Regards
Stanislaw 

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index e2f4f5778267..d76ca608c722 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -321,8 +321,8 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV)
-			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+		printk("submit TX urb ERROR %d\n", status);
+		clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
@@ -410,8 +410,8 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV)
-			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+		printk("submit RX urb ERROR %d\n", status);
+		clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
