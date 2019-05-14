Return-Path: <SRS0=H9Fc=TO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2461CC04AB4
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9EFF2086A
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 15:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfENPoH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 May 2019 11:44:07 -0400
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:42410 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726296AbfENPoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 May 2019 11:44:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 69906182CF668;
        Tue, 14 May 2019 15:44:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: note02_5d98fc2c7d635
X-Filterd-Recvd-Size: 2261
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 14 May 2019 15:44:03 +0000 (UTC)
Message-ID: <34f72d5db336b9898618bf1c5c15ec41094d7d06.camel@perches.com>
Subject: Re: [PATCH v2] mac80211: remove warning message
From:   Joe Perches <joe@perches.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Yibo Zhao <yiboz@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Zhi Chen <zhichen@codeaurora.org>
Date:   Tue, 14 May 2019 08:44:01 -0700
In-Reply-To: <e2a6596b99085541a5886c0d0d6393c849ac2d57.camel@sipsolutions.net>
References: <1557824507-17668-1-git-send-email-yiboz@codeaurora.org>
         (sfid-20190514_110314_752671_7E53E9A2) <7c92f5cf51eaec1d5449698d90f5b6c5ca6c2bea.camel@sipsolutions.net>
         <ccb48284f0d96e72f4c041e12c943f0a@codeaurora.org>
         <e2a6596b99085541a5886c0d0d6393c849ac2d57.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-05-14 at 11:12 +0200, Johannes Berg wrote:
> On Tue, 2019-05-14 at 17:10 +0800, Yibo Zhao wrote:
> > On 2019-05-14 17:05, Johannes Berg wrote:
> > > On Tue, 2019-05-14 at 17:01 +0800, Yibo Zhao wrote:
> > > > In multiple SSID cases, it takes time to prepare every AP interface
> > > > to be ready in initializing phase. If a sta already knows everything 
> > > > it
> > > > needs to join one of the APs and sends authentication to the AP which
> > > > is not fully prepared at this point of time, AP's channel context
> > > > could be NULL. As a result, warning message occurs.
[]
> > I was planning to use WARN_ON_ONCE() in the first place to replace 
> > WARN_ON() then after some discussion, we think removing it could be 
> > better. So the first patch was based on my first version which is sent 
> > incorrectly. Please check again.
[]
> I guess changing it to WARN_ON_ONCE() makes sense,

WARN_ON_RATELIMIT exists.

> but as per my earlier
> email I'm really not sure about removing it entirely, it doesn't seem
> like a valid scenario and we should take steps elsewhere to prevent it.



