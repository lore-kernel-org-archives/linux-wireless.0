Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09EFC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710B32084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 710B32084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbeJDUph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 16:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727293AbeJDUph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 16:45:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC8E53002956;
        Thu,  4 Oct 2018 13:52:13 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D469104C53C;
        Thu,  4 Oct 2018 13:52:13 +0000 (UTC)
Date:   Thu, 4 Oct 2018 15:52:11 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 02/12] rtw88: core files
Message-ID: <20181004135210.GB20484@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-3-git-send-email-yhchuang@realtek.com>
 <20181004114235.GB16819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004114235.GB16819@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 04 Oct 2018 13:52:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 04, 2018 at 01:42:35PM +0200, Stanislaw Gruszka wrote:
> On Wed, Oct 03, 2018 at 04:02:18PM +0800, yhchuang@realtek.com wrote:
> > +static void rtw_restore_port_cfg(struct rtw_dev *rtwdev)
> > +{
> > +	struct rtw_vif *rtwvif;
> > +	u32 config = ~0;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list)
> list_for_each_entry_rcu
> 
> > +void rtw_lps_enter_check(struct rtw_dev *rtwdev)
> > +{
> > +	struct rtw_vif *rtwvif, *lps_if;
> > +	u8 assoc_cnt = 0;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list) {
> list_for_each_entry_rcu

Ok fixed in v3 , I just realized that I'm reviewing v2.

