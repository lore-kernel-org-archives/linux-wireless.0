Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387C6C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07BE920835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07BE920835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbeJCPKg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbeJCPKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:10:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E45647F6BB;
        Wed,  3 Oct 2018 08:23:15 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3358C620C4;
        Wed,  3 Oct 2018 08:23:11 +0000 (UTC)
Date:   Wed, 3 Oct 2018 10:23:10 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: new mt76 usb crashes on device removal
Message-ID: <20181003082309.GB2229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 03 Oct 2018 08:23:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After

b11e19694dc9 "mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature"

I have new crashs when remove mt76x0u and mt76x2u devices. 
I can not provide calltrace because some other warning/traces
show up instantly after the problem happen and mask prints
for initall problem. Then the machine hungs.

Anyway bisection blame b11e19694dc9 commit and I confirm that problem
not happen before this commit. I also applied the fix with I just
posted, so this is diffrent issue.

Thanks
Stanislaw 
