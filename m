Return-Path: <SRS0=0RXE=64=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459EAC433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 May 2020 16:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5272065D
	for <linux-wireless@archiver.kernel.org>; Thu, 14 May 2020 16:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="FSEGSII2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgENQdi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 May 2020 12:33:38 -0400
Received: from mx4.wp.pl ([212.77.101.11]:56595 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgENQdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 May 2020 12:33:38 -0400
Received: (wp-smtpd smtp.wp.pl 3044 invoked from network); 14 May 2020 18:33:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1589474015; bh=bmVlvxRJfbuLi0qWPTmVd+J6tpfP5mcBYa4T+w6Y+8U=;
          h=From:To:Cc:Subject;
          b=FSEGSII21NTu3LcDu5gOBnyldd9XcVfZzPYtGBHnLq4KGH4ETLjb4h9etIzCH9PPQ
           Fp2HGfy9VPZZkCbQOv/Sxp6v1PvuLdA4LoliUer6Sc4N4S8Izwcy3/fRunHjjLVmwI
           M1A75FlFZ1yEYyN8OAlyA/jwva961MITdjVMX+MY=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.4])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <kvalo@codeaurora.org>; 14 May 2020 18:33:34 +0200
Date:   Thu, 14 May 2020 09:33:26 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] mt76: fix different licenses in same driver
Message-ID: <20200514093326.49b995ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87pnb7go2m.fsf@tynnyri.adurom.net>
References: <3a5cb822eb4cd81d32b5480f1235c992ea4fbe06.1587193872.git.ryder.lee@mediatek.com>
        <d32134a6-9673-521f-22ee-871aa2284af0@nbd.name>
        <20200507100246.1e902bc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87pnb7go2m.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 87b73c8c2619fcfba521105177ea5514
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [ESLT]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 14 May 2020 07:03:45 +0300 Kalle Valo wrote:
> Jakub Kicinski <kubakici@wp.pl> writes:
> > On Thu, 7 May 2020 15:30:24 +0200 Felix Fietkau wrote:  
> >> Hi Ryder,
> >> 
> >> I think for this patch we need an explicit ACK from Stanislaw Gruszka
> >> and Jakub Kicinski (both Cc'd), because mt76x0 was licensed under GPL.  
> >
> > Thanks, yes, you definitely need an ack, especially from folks who have
> > their copyright on the files :/
> >
> > My personal preference for the license was expressed clearly when the
> > code was written and it is GPL-only. Felix, if you prefer the clean up
> > I'm happy to ack, but I see no reason to downgrade the license at
> > vendor's request.  
> 
> I think it would be unfortunate to have different licenses in the same
> driver. For example think of copying a function from one file to
> another, how would we handle that? So my strong recommendation is to use
> the same license throughout the driver. And in this case I consider mt76
> directory and it's subdirectories as being one driver, please correct me
> if that's not the case.

AFAIU some parts of the code were brought in from mt7601u which has 
a different license. As I said I'm happy with it if Felix feels like
it's needed. Just not a fan of vendors who barely contribute making
license changes.
