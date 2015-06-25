Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35873 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbbFYBly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 21:41:54 -0400
Received: by wguu7 with SMTP id u7so49936196wgu.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2015 18:41:53 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Jun 2015 09:41:52 +0800
Message-ID: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com> (sfid-20150625_034210_685296_EFECC8B2)
Subject: RE: [PATCH] mac80211: mesh - always do every discovery retry
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Instead of stopping path discovery when a path is found continue
> attempting to find paths until we hit the dot11MeshHWMPmaxPREQretries
> limit.

Let think about that if you have more nodes, you will probably flood
the networks with more mgmt frame than previous implementation. It
also increases the latency for data to be sent.

> This is important because path messages are not reliable and it is
> relatively common to have a short bad path to the destination along with a
> longer but better path. With the original code rather often a path message
> along the long path would be lost so we would stick with the bad path.
> With this change we have a greater chance to get messages over the longer
> path allowing us to select the long path if it's better.

Try to take a look on the dot11MeshHWMPpreqMinInterval
(mesh_hwmp_preq_min_interval) and  (mesh_hwmp_active_path_timeout). I
think that you can probably have more aggressive path selection
interval by modifying these two values.

I don't think that flooding PREQ for resolved path not necessary a
good case for all. Thanks

----
Chun-Yeow
