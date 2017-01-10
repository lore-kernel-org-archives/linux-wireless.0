Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34995 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757596AbdAJXfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 18:35:36 -0500
Received: by mail-pf0-f170.google.com with SMTP id f144so44961946pfa.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 15:35:36 -0800 (PST)
To: linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
Cc: johannes.berg@intel.com
From: Masashi Honma <masashi.honma@gmail.com>
Subject: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
Message-ID: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com> (sfid-20170111_003605_347505_85ADC15C)
Date: Wed, 11 Jan 2017 08:35:33 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have encountered kernel crash when I have used mesh SAE connection  
with ath9k_htc device (Sony UWA-BR100). I have tried to connect 2 peers  
to each other, then only one peer crashes.

By bisect, this commit looks causes this issue.

commit d8da0b5d64d58f7775a94bcf12dda50f13a76f22
Author: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Date:   Wed Dec 7 09:59:00 2016 +0000

     mac80211: Ensure enough headroom when forwarding mesh pkt

     When a buffer is duplicated during MESH packet forwarding,
     this patch ensures that the new buffer has enough headroom.

I do not have any crash log because the computer was fully uncontrollable.

Regards,
Masashi Honma.
