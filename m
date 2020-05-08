Return-Path: <SRS0=6+7Q=6W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F655C4724C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 16:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E1DE24956
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588954036;
	bh=uLbNyI7Z14KTi1E6slPZdT0e6uxwRWlOOk93NDOTbTw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:List-ID:From;
	b=A1tWfVHbKMypGodWUm+wN1n+49aiBoPd4amLHMLmNhkqj6NqL3X/a83KjUpR43R0e
	 RBiJFwltIyaZqE3Hqrsdnmc0atkwL3hz+CDZfRpABQJ0MLFhgfTT36M8cwAGys3aSx
	 M4iD9VHNoZQ13KLFNlzI5tbkKNYlgpLPIUO7eqNg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEHQHP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 May 2020 12:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgEHQHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 May 2020 12:07:14 -0400
Received: from localhost (mobile-166-175-190-200.mycingular.net [166.175.190.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B65320725;
        Fri,  8 May 2020 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588954034;
        bh=uLbNyI7Z14KTi1E6slPZdT0e6uxwRWlOOk93NDOTbTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Vfa8MaGsNoJhb0kFwm2qNcSKwyhZThyTfoj8OtYgR5/qX5J6CxRIiqYMRCRBVWsml
         l6ivXOBTIIOpt8oYE0DgNaIp8Ng16ySnyuA5sw1RH290pvqmH7B6JcYrCqGZTgANTw
         EENa4s8urGyc9CgQR0pyspVhBFyx/tjagHOr1xSo=
Date:   Fri, 8 May 2020 11:07:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yicong Yang <yangyicong@hisilicon.com>
Cc:     linux-pci@vger.kernel.org, kvalo@codeaurora.org,
        andreas.noever@gmail.com, rjw@rjwysocki.net,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        mika.westerberg@linux.intel.com, linuxarm@huawei.com
Subject: Re: [PATCH v2] PCI: Use pci_pcie_find_root_port() to get root port
Message-ID: <20200508160712.GA75354@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5ccd55-5aac-ef16-6402-75dfaeaee6bf@hisilicon.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, May 08, 2020 at 08:40:49PM +0800, Yicong Yang wrote:
> On 2020/5/7 3:48, Bjorn Helgaas wrote:
> > On Wed, May 06, 2020 at 08:42:56PM +0800, Yicong Yang wrote:

> >>  {
> >> -	while (1) {
> >> -		if (!pci_is_pcie(dev))
> >> -			break;
> >> +	dev = pci_physfn(dev);
> >> +	while (dev) {
> >>  		if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT)
> >>  			return dev;
> >> -		if (!dev->bus->self)
> >> -			break;
> >>  		dev = dev->bus->self;
> > Why not use pci_upstream_bridge() here?
> 
> We'll judge whether the device is virtual or not every time we call
> pci_upstream_bridge(). I think it's unnecessary and we only need to get
> the physical function at the beginning of the traverse. It's okay to
> use pci_upstream_bridge() here if you suggest so.

I think we should use pci_upstream_bridge() consistently.  Using two
different patterns is confusing and error-prone.

Bjorn
