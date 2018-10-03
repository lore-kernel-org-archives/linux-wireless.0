Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110CDC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 13:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68C72089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 13:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D68C72089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbeJCUoc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 16:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8837 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbeJCUoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 16:44:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E7A6308FEC7;
        Wed,  3 Oct 2018 13:56:01 +0000 (UTC)
Received: from localhost (unknown [10.40.205.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20A0517780;
        Wed,  3 Oct 2018 13:55:58 +0000 (UTC)
Date:   Wed, 3 Oct 2018 15:55:58 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
Message-ID: <20181003135557.GB16914@redhat.com>
References: <20181001221908.16005-7-lorenzo.bianconi@redhat.com>
 <20181003104334.GB2250@redhat.com>
 <CAJ0CqmWTZJ+Q_O++8DijdExwbsJEqEqxinHCe8OYocBTRTDZLw@mail.gmail.com>
 <20181003111217.GC2250@redhat.com>
 <5D5747FB-2C2E-481F-B361-2FA054E4D6E8@nbd.name>
 <20181003133205.GA16914@redhat.com>
 <4ecf9e32-cc25-714c-721b-c1b74164d781@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ecf9e32-cc25-714c-721b-c1b74164d781@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 03 Oct 2018 13:56:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 03:51:32PM +0200, Felix Fietkau wrote:
> >> > }
> >> > 
> >> > put them into mt76xN_dev and still remove dupicated code ?
> >> Quite often, mt76_dev would be needed as well for register access, which means extra parameters for a lot of functions.
> >> I think Lorenzo’s approach makes the code a lot more concise, and makes it easier to share more code between mt76x0 and mt76x2.
> > 
> > I think this could be solved very easly by container_of() macro if
> > there will be one mt76x02_dev struct just after mt76_dev.
> That's possible, yes. But given how much code can still be unified
> between mt76x0 and mt76x2, I don't think there will be much need for a
> x0 or x2 specific device struct. And in that case, the code will be more
> readable if we avoid putting a lot of unnecessary &dev->mt76x02 or
> container_of in the code.

Ok, I guess can live with mt76x02_dev :-)

Thanks
Stanislaw
