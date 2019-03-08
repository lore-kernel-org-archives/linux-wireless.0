Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EADC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0599B20661
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfCHNGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:06:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfCHNGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 08:06:30 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E981D30917A8;
        Fri,  8 Mar 2019 13:06:29 +0000 (UTC)
Received: from localhost (unknown [10.40.205.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8057F5F9C8;
        Fri,  8 Mar 2019 13:06:29 +0000 (UTC)
Date:   Fri, 8 Mar 2019 14:06:28 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Message-ID: <20190308130626.GB4108@redhat.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
 <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
 <F7CD281DE3E379468C6D07993EA72F84D17BC3EB@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17BC3EB@RTITMBSVM04.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 08 Mar 2019 13:06:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 08, 2019 at 12:38:48PM +0000, Tony Chuang wrote:
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > 
> > Also in another thread I saw something about this driver conflicting
> > with a staging driver, is that true? That should be solved before the
> > driver is accepted as I don't think two drivers should race for the same
> > hardware and the driver is randomly chosen.
> > 
> 
> I think this could be fixed by removing the staging driver via
> wireless-drivers-next as you said before. Can you help me coordinate
> this with Greg? Or should I send the patch that removes the staging
> driver to you.

Please post the removal as additional patch of rtw88 set and cc Greg,
it should be ok to remove the staging rtlwifi driver via
wireless-drivers-next.

FWIW whatever issues rtw88 maight have, it's 1000x better to have
it included in the linux kernel than staging/rtlwifi.

Stanislaw 
