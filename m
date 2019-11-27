Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8D3C432C3
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 10:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2548F2084B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 10:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dlink.ru header.i=@dlink.ru header.b="C8h4I5Jw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK0K3S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 05:29:18 -0500
Received: from fd.dlink.ru ([178.170.168.18]:53404 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfK0K3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 05:29:17 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id BB5C21B2120E; Wed, 27 Nov 2019 13:29:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BB5C21B2120E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574850553; bh=EsvGsnpDTlUlkRudAZRaGscbrq1rpDXrPl2b4VXesCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=C8h4I5Jw3GU/gGodtmFJfokOxM+MnPrYiEZvOPpR71NzZllqQbJk9oc8NGhbVJr8Z
         lcMdvh7BDkng/94rgxrdml69FW+P1g5E3QMiZ3SReLzFvfvGG3Gshrdkqps/s+IFNF
         V0BcM5VO7ddfkkJ8v8opMOcHx1yMNStorUpx65nw=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id EE0721B2089D;
        Wed, 27 Nov 2019 13:29:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru EE0721B2089D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 9206C1B22678;
        Wed, 27 Nov 2019 13:29:03 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 13:29:03 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 13:29:03 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Kenneth R. Crudup" <kenny@panix.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
In-Reply-To: <PSXP216MB0438B2F163C635F8B8B4AD8AA4440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191127094123.18161-1-alobakin@dlink.ru>
 <7a9332bf645fbb8c9fff634a3640c092fb9b4b79.camel@intel.com>,<c571a88c15c4a70a61cde6ca270af033@dlink.ru>
 <PSXP216MB0438B2F163C635F8B8B4AD8AA4440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <a638ab877999dbc4ded87bfaebe784f5@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nicholas Johnson wrote 27.11.2019 13:23:
> Hi,

Hi Nicholas,

>  Sorry for top down reply, stuck with my phone. If it replies HTML
> then I am so done with Outlook client.
> 
>  Does my Reported-by tag apply here?
> 
>  As the reporter, should I check to see that it indeed solves the
> issue on the original hardware setup? I can do this within two hours
> and give Tested-by then.

Oops, I'm sorry I forgot to mention you in the commit message. Let's
see what Dave will say, I have no problems with waiting for your test
results and publishing v2.

>  Thanks
> 
>  Regards,
> 
>  Nicholas

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
