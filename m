Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDEEC433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 10:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055B9208B8
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590662081;
	bh=jt7wS7MneRbnR+Oz7vWwchZ6G5JlaVhuKhZjNMeHXAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jzsbmbDJkz3rP01KRh3lGF6tQq97N3B0mqvCQVC/JmowbnqzEcAeUZdKtkFlCcMdN
	 J9Dfi9dYGTdvbwewGOabmDrZsWjECI3/AR35E+HHGfVYS+X3K4YBpfc/FZmZBFi/8W
	 nGR++C6FouTnhu5eKwOFHKRg5k2Z3HtkiklFu8Mc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgE1Kei (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 06:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387758AbgE1Kef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 06:34:35 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3E2208DB;
        Thu, 28 May 2020 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590662074;
        bh=jt7wS7MneRbnR+Oz7vWwchZ6G5JlaVhuKhZjNMeHXAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x+YUkG/PKi6d2c0L1pTYITycjYCvT2YdCI1OpXnwWsxgEAgrbJQvmoj4gRaxvEcCn
         ik2j2pAKF7c3LlzDSOPCI7q9y04Yudw3NEkhuO/VCJntSwEl8wMBMP+6RkBt36BCgO
         DMJDw/APFI5Ci4PKB5mgf8qeTIqnVOGNh/uiyK58=
Received: by pali.im (Postfix)
        id 9F5BB7B2; Thu, 28 May 2020 12:34:32 +0200 (CEST)
Date:   Thu, 28 May 2020 12:34:32 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] mwifiex: Firmware name for W8997 sdio wifi chip
Message-ID: <20200528103432.irmsaaz72x3xophg@pali>
References: <20200515132353.vfor7v4buzoddfmb@pali>
 <VI1PR04MB4366625917BB57695BE454448FBA0@VI1PR04MB4366.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4366625917BB57695BE454448FBA0@VI1PR04MB4366.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Saturday 16 May 2020 08:17:17 Ganapathi Bhat wrote:
> Hi Pali,
> 
> Thanks for this notice. We will try to push the new firmware and also, fix the naming problem.
> 
> Regards,
> Ganapathi

Hello Ganapathi!

According to publicly available information, firmware for these W8xxx
Marvell wifi chips is vulnerable to security issue CVE-2019-6496 [1].

Are you able to update firmwares to the last versions and give us some
information which (old) firmware versions are affected by that security
issue?

So Linux distribution would know if they are distributing older
vulnerable firmwares and should push security fixes with new firmware
versions.

[1] - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-6496
