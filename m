Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54116C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 02:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D6220870
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 02:21:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D6220870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lang.hm
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbeKTMru (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 07:47:50 -0500
Received: from h-66-167-227-145.lsan.ca.dynamic.globalcapacity.com ([66.167.227.145]:43220
        "EHLO mail.lang.hm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725992AbeKTMru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 07:47:50 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2018 07:47:50 EST
Received: from dlang-laptop.LAN (dlang-laptop.LAN [10.2.0.162])
        by mail.lang.hm (Postfix) with ESMTP id 35BC1410F2;
        Mon, 19 Nov 2018 18:12:29 -0800 (PST)
Date:   Mon, 19 Nov 2018 18:12:29 -0800 (PST)
From:   David Lang <david@lang.hm>
X-X-Sender: dlang@dlang-laptop
To:     Dave Taht <dave.taht@gmail.com>
cc:     Ben Greear <greearb@candelatech.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
In-Reply-To: <CAA93jw55KywLAMEo=hHcqGdB1-qV3-3CCQe+T6GMNZwR6kRhJw@mail.gmail.com>
Message-ID: <nycvar.QRO.7.76.6.1811191811080.7093@qynat-yncgbc>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk> <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
 <87sh02tfsp.fsf@toke.dk> <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk> <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net> <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com> <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com>
 <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com> <6beaeb84-b705-335b-93a7-36176495099b@candelatech.com> <CAA93jw55KywLAMEo=hHcqGdB1-qV3-3CCQe+T6GMNZwR6kRhJw@mail.gmail.com>
User-Agent: Alpine 2.21.1 (DEB 209 2017-03-23)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 19 Nov 2018, Dave Taht wrote:

>> I'm not sure if this was a fluke or not, but at Starbucks recently I sat outside,
>> right next to their window, and could not scan their AP at all.  Previously, I sat
>> inside, 3 feet away through the glass, and got great signal.  I wonder what that was
>> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of some sort.
>
> Ya know, I could definitely see a market for a material like that! I'd
> like it for my car, so bluetooth wouldn't escape.

That would break your tire pressure sensors (each car is rolling around 
broadcasting 4 unique bluetooth IDs, not hard to track)

David Lang
