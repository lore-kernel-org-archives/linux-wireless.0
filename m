Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9BBC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27873206B6
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfDJIWp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 04:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbfDJIWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 04:22:44 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C9CBC0587C3;
        Wed, 10 Apr 2019 08:22:44 +0000 (UTC)
Received: from localhost (unknown [10.40.205.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76357600D4;
        Wed, 10 Apr 2019 08:22:43 +0000 (UTC)
Date:   Wed, 10 Apr 2019 10:22:42 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH 15/21] rt2x00: rt2800lib: hardcode txmixer gain values to
 zero for RT3883
Message-ID: <20190410082241.GA2538@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
 <1554809828-13500-16-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJtwmpEK2a5br2YEKPsAF0GHXwny5YbCTFoO_mgD+fVJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJtwmpEK2a5br2YEKPsAF0GHXwny5YbCTFoO_mgD+fVJw@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 10 Apr 2019 08:22:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 09, 2019 at 05:26:46PM +0200, Tom Psyborg wrote:
> On 09/04/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > From: Gabor Juhos <juhosg@openwrt.org>
> >
> > Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index 0687bef990e1..4ea94c62d439 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -9128,7 +9128,8 @@ static u8 rt2800_get_txmixer_gain_24g(struct
> > rt2x00_dev *rt2x00dev)
> >  {
> >  	u16 word;
> >
> > -	if (rt2x00_rt(rt2x00dev, RT3593))
> > +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> > +	    rt2x00_rt(rt2x00dev, RT3883))
> >  		return 0;
> >
> >  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG);
> > @@ -9142,7 +9143,8 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev
> > *rt2x00dev)
> >  {
> >  	u16 word;
> >
> > -	if (rt2x00_rt(rt2x00dev, RT3593))
> > +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> > +	    rt2x00_rt(rt2x00dev, RT3883))
> >  		return 0;
> >
> >  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A);
> > --
> > 2.7.5
> >
> >
> 
> Did someone actually verified this is correct?

I don't know if it was verified or not.

Stanislaw
