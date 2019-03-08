Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D654C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B71208E4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552065870;
	bh=h9mQEtiMtqksTqdyqnT4w/SwH5auu5osAE1/Zv9Nonk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NCLl7wP5m/sJRSmKZrk7RGss4i816Sg0cKmHAUX3hwa1yX7hpAf/1g1841Yo081mB
	 XkAP3YsYoRV66PjYZKhzzVaHFT6VwRVPMna6DsiF5pdm5w0Au0stnsBF2Uv9H9L/Zw
	 pvgKQ2dRciZ7b/i24VkgXFjsaX1CLQ+Pw/6fCQ6U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfCHRY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfCHRY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 12:24:29 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E2D20851;
        Fri,  8 Mar 2019 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552065868;
        bh=h9mQEtiMtqksTqdyqnT4w/SwH5auu5osAE1/Zv9Nonk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W/Ru9wLM24OXbieL9VS896+hUBo8hvsFwpAm2Pncotzi3995JcEwoLFMpzTrj74Lu
         gBCjKrG1rk0DXYE+iU0dBoCHjuWweyVOElykeCHpxZBX7F6Wr+hYiseAWsaPuDvakB
         S0lL1m7rAkPgJnVLjxvqrCJmxjw97KvNzHKrmIsA=
Date:   Fri, 8 Mar 2019 18:24:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     yhchuang@realtek.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v6 14/14] staging: rtlwifi: remove staging rtlwifi driver
Message-ID: <20190308172426.GA20723@kroah.com>
References: <1552053343-6513-1-git-send-email-yhchuang@realtek.com>
 <1552053343-6513-15-git-send-email-yhchuang@realtek.com>
 <20190308140619.GE25768@kroah.com>
 <f69bd329-f974-7f82-11dd-c864ee283762@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f69bd329-f974-7f82-11dd-c864ee283762@lwfinger.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 08, 2019 at 11:20:11AM -0600, Larry Finger wrote:
> On 3/8/19 8:06 AM, Greg KH wrote:
> > On Fri, Mar 08, 2019 at 09:55:43PM +0800, yhchuang@realtek.com wrote:
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > > 
> > > The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> > > series driver rtw88, remove it to avoid racing with the same ID.
> > > 
> > > The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
> > 
> > The only objection I have here is that your new driver does not support
> > all of the devices that this driver does.  So why not just rip out the
> > PCI stuff for the staging driver until the USB/SDIO code gets added to
> > the new one, and then you can drop the rest of this code?
> 
> Greg,
> 
> The staging driver only supports PCI ID 0x10ec:0xB822, whereas the new one
> supports that ID plus 0x10ec:0xC822. There will not be any devices dropped
> when the staging code is deleted as long as the new driver is added.

Ah, ok, all of those "*usb*" files in that driver directory lied :)

If there's no regression of devices, then I have no objection to this:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

thanks,

greg k-h
