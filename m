Return-Path: <SRS0=eag0=5R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DA8C43331
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 17:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4DC20719
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 17:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbgDARyC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Apr 2020 13:54:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46340 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgDARyC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Apr 2020 13:54:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jJhYt-00CpUg-QA; Wed, 01 Apr 2020 19:53:59 +0200
Message-ID: <693acec3b0c76583e82579e7cc95a22274c3b1da.camel@sipsolutions.net>
Subject: Re: [RFC 3/7] mac80211: handle channel frequency offset
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Wed, 01 Apr 2020 19:53:58 +0200
In-Reply-To: <7b3b34dd-882a-73e7-f857-8e581c3f7bc0@adapt-ip.com>
References: <20200401062150.3324-1-thomas@adapt-ip.com>
         <20200401062150.3324-4-thomas@adapt-ip.com>
         <7fc6331597f53f5d100f3aa7e29434c20cf6fe90.camel@sipsolutions.net>
         <7b3b34dd-882a-73e7-f857-8e581c3f7bc0@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-04-01 at 10:39 -0700, Thomas Pedersen wrote:
> On 3/31/20 11:59 PM, Johannes Berg wrote:
> > On Tue, 2020-03-31 at 23:21 -0700, Thomas Pedersen wrote:
> > > ie. ignore
> > > for mesh, ibss, HT/VHT specific stuff, TDLS, etc.
> > 
> > This makes sense, but I don't see that you prevent using mesh, ibss and
> > perhaps TDLS on s1g channels?
> > 
> > Or do we not expect drivers/devices that support this, as well as S1G
> > channels?
> 
> Well it's really orthogonal to S1G (maybe a new 2412.5Mhz channel opens
> up :)). We should probably return an error 'if (chan->freq_offset)' or
> so for features which have not yet been tested / implemented for
> frequency offset.

OK, fair enough.

johannes

