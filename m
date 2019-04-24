Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47290C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 07:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FCD92148D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 07:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfDXHzO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 03:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbfDXHzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 03:55:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33AE6C0AF7B5;
        Wed, 24 Apr 2019 07:55:14 +0000 (UTC)
Received: from localhost (unknown [10.40.205.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE355272AA;
        Wed, 24 Apr 2019 07:55:13 +0000 (UTC)
Date:   Wed, 24 Apr 2019 09:55:11 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kevan Salva <kenico15@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Kali Linux 4.19.13 VM, Ralink RT3072 - Not Finding Wireless
 Networks
Message-ID: <20190424075510.GA23645@redhat.com>
References: <CAAM6Ncf0=1wBbnomxH=o8r9-edhSk2zr_xzhJeA1uWdzRZ84Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAM6Ncf0=1wBbnomxH=o8r9-edhSk2zr_xzhJeA1uWdzRZ84Eg@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 24 Apr 2019 07:55:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 17, 2019 at 08:57:30PM -0500, Kevan Salva wrote:
> Hello All,
> 
> I am running Kali Linux (4.19.13) in a VM. I have a USB network
> adapter - a Ralink RT3072, passed through to the VM. However, it is
> not finding any wireless networks. This issue occurs on both VMware
> and on Virtualbox, but not on a live install of the same OS. This is
> the output I get from dmesg: pastebin.com/HaXUDNug . What may be the
> issue here?

Logs show we can not communicate with the device via USB bus. This is
problem in usb host driver or VM pass trough code or those two
combined. Eventually your motherboard firmware/BIOS issue.

Stanislaw
