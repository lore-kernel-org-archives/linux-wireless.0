Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6C9C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 07:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A22217D7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 07:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfDEHkC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 03:40:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54584 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfDEHkC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 03:40:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hCIyi-0003BK-SF; Fri, 05 Apr 2019 09:09:33 +0200
Message-ID: <282a621c0a0cc86787901d8ce96068b2ca680d0a.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] stricter netlink validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Date:   Fri, 05 Apr 2019 09:09:32 +0200
In-Reply-To: <db599b6b-94a5-3123-5613-9e349fcee702@cumulusnetworks.com> (sfid-20190405_044429_517897_85795668)
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404.102850.631122626573856353.davem@davemloft.net>
         <db599b6b-94a5-3123-5613-9e349fcee702@cumulusnetworks.com>
         (sfid-20190405_044429_517897_85795668)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-04 at 20:44 -0600, David Ahern wrote:
> Hit a compile issue right out of the gate:
> 
> $ make O=kbuild/perf -j 24 -s
> /home/dsa/kernel-2.git/net/openvswitch/flow_netlink.c: In function
> ‘validate_and_copy_check_pkt_len’:
> /home/dsa/kernel-2.git/net/openvswitch/flow_netlink.c:2887:8: error:
> implicit declaration of function ‘nla_parse_deprecated_strict’
> [-Werror=implicit-function-declaration]
>   err = nla_parse_deprecated_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX,
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> You should do an allmodconfig build to check for any others. I disabled
> ovs to continue.

Ugh, yes. The one change I made because I rebased on the latest net-next 
after the build testing ...

Sorry about that, I'll fix it in v2 after more reviews.

johannes

