Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60977 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2DJRyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:54:55 -0400
Received: by wibhq7 with SMTP id hq7so58166wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 10:54:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 10:54:54 -0700
Message-ID: <CACct8ekz9K4pma-mrS725B0HBwys9eO_ViFXtyP-_zDb1DC8gQ@mail.gmail.com> (sfid-20120410_195459_332735_6A3BD175)
Subject: Detecting device buffer for AR5212
From: Yiannis Yiakoumis <gyiakoumis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

While doing some measurements, I am trying to detect the actual buffer
on the wireless device (in this case AR5212). I couldn't find any
datasheet that gives relevant details.
By device buffer I don't mean the driver buffer or pending DMA
requests, I rather mean the actual number of descriptors/packets that
left the host's memory and reside at the device.

I looked at two things :

-Pending Frames Register : While I transmit data, this consistently
reports 1. That said, I am not sure whether it reports the packets
currently in the device or the unacknowledged packets in the air.
- The second approach is more rough. I send a train of 50 packets
which become pending DMA requests. I set the descriptors to transmit
at a 6Mbps rate. I wait for time where at maximum one packet could
possibly left the device. I go and change all the descriptors to send
on a different rate. On a monitor device I check the packets in the
air. Depending on which rate I see, I can figure out whether the
descriptor had already left the device or not. I repeat the experiment
for wait times of N packets as well. My preliminary understanding is
that there is only one packet/descriptor DMA'ed on the device at any
given time.  When the packet is transmitted, the device will fetch the
next one to transmit. Not clear whether this is triggered from a
received ack, or AIFS of channel free.

Could somebody comment on that?
- Is indeed a per-packet transmission DMA fetch?
- Also, do the trigger-levels apply only within a packet, or as long
as you are below the TUNE_MAX_TXFIFO you can buffer multiple packets?

Please let me know if you need more details on the setup.

Thanks and Regards,
-- 
Yiannis .
