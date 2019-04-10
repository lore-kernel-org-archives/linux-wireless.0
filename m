Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73175C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B76C20820
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbfDJNfa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:35:30 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:56987 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfDJNfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 09:35:30 -0400
X-Greylist: delayed 1378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2019 09:35:29 EDT
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.91)
        (envelope-from <daniel@makrotopia.org>)
        id 1hED1d-0000pq-Lb; Wed, 10 Apr 2019 15:12:27 +0200
Date:   Wed, 10 Apr 2019 15:12:17 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH 15/21] rt2x00: rt2800lib: hardcode txmixer gain values to
 zero for RT3883
Message-ID: <20190410131216.GA1295@makrotopia.org>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
 <1554809828-13500-16-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJtwmpEK2a5br2YEKPsAF0GHXwny5YbCTFoO_mgD+fVJw@mail.gmail.com>
 <20190410082241.GA2538@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410082241.GA2538@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 10, 2019 at 10:22:42AM +0200, Stanislaw Gruszka wrote:
> On Tue, Apr 09, 2019 at 05:26:46PM +0200, Tom Psyborg wrote:
> > On 09/04/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > > From: Gabor Juhos <juhosg@openwrt.org>
> > >
> > > Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > index 0687bef990e1..4ea94c62d439 100644
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > @@ -9128,7 +9128,8 @@ static u8 rt2800_get_txmixer_gain_24g(struct
> > > rt2x00_dev *rt2x00dev)
> > >  {
> > >  	u16 word;
> > >
> > > -	if (rt2x00_rt(rt2x00dev, RT3593))
> > > +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> > > +	    rt2x00_rt(rt2x00dev, RT3883))
> > >  		return 0;
> > >
> > >  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG);
> > > @@ -9142,7 +9143,8 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev
> > > *rt2x00dev)
> > >  {
> > >  	u16 word;
> > >
> > > -	if (rt2x00_rt(rt2x00dev, RT3593))
> > > +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> > > +	    rt2x00_rt(rt2x00dev, RT3883))
> > >  		return 0;
> > >
> > >  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A);
> > > --
> > > 2.7.5
> > >
> > >
> > 
> > Did someone actually verified this is correct?
> 
> I don't know if it was verified or not.

Gabor supposedly verified this when he wrote that patch 6 years ago,
it was reviewed and merged by John Crispin back then:

commit 6e3de004f9cf6724b1ad950e7cb3b98f1b4af54d
Author: John Crispin <blogic@openwrt.org>
Date:   Wed Apr 23 07:52:18 2014 +0000

    mac80211: rt2x00: add support for the RT3662/RT3883 SoCs
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    
    git-svn-id: svn://svn.openwrt.org/openwrt/trunk@40558 3c298f89-4303-0410-b956-a3cf2f4a3e73

Since when we carry it in OpenWrt and supposedly everyone with Rt3xx3
WiSoC devices is using it and there haven't been any complains so far.


Cheers


Daniel

> 
> Stanislaw
