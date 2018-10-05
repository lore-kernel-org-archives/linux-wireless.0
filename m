Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BD6C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FCA2064D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51FCA2064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbeJEOtd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbeJEOtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:49:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B27C43082B62;
        Fri,  5 Oct 2018 07:52:01 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2476010001BC;
        Fri,  5 Oct 2018 07:52:00 +0000 (UTC)
Date:   Fri, 5 Oct 2018 09:51:59 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Chuang <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20181005075158.GB1931@redhat.com>
References: <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
 <20181002102957.GB25116@redhat.com>
 <a54dec4e-1164-f9c5-c791-3396a239eeba@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1728978@RTITMBSVM01.realtek.com.tw>
 <4b50e06f-2fd0-9378-d283-1ca6d02f9586@lwfinger.net>
 <87k1mx28dg.fsf@codeaurora.org>
 <20181004134252.GA20484@redhat.com>
 <2fa15cec-bcef-35af-43af-5365d52d82c8@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fa15cec-bcef-35af-43af-5365d52d82c8@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 05 Oct 2018 07:52:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 04, 2018 at 11:19:59AM -0500, Larry Finger wrote:
> On 10/4/18 8:42 AM, Stanislaw Gruszka wrote:
> >On Thu, Oct 04, 2018 at 03:39:55PM +0300, Kalle Valo wrote:
> >>>>Can we put the configuration file in the firmware directory?
> >>>>Should we package them into binary files? Or just put the raw data.
> >>>>
> >>>>We can test the performance for it. After we got the result, we will make a decision
> >>>>about it. And if we decide to put them in the firmware directory, will send a patch.
> >>>>For now, I think we can just leave them in the .c.
> >>>
> >>>Yes, you could put the configuration files in the firmware directory.
> >>>I would put them in binary form, not as text files. That way the size
> >>>would be smaller, and it would not be possible to alter them,
> >>>particularly if the binary file is checksummed.
> >>>
> >>>It would likely be OK if only the agc table was stored in this way.
> >>>That would take away about half of the lines in the 8822b table file.
> >>
> >>So what's the worry here? The lines of source code, binary size or what?
> >>
> >>  .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
> >>
> >>Looking at the diffstat rtw8822b_table.c seems to be 20 kLOC, IMHO it's
> >>not that bad as it's just data. But of course I might be missing
> >>something as I haven't checked patches yet.
> >
> >My concern was it's plenty of redundant data, for example:
> >
> >         0x81C, 0xFF000003,
> >         0x81C, 0xFE000003,
> >         0x81C, 0xFD020003,
> >         0x81C, 0xFC040003,
> >         0x81C, 0xFB060003,
> >         0x81C, 0xFA080003,
> >         0x81C, 0xF90A0003,
> >         0x81C, 0xF80C0003,
> >         0x81C, 0xF70E0003,
> >         0x81C, 0xF6100003,
> >
> >Approx 10000 lines like this, braked by lines like this
> >
> >         0x90000012,     0x00000000,     0x40000000,     0x00000000,
> >
> >in more or less regular way.
> >
> >Not big deal, but perhaps this could be coded in much more compact way.
> 
> What should be the tradeoff between large tables of redundant data
> and complicated generation and interpretation? I think this table
> should be converted to binary in its present form and added to the
> "firmware", the way that is done for b43. That way the source is
> smaller, and the loading will be only a bit more time consuming.

If at stake is bigger data and simpler parsing/processing I would take
that. But processing is already complex (see RTW_DECL_TABLE* and
related functions) and I hope rearranging the data structures could
even lead to simplified processing.

Thanks
Stanislaw 
