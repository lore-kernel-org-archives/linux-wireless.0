Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34559 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbFZMXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 08:23:21 -0400
Received: by iebmu5 with SMTP id mu5so74165057ieb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 05:23:20 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 26 Jun 2015 17:53:01 +0530
Message-ID: <CABPxzYKOX1SdboUQfJZRO3ar_74H_mz1tM+CQwJuSQwp6O3Mkg@mail.gmail.com> (sfid-20150626_142331_545819_C6310665)
Subject: Rate Control for TDLS Channel Switching for Same STA in 2 bands.
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a question with regards to minstrel when working with multi
channel concurrency
cases especially TDLS case, where we communicate with the same STA in
2 different bands
so we need to update the capbility per band.

minstrel_update_ht_caps takes sband as an argument but only to
calculate ack duration and overhead. Ideally we need to update below
params at the least "per band" during rate_control_update.

a) Suported Rates (to diable DSSS rates in 5GHz)
b) MCS  (To disable VHT in 2.4GHz)
c) BW ( as per peer params)

Any plans to support this? Currently i only see TDLS Channel Switching
as the use ase for
communicating with the same STA in different bands almost
concurrently. (Time Sliced way).

-- 
Thanks,
Regards,
Chaitanya T K.
