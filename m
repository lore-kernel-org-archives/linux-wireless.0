Return-Path: <SRS0=v3Rz=VA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0803C46478
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 10:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16D3218A0
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 10:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfGCKnp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jul 2019 06:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfGCKno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jul 2019 06:43:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27CBA780F1;
        Wed,  3 Jul 2019 10:43:44 +0000 (UTC)
Received: from localhost (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF57717C47;
        Wed,  3 Jul 2019 10:43:43 +0000 (UTC)
Date:   Wed, 3 Jul 2019 12:43:42 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Andrej Surkov <surae@yandex.ru>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: rtl8xxxu do not see/connect any wifi network until suspend/resume
Message-ID: <20190703104341.GA30509@redhat.com>
References: <26092471561990977@myt3-2475c4d2af83.qloud-c.yandex.net>
 <42140711561991116@myt2-dc4bba9bb23c.qloud-c.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42140711561991116@myt2-dc4bba9bb23c.qloud-c.yandex.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 03 Jul 2019 10:43:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jul 01, 2019 at 07:25:16PM +0500, Andrej Surkov wrote:
> Hi!
> 
> Do you aware of rtl8xxxu do not work until suspend/resume issue?
> 
> On my laptop, see below for details, after reboot wifi-menu tool shows one single wifi network found and can't connect to it, but after 'sudo systemctl suspend' and resume by keystroke wifi-menu and connections work well.

This sound like this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=202541
Which happen to be xhci_hcd regression, not yet fixed AFAIK.

Stanislaw
