Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13090C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 12:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BA22190C
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 12:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbeLUMvt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 07:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbeLUMvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 07:51:49 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB57E42BDD;
        Fri, 21 Dec 2018 12:51:48 +0000 (UTC)
Received: from localhost (ovpn-204-169.brq.redhat.com [10.40.204.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D54E5F7C1;
        Fri, 21 Dec 2018 12:51:48 +0000 (UTC)
Date:   Fri, 21 Dec 2018 13:51:47 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 1/3] rt2x00: use ratelimited variants dev_warn/dev_err
Message-ID: <20181221125146.GB30351@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <b0b97478f9b2b9b12ad7bc04a1eb0af3bad6c5f3.camel@perches.com>
 <20181221115742.GA30351@redhat.com>
 <6a9fcc58c6682166af258c58872884e6b4719ddf.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9fcc58c6682166af258c58872884e6b4719ddf.camel@perches.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 21 Dec 2018 12:51:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Dec 21, 2018 at 04:48:17AM -0800, Joe Perches wrote:
> On Fri, 2018-12-21 at 12:57 +0100, Stanislaw Gruszka wrote:
> > On Fri, Dec 21, 2018 at 03:19:31AM -0800, Joe Perches wrote:
> > > On Thu, 2018-12-20 at 16:16 +0100, Stanislaw Gruszka wrote:
> > > > As reported by Randy we can overwhelm logs on some USB error conditions.
> > > > To avoid that use dev_warn_ratelimited() and dev_err_ratelimitd().
> > > > 
> > > > Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
> > > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > > ---
> > > >  drivers/net/wireless/ralink/rt2x00/rt2x00.h | 9 +++++++--
> > > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > > []
> > > > @@ -65,14 +65,19 @@
> > > >  /* Utility printing macros
> > > >   * rt2x00_probe_err is for messages when rt2x00_dev is uninitialized
> > > >   */
> > > > +#define wiphy_err_ratelimited(wiphy, format, args...)		\
> > > > +	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
> > > > +#define wiphy_warn_ratelimited(wiphy, format, args...)		\
> > > > +	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
> > > > +
> > > 
> > > These should probably be generic in include/net/cfg80211.h
> > 
> > Since there are no other users I do not see reason for that. 
> > Those macros can be easily move, if other users would show up.
> 
> Other users won't show up if it's hidden away.

That would mean that others do not need this.

Thanks
Stanislaw
