Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58630 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934856AbdAKICV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 03:02:21 -0500
Message-ID: <1484121737.23671.0.camel@sipsolutions.net> (sfid-20170111_090242_732361_8D06CDFA)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
Date: Wed, 11 Jan 2017 09:02:17 +0100
In-Reply-To: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com> (sfid-20170111_003605_347505_85ADC15C)
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         (sfid-20170111_003605_347505_85ADC15C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 08:35 +0900, Masashi Honma wrote:
> I have encountered kernel crash when I have used mesh SAE
> connection  
> with ath9k_htc device (Sony UWA-BR100). I have tried to connect 2
> peers  
> to each other, then only one peer crashes.
> 
> By bisect, this commit looks causes this issue.
> 
> commit d8da0b5d64d58f7775a94bcf12dda50f13a76f22
> Author: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
> Date:   Wed Dec 7 09:59:00 2016 +0000
> 
>      mac80211: Ensure enough headroom when forwarding mesh pkt

I don't think this makes sense - if you only have two peers then you
shouldn't even run into forwarding code paths?

johannes
