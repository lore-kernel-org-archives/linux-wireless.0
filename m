Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A2EC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162F820835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="SAAkZkdv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 162F820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbeJCRif (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:38:35 -0400
Received: from nbd.name ([46.4.11.11]:39068 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbeJCRie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:38:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:
        In-Reply-To:From:Subject:Mime-Version:Content-Type:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=SsJy+hEKIAGBIM8lSsK4bPlCX/2+7IJBPPTbjfv+oRs=; b=SAAkZkdvPiK2DDxO66yRCiEwhi
        pljwWUr0QsuNESOtX7A2tbl3GWobBYDGb4dAfZnGFjFsEPFm4E5E7Doe3tUDSx4oqhLhWtvQ4Pemi
        7TrCaFD4nQD7mhBH1CLYub82rzb+tbEIZc8UsXy3ovUNQVoxE+N+ww/EHwHY6lSHC3+k=;
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 2/2] mt76: make frag_cache global per cpu structure
From:   Felix Fietkau <nbd@nbd.name>
X-Mailer: iPhone Mail (15C114)
In-Reply-To: <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
Date:   Wed, 3 Oct 2018 12:50:42 +0200
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <62BAC9EF-9AC9-476E-A663-6EC81A7FB079@nbd.name>
References: <1538558230-16576-1-git-send-email-sgruszka@redhat.com> <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> On 3. Oct 2018, at 11:17, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>=20
> Make mt76 frag cache similar to netdev frag cache. This should
> make frag allocation safe regarding concurrent access and also
> be more efficient since we will use pages that most likely are
> hot on particular cpu.
>=20
> And we don't need to clean up the cache up during device removal.
The problem with feeding multiple queues with buffers from the same fragment=
 cache is the fact that this re-introduces the problem of large compound pag=
es staying pinned in memory (often with only one or two fragments actually b=
eing used) far too long, leading to excessive RAM usage.
That is much more critical than the spinlock on alloc issue.
Please keep allocation the way it is now.

- Felix=

