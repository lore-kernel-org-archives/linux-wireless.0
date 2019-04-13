Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB5DC282CE
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E23AA20869
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfDMHzz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 03:55:55 -0400
Received: from d.mail.sonic.net ([64.142.111.50]:56832 "EHLO d.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfDMHzz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 03:55:55 -0400
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3D7tVFW023491
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 13 Apr 2019 00:55:31 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <20190413073505.GD24451@nataraja>
Date:   Sat, 13 Apr 2019 00:55:29 -0700
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        openbsc@lists.osmocom.org, radiotap@netbsd.org,
        linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Transfer-Encoding: 8BIT
Message-Id: <3658DF8E-535E-43C6-95FD-CE61E3A7164F@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <20190410233213.GN25552@nataraja>
 <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
 <20190413073505.GD24451@nataraja>
To:     Harald Welte <laforge@gnumonks.org>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVZGWq43k+7ZtePXZk9AzSgzXnz5spYe7mOU1S92xxajzzocDGyOC8OIGnl15qel0fnKkVZU8MAODx/bsHsPrnhy
X-Sonic-ID: C;ZAOTgsFd6RGuc6VsT+DgAQ== M;QLXXgsFd6RGuc6VsT+DgAQ==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 13, 2019, at 12:35 AM, Harald Welte <laforge@gnumonks.org> wrote:

> the "physical link info" is present in GSMTAP, but the granularity of
> GSMTAP frames is not user-IP frames, but "MAC blocks".  So your user IP
> frame might not be visible as it's still compressed, encrypted,
> fragmented, etc.

The granularity of Ethernet frames is not user IP frames, but Ethernet datagrams, so you user IP frame might not be visible as it's fragmented (the fragments might still be IP datagrams, but they would have to be reassembled - which Wireshark, for example, does, for those people still doing NFS-over-UDP :-)).

"Encrypted" may not apply there, but it *does* apply for 802.11 frames on a protected network (which Wireshark can decrypt, if you have 1) the network password for WEP or WPA-Personal and 2) the EAPOL handshake for WPA-Personal).
