Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1152BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8AA720657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfCKNRY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:17:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfCKNRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:17:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C246DA971A;
        Mon, 11 Mar 2019 13:17:23 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E06E60C8E;
        Mon, 11 Mar 2019 13:17:23 +0000 (UTC)
Date:   Mon, 11 Mar 2019 14:17:21 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v7 09/14] rtw88: chip files
Message-ID: <20190311131720.GA6089@redhat.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
 <1552139302-20476-10-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552139302-20476-10-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 11 Mar 2019 13:17:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 09, 2019 at 09:48:17PM +0800, yhchuang@realtek.com wrote:
> +		rtw_write32s_mask(rtwdev, REG_RFESEL8, MASKBYTE1, 0x57);

Using of 0xff00 would more readable for average developer than MASKBYTE1
IMHO all of those MASK* defines should be removed and replaced by hex
numbers or GENMASK() makro for non-standard masks like 0x3fe0 .

> +	rtw_write32_mask(rtwdev, REG_CCASEL, MASKDWORD, reg82c);
MASKDWORD is 0xffffffff (all bits of 32 bit word), rtw_write32_mask()
can be just replaced by rtw_write32().

Stanislaw
