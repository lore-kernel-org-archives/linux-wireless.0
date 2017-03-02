Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35847 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbdCBB2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 20:28:43 -0500
Received: by mail-qk0-f173.google.com with SMTP id n186so98178505qkb.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 17:28:42 -0800 (PST)
MIME-Version: 1.0
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Thu, 2 Mar 2017 09:28:40 +0800
Message-ID: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com> (sfid-20170302_023009_613398_38732B90)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Instead of stopping path discovery when a path is found continue
> attempting to find paths until we hit the dot11MeshHWMPmaxPREQretries
> limit.

I am not too sure whether by simply broadcasting the PREQ frame could
actually solve the problem and this may cause problem of PREQ flooding
in your network when the number of nodes scale. Please take note that
all nodes need to rebroadcast the PREQ frame until target STA. Path
discovery should stop once the path is established. By attempting 2nd,
3rd or 4th doesn't guarantee the next path will be "good".

> This is important because path messages are not reliable and it is
> relatively common to have a short bad path to the destination along with a
> longer but better path. With the original code rather often a path message
> along the long path would be lost so we would stick with the bad path.
> With this change we have a greater chance to get messages over the longer
> path allowing us to select the long path if it's better.

Reduce the mesh_hwmp_active_path_timeout or mesh_path_refresh_time to
reestablish your path link as soon as possible. Also, if you would
like to have such aggressive behavior, you can reduce the
mesh_hwmp_preq_min_interval to have more aggressive PREQ sending in
your network.

----
Chun-Yeow
