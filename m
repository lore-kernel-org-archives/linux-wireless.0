Return-Path: <SRS0=bi0l=ZN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF38BC43215
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 16:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7772206CC
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574354040;
	bh=+1JSgoYETF8UVwlur21fixoQlxzQ3eee0TR+FEOllDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RtE6/no4Rg4ewunSwQiRr8t2pUfVGYmUiSsWoaHu/vjXBAuYQyMjca08CjdhTTVtn
	 cNybiIxWRgXlNATSdF9cIJwFPpwbxtbR8f5O76tFhpsXnNBF05FisfMxEZtGjqj8AM
	 xzy7AgE4UMSSHKH+S7JoSFrLOEUUMtbt1S3BmWuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKUQd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUQd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Nov 2019 11:33:56 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B51020692;
        Thu, 21 Nov 2019 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574354036;
        bh=+1JSgoYETF8UVwlur21fixoQlxzQ3eee0TR+FEOllDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKlLcwjmz8wPlXIU6YrxZkefgMDyYU/WVSB2ySuTCjzGJZq5GQ7PusVwhHU+pAUxD
         is7r6FZXEduoRnbzVZeZahETgtv1XemjUjFLXOUJ5POh9r9TlSQ1joJV11NS4SHWWk
         8mcCNWlMxHeN6qVGYeTRYCiJ77vhSuvycdR0g0Dk=
Date:   Thu, 21 Nov 2019 17:33:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, dmitry.torokhov@gmail.com,
        Jes.Sorensen@gmail.com, kvalo@codeaurora.org, johan@kernel.org,
        linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] drivers: usb: consolidate USB vendor IDs in one include
 file
Message-ID: <20191121163351.GB651886@kroah.com>
References: <20191121161742.31435-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121161742.31435-1-info@metux.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 21, 2019 at 05:17:42PM +0100, Enrico Weigelt, metux IT consult wrote:
> Instead of redefining usb vendor IDs in several places, consolidate
> into one include file: include/linux/usb/usb_ids.h

Also, you somehow forgot to cc: the USB maintainer, meaning this patch
probably wouldn't be accepted anyway :)
