Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA3C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B655D20863
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfDHTwf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 15:52:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33602 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfDHTwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 15:52:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDaJl-0006jb-2w; Mon, 08 Apr 2019 21:52:33 +0200
Message-ID: <211816ff03cf188d834a21b1fbc98b4f8c5b81f4.camel@sipsolutions.net>
Subject: Re: Flag for detecting 802.11r Fast BSS Transition support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>,
        Matthew Wang <matthewmwang@google.com>
Cc:     linux-wireless@vger.kernel.org,
        Kirtika Ruchandani <kirtika@google.com>
Date:   Mon, 08 Apr 2019 21:52:30 +0200
In-Reply-To: <20190403210200.GA93453@google.com> (sfid-20190403_230207_629987_2069AD98)
References: <CAAooHFeLWrY_wmCp-HWqygh8gnKsfpoPCky7SykOBKZgXkb8OQ@mail.gmail.com>
         <20190403210200.GA93453@google.com> (sfid-20190403_230207_629987_2069AD98)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-03 at 14:02 -0700, Brian Norris wrote:
> + Johannes
> 
> On Thu, Oct 04, 2018 at 12:06:50PM -0700, Matthew Wang wrote:
> > Hi,
> > 
> > I'm wondering if there is a flag for detecting firmware/driver support
> > for FT. It seems like checking for SME support is a pretty good proxy
> > for this, but there is a non-mac80211 driver that can do FT as well
> > (ath/wil6210). It would be great if anyone knows of a feature flag
> > specifically for FT.
> 
> I chatted with Johannes, and he agreed that there was no such flag
> today. It also sounded like he was open to adding one, even if it's
> several years too late. I don't think there's any useful way people
> could (generically) use FT support today.

I guess I'm not really sure if the flag is needed, but I guess like the
original question says, it'd be more about non-mac80211 drivers.

So I guess you'd have to figure out what operations the drivers need to
support then? I'm not even sure how wpa_s would handle this for SME
offload devices.

johannes

