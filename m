Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2358C4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 15:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C982720838
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 15:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfCBPUP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 10:20:15 -0500
Received: from mout.gmx.net ([212.227.17.20]:40705 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfCBPUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 10:20:15 -0500
Received: from [172.20.10.10] ([109.41.192.233]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MN604-1gtTea260G-006dSm; Sat, 02
 Mar 2019 16:19:36 +0100
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of tx_status
 frames
From:   Julius Niedworok <julius.n@gmx.net>
In-Reply-To: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
Date:   Sat, 2 Mar 2019 16:16:31 +0100
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-wireless@vger.kernel.org, ga58taw@mytum.de,
        David Hildenbrand <david@redhat.com>, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julius Niedworok <julius.n@gmx.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <40145B82-DCFB-40EC-88BD-BA71DA0CB86F@gmx.net>
References: <20190226094104.35192-1-julius.n@gmx.net>
 <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
 <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net>
 <550ff2ac45c891a3fcf3dd8a454f9732d8aa1b70.camel@sipsolutions.net>
 <AD1F7A49-B3F3-4033-8B0A-D1F8C2C6C834@gmx.net>
 <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3273)
X-Provags-ID: V03:K1:uvBS+FCYy3/TxNih5zDkX4IT5EdF3cUDYEoQ+WF0IpIGQaBIttw
 uB86/5I7lEWUVwKEiP+kTPbkF/wSZuFrBgAyeGtR/M3GYX8aU5Khf30/H0PkY8MOajiLaD5
 j04TiiLM4GqDd691m7YiJa8ME9HoA9kjUrnJQ101nOe7rw4y0pEtBdqHprTqMJtaPSkF0OS
 2yvYpm5chTcPjAS7pne2A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zvvrViX01ks=:j8kY6961BlzU/lZ0Sl+dwL
 yiVaxRwWtlY0y7goM5gvk+lcLsDf/GhHa+Fem6H8omFuzugTCcLi+rfseZU2u5pnHlKuJcN3V
 ayxTlza0DZ4/Tipde+sAPkaECCrj1AoCYGXgzdR+iEORsb0a1YG7Y6UNg7wYc/kNE9ZiRBRoL
 l/TgnyB5JOecdf0a7kHuhkPtyB1vJ4/ypQRa4dH2GQFAxWSLCXqE+Com6NMLGofIY1GJkvvIR
 1Mv0Hc7p6V23Xv2ReavfnHn2wmkcernRuJGvRBG4w0K1CFyrCATa2Bwuqo5gtDa3nN1p4ne4p
 3mARTnFK10Ff9PYyRWGA8QH69djDGayVxxFUkLyjTPGclBLcBTwvIg2BDSkbpc8DybhJHeFL/
 qG7YMAIqDIHjvbL5v/oYBeIuiyuDaIQrX+E64ScGByLHCzbelbvcyrAbi3oXroFUSsMKS3HDT
 qmbJ7dWJ4Q8+wbz2wcEvR6PPF0Vlxayjt/NVemtiSsgtMPI0X+KYDKSNyeHM+Gt8/cbe7k4s9
 N65bodrvKluOF2v9L068zUziMUEu8HHZOz/vkhJxEexcVL5fzdSvI3+6p5Ui0d0iDhiWEmfW6
 G7zAodVHf5Yx/xOLBBt2ho0ivzTd3VYb+7Tx6p1vF2t+SUkfh1PXibJ8UKRt9bmgWTjpgYoAS
 wbN8v3pKHlUlQdm5A5jylsYg2KzVfYizdmDVf19PNfDOQkJDbfrj8DMIRM9coYkf01q+KmSln
 /7TeTLbYtT39KapXgbz0IO85qa4Jc85kNC+BctIv8Z9kP8qP0XbRopHF+blcRMZH+QfPHw3YR
 xeStnJOF9boYcnkRTpwohyT28xlpAmvfin0rJmdwiNDcZM3ix9O3elcnpffWNi4zLXJWHk3OZ
 /eEbQVjiuUgIIulTGjLnfEBjv/i5EIyyaL4UzeUM3+M+he0lIv08197FHdBwFO2ymhEV+j01A
 8Flk+KuzcYA==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> On 01.03.2019 09:32, Johannes Berg wrote:
> 
> Thus, I don't think this was ever intended for any cross-interface
> behaviour, even if it may be on the same physical NIC.

Now we got your point. We are sorry for the confusion - it seems we 
understood that wrong.

> Not all drivers can and do this, I believe. Some things don't work very
> well if they don't do it, but I _think_ you've just been lucky and used
> hardware that does in fact support it.

If the drivers do not adhere to the API, this is a problem of the drivers,
right? Because, how can we rely on *any* functionality of the drivers when
we assume that they do not adhere to the documented interfaces?

> Also note that for some hardware that does support this, there's
> sometimes significant overhead - not just the performance overhead of
> actually reporting the frames, but sometimes also overhead in how the
> hardware is programmed and used, and how TX status is extracted.

The default of this option will be disabled. If it is turned on manually
for debugging, the performance impact is probably acceptable.

> I suppose it could be in mac80211 (perhaps debugfs?) too. I just really
> don’t think IFF_ECHO is the right approach.

We see your point. So you think we should use debugfs to enable/disable
our functionality? If so, we are happy to see that we find a way to force
REQ_TX_STATUS to one from there.

Thank you,
Julius and Charlie

