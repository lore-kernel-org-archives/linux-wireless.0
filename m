Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE216C32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 04:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ECC82082E
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 04:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ECC82082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbeKDN73 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 08:59:29 -0500
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:49765 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727047AbeKDN73 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 08:59:29 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id C8D23100E806B;
        Sun,  4 Nov 2018 04:45:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: scene75_6d568bbd1e049
X-Filterd-Recvd-Size: 2394
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Nov 2018 04:45:51 +0000 (UTC)
Message-ID: <e85b7fa45cefc0bc3df15785f34792abe33f41c6.camel@perches.com>
Subject: Re: [RFC v4 08/13] rtw88: debug files
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date:   Sat, 03 Nov 2018 21:45:50 -0700
In-Reply-To: <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
         <1539421245-11847-9-git-send-email-yhchuang@realtek.com>
         <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com>
         <87y3b1vpjk.fsf@codeaurora.org>
         <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-10-13 at 13:28 -0700, Joe Perches wrote:
> On Sat, 2018-10-13 at 18:23 +0300, Kalle Valo wrote:
> > Joe Perches <joe@perches.com> writes:
[]
> > > It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
> > > config guard flag.
> > 
> > For wireless drivers that is actually quite typical.
> 
> No, it isn't.
> 
> > IIRC at least ath6kl, ath9k and ath10k do that, most likely also others.
> 
> No, they don't.  Check again.
> 
> > > Typical debugging would dynamic debugging on a per-line instance andl
> > > this uses a single dev_dbg for all debugging.
> > 
> > I don't recall seeing anyone using per-line dynamic debugging with
> > wireless drivers. The drivers are so complex that enabling one message
> > at a time doesn't really get you anywhere, that's why we mostly group
> > messages into similar groups (or levels) to make it easier to enable
> > certain debug messages.
> 
> You should look harder.  
> 
> > > This seems unnecessarily complexity for a negative gain.
> > 
> > I haven't reviewed the driver yet but from a quick look I don't see this
> > as a problem.
>   
> It is unnecessarily complex.
> This saves one dereference per call, but is it really worth it?

Kalle, did I miss a reply here?


