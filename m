Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0297BC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C46C820881
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C46C820881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJPTOa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 15:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbeJPTOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 15:14:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17E64C05D40B;
        Tue, 16 Oct 2018 11:24:32 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DFA45D9C8;
        Tue, 16 Oct 2018 11:24:31 +0000 (UTC)
Date:   Tue, 16 Oct 2018 13:21:03 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181016112102.GC2621@redhat.com>
References: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com>
 <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
 <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
 <e18b2f17-9403-f17a-babb-c4f56dedd2ca@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e18b2f17-9403-f17a-babb-c4f56dedd2ca@nbd.name>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 16 Oct 2018 11:24:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 16, 2018 at 01:19:52PM +0200, Felix Fietkau wrote:
> > I have no idea how this could be related. But I think I found
> > somewhat reasonable explenation where the problem is.
> > I think below code :
> > 
> > 	if (a || b || c) {
> > 		CODE1();
> > 	} else if (c) {
> > 		CODE2();
> > 	}
> > 
> > can not be deterministic and can be compiled differently depending
> > on compiler version and used options. Sometimes it could result
> > in this 
> > 
> > 	if (a || b || c) {
> > 		CODE1();
> > 	}
> > 
> > and sometimes in this:
> > 
> > 	if (a || b) {
> > 		CODE1();
> > 	} else if (c) {
> > 		CODE2();
> > 	}
> > 
> > So that would explain the problems you see. And indeed patch
> > could cause regression on systems where second variant of
> > initalizing RT6352 registers was used.
> I don't see how that can be non-deterministic at all. The 'else if' part
> can only be hit if the first if did not match.

I meant non-deterministic during compilation process, when compiler
do or do not some optimizations or if compiler version differs.

Regards
Stanislaw
