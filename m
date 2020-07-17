Return-Path: <SRS0=dC3w=A4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBCFC433E4
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Jul 2020 03:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E712420672
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Jul 2020 03:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGQDck (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jul 2020 23:32:40 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:54164 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbgGQDch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jul 2020 23:32:37 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 47253100E7B43;
        Fri, 17 Jul 2020 03:32:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tent30_630630226f07
X-Filterd-Recvd-Size: 1513
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Fri, 17 Jul 2020 03:32:35 +0000 (UTC)
Message-ID: <dec0f4641a13ed392a37526a812062b35e8098f1.camel@perches.com>
Subject: Re: [PATCH 01/14] rtlwifi: Replace RT_TRACE with RT_DEBUG
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 16 Jul 2020 20:32:34 -0700
In-Reply-To: <20200717020201.18209-2-Larry.Finger@lwfinger.net>
References: <20200717020201.18209-1-Larry.Finger@lwfinger.net>
         <20200717020201.18209-2-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-07-16 at 21:01 -0500, Larry Finger wrote:
> The macro name RT_TRACE makes it seem that it is used for tracing, when
> is actually used for debugging. Change the name to RT_DEBUG.
> 
> In the initial step, RT_TRACE must be kept to allow building. It will
> be removed at the end of the patch series.

Likely this patch could be broken out
so that the addition of RT_DEBUG is
patch 1 and the remainder of this patch
is patch 2.

And I'd suggest not using RT_DEBUG as the
macro but use rtl_dbg instead.

Lastly, the _rtl_dbg_trace function
should probably be renamed _rtl_dbg.

Other than that, I think this entire
series is sensible, thanks.


