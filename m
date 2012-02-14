Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47540 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2BNUGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 15:06:22 -0500
Received: by wics10 with SMTP id s10so80153wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 12:06:21 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 12:06:21 -0800
Message-ID: <CACct8en2C+fuL81mLwdNUXvvAzyKjj5yjmcWGg_tWHAzQkeF8w@mail.gmail.com> (sfid-20120214_210626_087091_67DBC799)
Subject: ath5k : Where does the actual CSMA take place?
From: Yiannis Yiakoumis <gyiakoumis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am reading the code and trying to understand what forces the packet
out of the card, or to be more clear, what runs CSMA/CA and when
detects a tx opportunity pushes the packet down to the phy. I can
track the packet all the way until it gets to start_tx_dma(), but I am
not clear what is the actual call that sends it out, and how this
relates with QCU (I am on a 5212). I suspect that it's within the
tasklet_schedule but wasn't able to find the details.
Also, does QCU get involved on a packet-per-packet basis, or does it
just set the initial values to the device's registers?

Any help is much appreciated..

Thanks,
-- 
Yiannis .
