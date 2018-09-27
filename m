Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C470AC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 617B921546
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:41:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 617B921546
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbeI0P6i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbeI0P6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:58:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D6A93086249;
        Thu, 27 Sep 2018 09:41:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBAE18684;
        Thu, 27 Sep 2018 09:41:10 +0000 (UTC)
Date:   Thu, 27 Sep 2018 11:41:08 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/4] mt76x0: print BBP version only for debug
Message-ID: <20180927094108.GB20538@redhat.com>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
 <1538037450-18949-2-git-send-email-sgruszka@redhat.com>
 <20180927092629.GA2489@localhost.localdomain>
 <CAJ0CqmUNDLG_FCwVzEhUWr11OhqH-wxHqL97c2gY8PkTyDNXBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmUNDLG_FCwVzEhUWr11OhqH-wxHqL97c2gY8PkTyDNXBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 27 Sep 2018 09:41:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:34:39AM +0200, Lorenzo Bianconi wrote:
> Please drop the comment, it is a different register. Maybe we can
Too late :-)

> generalize mt76x02_wait_for_mac instead?

Seems BBP(CORE,0) is not used by mt76x2, so merging it into mt76x02
is not correct.

Thanks
Stanislaw
