Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:54301 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdKMWkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 17:40:08 -0500
Received: by mail-qt0-f182.google.com with SMTP id c36so15439262qtc.11
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 14:40:08 -0800 (PST)
MIME-Version: 1.0
From: Daniel Ghansah <smartwires@gmail.com>
Date: Mon, 13 Nov 2017 17:40:06 -0500
Message-ID: <CAL3ir7JHwLpNFRSv0jEED50XeFAWmSz4gXXOs0MpM=VeTGiKnQ@mail.gmail.com> (sfid-20171113_234011_843766_E9ECF45F)
Subject: PS-Poll not behaving as expected
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

       Here is the problem we experience:

When the station (wifi devices) sends a null QoS frame with power save
telling our AP that it is going into power save mode. RIght now, our
problem is that the AP will not stop sending data packets to the
station. Correct behavior is that the AP will buffer data packets and
stop sending any data or null packets (WiFi Alliance allows at most 2
of these packets to be sent by the AP before station sends ps-poll,
exclude retries) until a PS-Poll packet is sent by the station to
collect data. The AP should also respond only 1 packet per PS-Poll
(exclude any retries). Right now, we are also experiencing that the AP
will, at times, send more than 1 data packet to the station per
PS-Poll. The first and second problems may be linked together.


-- 
Regards,
Daniel
