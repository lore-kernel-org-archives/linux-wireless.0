Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33313 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab1GESi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 14:38:59 -0400
Received: by bwd14 with SMTP id 14so5487500bwd.28
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 11:38:56 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] wl12xx: fix Tx security sequence number handling
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Oz Krakowski <ozk@ti.com>
In-Reply-To: <1309073764-24219-1-git-send-email-arik@wizery.com>
References: <1309073764-24219-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 21:38:52 +0300
Message-ID: <1309891132.1514.503.camel@cumari> (sfid-20110705_203902_298367_5E7A95AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-06-26 at 10:36 +0300, Arik Nemtsov wrote: 
> From: Oz Krakowski <ozk@ti.com>
> 
> Do not reset the security sequence number when issuing a join command or
> interface is removed. Instead, reset the counter only during the unjoin
> command.
> 
> Added the notion of counter wrap-around to the LSB number in
> wl1271_tx_complete_packet.
> 
> Added post recovery padding to adjust for potential security number
> progress during the recovery process by the firmware and avoid
> potential interop issues in encrypted networks.
> 
> Signed-off-by: Oz Krakowski <ozk@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v1->2: fixed a bug where a wrap-around in the security seq LSB was
> compensated incorrectly. We used 0xff (255) instead of 256.

I had mistakenly applied v1 of this series.  Now I've undone it and
applied this v2 instead.  Thanks Arik for pointing out!

-- 
Cheers,
Luca.

