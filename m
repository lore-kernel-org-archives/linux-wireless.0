Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B97C64EB8
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 18:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 660E32089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 18:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 660E32089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbeJDBOw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 21:14:52 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47832 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbeJDBOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 21:14:52 -0400
Received: from marcel-macbook.fritz.box (p4FEFC9BB.dip0.t-ipconnect.de [79.239.201.187])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7465ECF359;
        Wed,  3 Oct 2018 20:32:37 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <24BAAAAB-17E4-4820-A09A-50984B8EBA40@canonical.com>
Date:   Wed, 3 Oct 2018 20:25:18 +0200
Cc:     Matt Chen <mattsled@gmail.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <910F8A29-3141-422F-87EE-7BFBCDE9060C@holtmann.org>
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
 <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
 <81B978A9-270E-4C0B-BE67-D05899B1BC3B@canonical.com>
 <CALx5=V_0fyTcpTdYh=ZOLWL79cop1F=5GyMuK6S9QnP5qHKouQ@mail.gmail.com>
 <24BAAAAB-17E4-4820-A09A-50984B8EBA40@canonical.com>
To:     Kai Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kai-Heng,

>> I think Canonical were facing some wifi fw load error from some 8260
>> earlier module during the BT still loading the fw.
>> I believe we had later 8260 sku that fixed this issue.
> 
> But there are already 8260 that is affected by this bug in the wild.
> 
> Search "Bluetooth: hci0: Failed to send firmware data (-38)” and there are lots of user are affected.

which SKUs are these actually. What are the initial details about the boot loader. For the Bluetooth side, you should be able to grab them from dmesg or by running btmon.

So I am not in favor of this kind of hack and creating dependencies between drivers. If you only have a hammer, then everything looks like a nail. And this is a massive hammer trying to squash everything. This problem needs to be debugged. And this starts by providing affected SKU information and firmware information. So get the details about the SKU and its Bluetooth and WiFi boot loaders.

Regards

Marcel

