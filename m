Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DB5C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 13:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5212075E
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 13:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=bartschnet.de header.i=@bartschnet.de header.b="F/46cAHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDCNa7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:30:59 -0400
Received: from mail.core-networks.de ([82.96.72.7]:54135 "EHLO
        mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfDCNa6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 09:30:58 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 09:30:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bartschnet.de; s=2018030201; h=Content-Transfer-Encoding:MIME-Version:Date:
        Message-ID:Subject:From:To:content-disposition;
        bh=y3PLBx8YBr7DiXb5fdzGqhlegrVXUC6Yf/qIkCpsSU8=; b=F/46cAHaN2uz7uCCf9ii+nAgsW
        J2VyR8IkRuaTVnkbvBEFzCVotkRNp9t/ScB5nKBMNW/rV8PYlWyTsMlE1Un00trPC56c+Rvnpqfah
        a4WCIPpQlxJJ5gkFkdfZRHFvpger6CsR8Qs4YCjdni2xOP6F3moYPBtYT6ThDhwsDKc0sLzJrcvyz
        mgmVAQ83tcv6vvKLxZUWh20VZWjW0hbTErKcsYyh8HNYQoa6msGvsn3KXiwcof299P6zl+kdFydQa
        SPgRcrUpVN4hSoSpo97bISZQ31NkYnzDPrH+mCcI6K2AZqZWmJ+hY4MxEe8euX3hTcKzb/wsjtG6L
        ZZHPEPtU0wbl8oyJLEbQfxZNAOFkyGV6Fb0xrgYKBpazW6gEVq+hCcO/pgo7AGdK5yDYHwsPYceaa
        zO6IXel5SGoMx5AqZ/kaP4Rl/gaFS4m1wcYw2eAThhZyU39zEY74RjspO/xsoiU89vulrcSUmVefn
        lwz4fiNUxHRmQAghlBDZzfWrtJugQWldnDatWpOdQg2QmQLUSxVVqUqKX6FSUrEHMFrlFwDL/6OPi
        IgBd9mn1OSQ8vlpL1gXloK6eR6AZ9cfoowkDYpgWJmslYaJSc74X9gJndXiwljnfbcZLWqwByD6Q4
        x6AEEZzPnfm4774qpdDF/sBZB0fufWluzhkSOOCeQ=;
Received: from localhost (localhost [127.0.0.1])
        by mail.core-networks.de id 1hBfU8-000818-7A
        with ESMTPSA (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        for linux-wireless@vger.kernel.org; Wed, 03 Apr 2019 14:59:22 +0200
To:     linux-wireless@vger.kernel.org
From:   "Rene 'Renne' Bartsch, B.Sc. Informatics" <ml@bartschnet.de>
Subject: Bug: Country code cannot be changed on Compex WLE900VX (qca9880)
Message-ID: <2378a7a3-6973-6a38-fb74-d495ca7916ba@bartschnet.de>
Date:   Wed, 3 Apr 2019 14:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

the ath10k module sets the country code to US at initialization. After that the country code cannot be changed anymore (e.g. to "DE").

Compex support suggests setting "reg->country_code = CTRY_UNITED_STATES;" in "/drivers/net/wireless/ath/regd.c" to the local country.

Re-compiling every kernel-update isn't an option on production systems. :-(

Kernel version: 4.19.0-4-amd64 #1 SMP Debian 4.19.28-2 (2019-03-15) x86_64 GNU/Linux on Debian 10 Buster

See http://forums.debian.net/viewtopic.php?f=5&t=141402&p=695556 for further details.


Regards,

Renne
