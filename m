Return-Path: <SRS0=v049=TG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30E8C04AAA
	for <linux-wireless@archiver.kernel.org>; Mon,  6 May 2019 08:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE954205C9
	for <linux-wireless@archiver.kernel.org>; Mon,  6 May 2019 08:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfEFImL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 May 2019 04:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfEFImL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 May 2019 04:42:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80E72308FECF;
        Mon,  6 May 2019 08:42:11 +0000 (UTC)
Received: from localhost (unknown [10.43.2.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2656C19C4F;
        Mon,  6 May 2019 08:42:10 +0000 (UTC)
Date:   Mon, 6 May 2019 10:40:55 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     yhchuang@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/5] rtw88: minor fixes from suggestions during review
Message-ID: <20190506084054.GA2714@redhat.com>
References: <1556884415-23474-1-git-send-email-yhchuang@realtek.com>
 <87ftpvkal1.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftpvkal1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 06 May 2019 08:42:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, May 03, 2019 at 03:04:58PM +0300, Kalle Valo wrote:
> <yhchuang@realtek.com> writes:
> 
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > The series fix some small problems for rtw88, most of the suggestions
> > are from the review process.
> >
> >
> > v1 -> v2
> >
> >  - modify description for LPS, ", turn off" -> ", to turn off"
> >  - drop patch "rtw88: mac: remove dangerous while (1)",
> >    should re-write the power sequence parsing code to make sense of avoiding
> >    infinite loop
> >  - unify Makefile license to Dual GPL/BSD
> >
> >
> > Yan-Hsuan Chuang (5):
> >   rtw88: add license for Makefile
> >   rtw88: pci: use ieee80211_ac_numbers instead of 0-3
> >   rtw88: pci: check if queue mapping exceeds size of ac_to_hwq
> >   rtw88: fix unassigned rssi_level in rtw_sta_info
> >   rtw88: more descriptions about LPS
> 
> I was just in the next few minutes about to tag the last -next pull for
> 5.2. I'll apply patch 1 now so that we have consistent licenses for 5.2
> but the rest have to wait for 5.3.

I think '[PATCH v2 4/5] rtw88: fix unassigned rssi_level in rtw_sta_inf'
should go to 5.2 .

Stanislaw
