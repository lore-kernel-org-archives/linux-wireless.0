Return-Path: <SRS0=42gb=XG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B81C5ACAE
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Sep 2019 18:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC52220863
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Sep 2019 18:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfIKS0E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Sep 2019 14:26:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfIKS0D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Sep 2019 14:26:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i87JZ-0007DN-Ac; Wed, 11 Sep 2019 20:26:01 +0200
Message-ID: <4909a428ee6fef2bf8b0e61841bc88062f534b13.camel@sipsolutions.net>
Subject: Re: [RFC 0/4] Allow live MAC address change
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 11 Sep 2019 20:25:59 +0200
In-Reply-To: <4c43ea6a74cacc61184bc5b1387fecaa40711369.camel@gmail.com> (sfid-20190911_175613_316165_C021A0FB)
References: <20190904191155.28056-1-prestwoj@gmail.com>
         (sfid-20190904_221357_305070_478BF6CA) <d776271eac8b7cd24da6dbd21fb87186b30a0e7f.camel@sipsolutions.net>
         <4c43ea6a74cacc61184bc5b1387fecaa40711369.camel@gmail.com>
         (sfid-20190911_175613_316165_C021A0FB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-09-11 at 08:54 -0700, James Prestwood wrote:
> 
> I could have made this a bit more clear. I initially did measure the
> time to a full connection, including EAPoL, but the more I timed the
> more chance there was for scheduling delays that really threw off the
> results. Not that these results weren't valid, I just would have needed
> to time many many more runs to get a decent averaged time. The method
> of timings I took just isolated things a bit better.

Sure, makes sense, and I didn't think you were doing that, I was just
wondering what exactly you did measure.

> For the three methods below I measured the time from the connection
> initiation (either powering down via RTNL, changing MAC via RTNL, or
> sending CMD_CONNECT) until we got a success callback from CMD_CONNECT,
> including changing the MAC via RTNL in those cases.

Ah, ok.

> Out of curiosity how this behavior is different than the power down +
> RTNL MAC change (the current way of doing things)? If you power down
> the device, change the MAC, then power up does that MAC get reset after
> a disconnection/failure?

No, of course not? But then you're explicitly issuing a command ("change
the MAC address") that is supposed to affect state indefinitely, vs.
issuing a command ("please connect") that isn't really meant to.

If there was one thing that we learned from wext, IMHO it was that
keeping all the state in the kernel is bad for you, and it's much better
to handle things if the state gets reset when you disconnect etc. In
most places that's what we do now and I think it has served us well, so
I'm very reluctant to mix things that need state in the kernel with
those that don't.

(You might not remember wext, but you'd have to issue a bunch of
commands in the right order, and it would keep all the state inbetween;
if you forgot to clear the BSSID after setting it, it'd be remembered
and you couldn't connect to a new AP unless you reset it, etc.)

Thanks,
johannes

