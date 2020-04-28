Return-Path: <SRS0=qsgd=6M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F51C83007
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 07:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80014206B9
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 07:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD1HYW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 Apr 2020 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgD1HYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Apr 2020 03:24:22 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Apr 2020 00:24:21 PDT
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB7C03C1A9;
        Tue, 28 Apr 2020 00:24:21 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTKbK-000u7A-97; Tue, 28 Apr 2020 09:24:18 +0200
Message-ID: <baae77876a4b73de83aa6dcc27257da231777c22.camel@sipsolutions.net>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <geomatsi@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Apr 2020 09:24:16 +0200
In-Reply-To: <20200428072543.GA2630@curiosity> (sfid-20200428_092118_600638_E26BE357)
References: <20200428122930.51b6a9c2@canb.auug.org.au>
         <c3922c972277ff627c0308a94dfe3f25ba3b333f.camel@sipsolutions.net>
         <20200428072543.GA2630@curiosity> (sfid-20200428_092118_600638_E26BE357)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-04-28 at 10:25 +0300, Sergey Matyukevich wrote:
> On Tue, Apr 28, 2020 at 09:01:30AM +0200, Johannes Berg wrote:
> > On Tue, 2020-04-28 at 12:29 +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > After merging the mac80211-next tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > Caused by commit
> > > 
> > >   6cd536fe62ef ("cfg80211: change internal management frame registration API")
> > 
> > Yeah. I forgot about staging. I guess I'll throw in a quick fix.
> > 
> > johannes
> 
> Hello Johannes,
> 
> Could you please take a look at the following fix for this issue:
> https://patchwork.kernel.org/patch/11509497/

Heh. I was just fixing it too, missed your patch. How do you like this
fix?

https://p.sipsolutions.net/0638ee56c2e48a30.txt

johannes

