Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36243 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdIAGal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 02:30:41 -0400
Received: by mail-io0-f176.google.com with SMTP id f99so11177035ioi.3
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 23:30:40 -0700 (PDT)
MIME-Version: 1.0
From: Greg Maitz <ghh19622@gmail.com>
Date: Fri, 1 Sep 2017 16:30:39 +1000
Message-ID: <CAG5S3ZTRe52qSWt6WEe6K78brrQqc7+HgN_8OQ+RKC9k1WUMCw@mail.gmail.com> (sfid-20170901_083044_721159_DEE21C23)
Subject: Incorrect mesh path seq num
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

I'm seeing a problem when I work on the wireless mesh between two
linux devices. The root node has 3.18 kernel while the next hop
station runs 2.6.37 kernel. I found the mpath->sn value is incorrect
most of the time on the device having 2.6.37 kernel. After examining
the code, in function hwmp_route_info_get [mesh_hwmp.c], after
mesh_path_lookup, the sequence number (i.e, mpath->sn) is incorrect.
For instance, I see mpath->sn having value 0x30950000. It should be
0x9530, while the orig_sn is having value 0x9531. This results in the
last hop metric to become zero in function mesh_rx_path_sel_frame and
hwmp_preq_frame_process doesn't get called. Is this a known problem?
Can anyone provide suggestions to debug further?
