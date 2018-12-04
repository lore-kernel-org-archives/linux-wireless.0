Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74E0C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 10:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E25020878
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 10:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E25020878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbeLDKRD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbeLDKRC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 05:17:02 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9759A811D8;
        Tue,  4 Dec 2018 10:17:01 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22EF95C21C;
        Tue,  4 Dec 2018 10:17:00 +0000 (UTC)
Date:   Tue, 4 Dec 2018 11:16:59 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2800 tx frame dropping issue.
Message-ID: <20181204101658.GA14692@redhat.com>
References: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com>
 <3e8017792ea5eaa63f7795d9d37e7dcf85cdc612.camel@sipsolutions.net>
 <20181126093826.GB2047@redhat.com>
 <b23f23bb-c543-bf9c-2827-618841a9b708@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b23f23bb-c543-bf9c-2827-618841a9b708@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 04 Dec 2018 10:17:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Daniel

On Mon, Dec 03, 2018 at 03:44:46PM -0600, Daniel Santos wrote:
> I almost managed to get that patch in a build to send to somebody who
> can reproduce the error in abundance, but they have 15 different people
> hammer the router to do it and we ended up sending them a few other
> experimental builds instead.
> 
> I'm still learning this driver, but I don't see where it creates a
> struct net_device -- was that something that came out after the driver
> was originally written? (And maybe gets implicitly created somewhere
> else?)  

It is done in ieee80211_if_add(), one netdev per vif.

> iiuc, the best way to do this is by setting tx_queue_len while
> the interface is down (via "ip link") and then allocating the queue when
> it's brought up.

We have diffrent queues at various levels in the network stack.
The queues size I plan to increase are referenced as HW queues

> Unless you know of a problem with this approach, I'm planning on making
> a patch just for that.  It will then be easier to tune for an end user's
> particular application. 

I don't think it's correct approch. Maybe module parameter will be
better just for testing. But since this is for routers/APs just
making build with diffrent tx queues size seems to be better
approach.

> For instance, if there is a small number of
> uses who just use a very large amount of bandwidth then buffer bloat
> could become a problem if it's too high.  But for a larger number of
> users I don't think the buffer bloat probably will matter as much as
> lost performance from dropping frames and needing to re-request many
> lost packets at the TCP layer.  This would also result in more uplink
> bandwidth being consumed.

Well, I guess that correct, but I still wish to see if increase queues
size do not cause big negative effect.

Thanks
Stanislaw
