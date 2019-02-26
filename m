Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23AFC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 997AD217F9
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfBZNO3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:14:29 -0500
Received: from mout.gmx.net ([212.227.17.21]:41651 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfBZNO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:14:29 -0500
Received: from w210-65-v4.eduroam.dynamic.rbg.tum.de ([131.159.210.221]) by
 mail.gmx.com (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LosFD-1hW0AE06xv-00grRY; Tue, 26 Feb 2019 14:13:53 +0100
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of tx_status
 frames
From:   Julius Niedworok <julius.n@gmx.net>
In-Reply-To: <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
Date:   Tue, 26 Feb 2019 14:13:51 +0100
Cc:     linux-wireless@vger.kernel.org, ga58taw@mytum.de,
        David Hildenbrand <david@redhat.com>, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net>
References: <20190226094104.35192-1-julius.n@gmx.net>
 <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
X-Mailer: Apple Mail (2.3273)
X-Provags-ID: V03:K1:mg5K0GZ9cYRPv3dPP2zUP29PUzaKBVyT69O9PwgbvwODOpwvGrk
 8cTgSVQdL6U6KtG5kz7nnveF9a/NGa3V9yim1vdu9BMUZR6dG3olVev0us/y0OktAO0k/D8
 nrFZZ1gdg35V3o3wc5LU5fLqRnxH8ZgEvGZhjKJmSTAWrE6QQz6WTKR4WLf8XsKoZ6SZqsw
 CsXUJ8LQMNzldebMbS+hg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gUtLO5wpRfA=:hfPUjoNpuLshzLQPpY+15c
 OsDO9m2QLRzz6CcbBfCYqm2U4daXZ9ApX3DhmumKUui+hOoS/Pc8CIH65W/8V8Kybmj8+Ryd/
 EqVjRmVhHWp9r6xf6vhIa0TrVwx/lWrLq7xTIspE+UAiUql5zg3SN2BSzOzru7w9nY5JOhwPN
 TEDjzKaOpYRjtDoslUpplJzIVhGdxY6TXqBhTnWRyBSJmeMVIuayDWi3xXZnAU2ZKJK0FaAgP
 ZDdT3SDb+OtXbS3Cclr5OCV/M75LyL71fEMp2puXe/icg/0Klh7LkjA+1wDBXkcb8kVO676NS
 Rc46Ix/N+AQSGSHH3PpqJgizd0eGZdHNvkKR05MyQu1nzNohdUB302lMDZm5RYAQqUvLhWgsm
 pWtOqEbSSy/r9xM6/+YRB2YGgLUTUskBo866p2G1kLz85F8fezhofbIe9S/fKMlji0SaTPLDU
 lxEgNHeZDPy06fuaduux9oQYCyuJ9cU4k4hKGPXZjKcbMuoA8oTugJ+D6EshxtIVX8me2jpG7
 redNIzXkRanpZjGLEuIZolVHbCv3sOn4aMVjaW2mRQ59KxosS2hF6zaYL300Pq8Ts0qAVam01
 Ej6KoNXhI++PC94UNXkYmbwWJq7J3Znb5Pil5VO4+vNIBxhmHkyCRxSFRv8AkRrpd4slyY5ar
 m2hndt+jqBrL/YAgo96TnpU1zs6WDNEE+BmgvVnRk7cCHHaZXx7ADCet4nSZsouq/ppl0EqyB
 g+9+ELX5XOzimtduA3XAWFCPFxrmHGr5eJhhxOtSbmJNdOVT+kg0Gz/IECWH10Yh3pyQewENK
 b/yhzYy0mc5Mho2uOOfpKIjm3ycKWgLLxrMBhEsxYt94KKcySmdRYbYN4TIERag5AUwavX+lS
 R38d5Xyv6Gk7P2ExthGEnhqU3K6U1HyP24ipLzuL6Iz8Gms5cCZ5500ljJI1afiT676/vvBIW
 9hpkcyHnNUw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Oliver,

> On 26.02.2019 12:04, Oliver Hartkopp wrote:
> 
> Hi Julius,
> 
(..)
> 
> The reason for IFF_ECHO was, that the data frame which is sent onto the wire (by one application) is not visible to all the other applications on the same (local) host. Therefore a successful transmission on the wire triggers the 'echo' of the sent content into the local host.
> 

Thank you for the explanation - I can adjust the comment, if you like to.

> So what are you getting back after you enabled IFF_ECHO on your mac80211 device?
> 
> Is it just a 'status' about a sent packet, or is it the packet ('full content') itself?

We are actually getting back the full content of the packet. So it matches the behaviour of the 'echo' in CAN.

> 
> Regards,
> Oliver
> 


Many thanks,
Julius
