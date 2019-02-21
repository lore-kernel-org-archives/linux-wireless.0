Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49FEC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC58E2083E
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbfBUQCJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:02:09 -0500
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:55732 "EHLO
        3.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfBUQCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:02:08 -0500
X-Greylist: delayed 16801 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2019 11:02:08 EST
Received: from player776.ha.ovh.net (unknown [10.109.143.24])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 616BF1D7CF1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 12:13:28 +0100 (CET)
Received: from RCM-web5.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player776.ha.ovh.net (Postfix) with ESMTPSA id CA1512EA5DF5;
        Thu, 21 Feb 2019 11:13:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 21 Feb 2019 12:13:21 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH wireless-drivers-next 2/2] brcmfmac: print firmware
 reported general status errors
In-Reply-To: <e644a5b7-c70d-056a-740e-997c931863c2@broadcom.com>
References: <20190221103325.28228-1-zajec5@gmail.com>
 <20190221103325.28228-2-zajec5@gmail.com>
 <e644a5b7-c70d-056a-740e-997c931863c2@broadcom.com>
Message-ID: <01dbfeccc2e6f3fcd2e6bd4ccedf805a@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 9788292317581053568
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrledvgdduheelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-21 11:45, Arend Van Spriel wrote:
> On 2/21/2019 11:33 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> Firmware may report general errors using a special message type. Add
>> basic support for it by simply decoding & printing an error number.
>> 
>> A sample situation in which firmware reports a buf error:
>> CONSOLE: 027084.733 no host response IOCTL buffer available..so fail 
>> the request
>> will now produce a "Firmware reported general error: 9" on the host.
> 
> Could have meaningful message instead of a number. I can do that in
> follow up patch if you do not have the information.

That would be nice, thanks!
