Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5275BC433FE
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Mar 2022 16:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349804AbiCXQhB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Mar 2022 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiCXQhA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Mar 2022 12:37:00 -0400
Received: from mxout013.mail.hostpoint.ch (mxout013.mail.hostpoint.ch [IPv6:2a00:d70:0:e::313])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B270046;
        Thu, 24 Mar 2022 09:35:28 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nXQQo-000FQP-NN; Thu, 24 Mar 2022 17:35:26 +0100
Received: from [2a00:a680:2222:ff00:421d:ad7:faa1:5cf9]
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nXQQo-0007gn-IP;
        Thu, 24 Mar 2022 17:35:26 +0100
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
Message-ID: <429120bd-c321-ca44-a98f-a2d8f1ef483d@reto-schneider.ch>
Date:   Thu, 24 Mar 2022 17:35:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/2] rtl8xxxu: fill up txrate info for gen1 chips
Content-Language: en-US
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@kernel.org,
        Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org
References: <20220318024216.42204-1-chris.chiu@canonical.com>
 <20220318024216.42204-3-chris.chiu@canonical.com>
From:   Reto Schneider <code@reto-schneider.ch>
In-Reply-To: <20220318024216.42204-3-chris.chiu@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 18.03.22 03:42, Chris Chiu wrote:
> RTL8188CUS/RTL8192CU(gen1) don't support rate adatptive report hence
                                                 adaptive

> no real txrate info can be retrieved. The vendor driver reports the
> highest rate in HT capabilities from the IEs to avoid empty txrate.
> This commit initiates the txrate information with the highest supported
> rate negotiated with AP. The gen2 chip keeps update the txrate from
> the rate adaptive reports, and gen1 chips at least have non-NULL txrate
> after associated.
