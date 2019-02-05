Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73DCC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86B1420811
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfBEPOm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 10:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbfBEPOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 10:14:42 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 985A888E52;
        Tue,  5 Feb 2019 15:14:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1359B1001F3D;
        Tue,  5 Feb 2019 15:14:41 +0000 (UTC)
Date:   Tue, 5 Feb 2019 16:10:23 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [mt76x2e] minipcie card is not working
Message-ID: <20190205151022.GE7510@redhat.com>
References: <CAKxU2N9choD2mdQd+Qwf5047VNWdwKOPB_YRXvw4i6BtLn6vxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxU2N9choD2mdQd+Qwf5047VNWdwKOPB_YRXvw4i6BtLn6vxQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 05 Feb 2019 15:14:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 12:14:49PM -0800, Rosen Penev wrote:
> I have a full height production sample mt7612e card that does not work
> in either Access Point or Client mode. Monitor mode does not work
> either (no packets received/transmitted).
> 
> dmesg shows everything to be fine:
> 
> [    5.801993] mt76x2e 0000:2b:00.0: enabling device (0000 -> 0002)
> [    5.802122] mt76x2e 0000:2b:00.0: ASIC revision: 76120044
> [    6.466527] mt76x2e 0000:2b:00.0: ROM patch build: 20141115060606a
> [    6.468999] mt76x2e 0000:2b:00.0: Firmware Version: 0.0.00
> [    6.469000] mt76x2e 0000:2b:00.0: Build: 1
> [    6.469001] mt76x2e 0000:2b:00.0: Build Time: 201507311614____
> [    6.496042] mt76x2e 0000:2b:00.0: Firmware running!
> [    6.497999] mt76x2e 0000:2b:00.0 wlp43s0: renamed from wlan0
> 
> This is on 5.0-rc3.
> 
> Tested with a desktop running Ubuntu 18.04 (custom kernel) and an
> mvebu device (Turris Omnia) running OpenWrt on kernel 4.14.

I have access to similar device and it does not work for me.

You can check latest mt76 driver https://github.com/openwrt/mt76 ,
some users reported success with mt76x2e problems, but I can
not confirm that with my device.

Do you have Mediatek driver for it (i.e. received driver on associated
CD with the device) or know about such driver. If so, does it work?

Thanks
Stanislaw
