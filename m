Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F00AC432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 07:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 129432071E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 07:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dlink.ru header.i=@dlink.ru header.b="n0zd+O3r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfK0Hrl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 02:47:41 -0500
Received: from mail.dlink.ru ([178.170.168.18]:51026 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfK0Hrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 02:47:40 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 99C011B213A7; Wed, 27 Nov 2019 10:47:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 99C011B213A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574840856; bh=kPCincx6WXgTjBojr/1srj3i7XXXZ2Xo1HYvTiL29G0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=n0zd+O3r55LqYjDoskRSxdlBOfgpEMMLSFXs50r67Avssxq29H+hFukXjFu+Dv5Nr
         6r7vM2nXnJdReZ5QepXWWBj+CAr1NicyeeXB59bZ7JNVeE5/aZkRS2nCEuiTFRjxEc
         9sDXsEuJMrZuf6EhznaWQw4wy0huoPFDwODw9FAY=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id A454B1B209D6;
        Wed, 27 Nov 2019 10:47:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru A454B1B209D6
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 4F7721B2023D;
        Wed, 27 Nov 2019 10:47:26 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 10:47:26 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 10:47:26 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     pabeni@redhat.com, johannes@sipsolutions.net, ecree@solarflare.com,
        nicholas.johnson-opensource@outlook.com.au, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <20191126.155746.627765091618337419.davem@davemloft.net>
References: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
 <d535d5142e42b8c550f0220200e3779d@dlink.ru>
 <20191126.155746.627765091618337419.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <4cb1abfb7cbd137151f024405f7b0678@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

David Miller wrote 27.11.2019 02:57:
> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Mon, 25 Nov 2019 15:02:24 +0300
> 
>> Paolo Abeni wrote 25.11.2019 14:42:
>>> For -net, I *think* something as dumb and hacky as the following 
>>> could
>>> possibly work:
>>> ----
>>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> index 4bba6b8a863c..df82fad96cbb 100644
>>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> @@ -1527,7 +1527,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans
>>> *trans, int queue)
>>>                 iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
>>>         if (rxq->napi.poll)
>>> -               napi_gro_flush(&rxq->napi, false);
>>> +               napi_complete_done(&rxq->napi, 0);
>>>         iwl_pcie_rxq_restock(trans, rxq);
>>>  }
>>> ---
>> 
>> napi_complete_done(napi, 0) has an equivalent static inline
>> napi_complete(napi). I'm not sure it will work without any issues
>> as iwlwifi doesn't _really_ turn NAPI into scheduling state.
>> 
>> I'm not very familiar with iwlwifi, but as a work around manual
>> napi_gro_flush() you can also manually flush napi->rx_list to
>> prevent packets from stalling:
>> 
>> diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
>> --- 14:55:03.610355230 +0300
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
>> 14:57:29.399556868 +0300
>  ...
> 
> Thanks to everyone for looking into this.
> 
> Can I get some kind of fix in the next 24 hours?  I want to send a 
> quick
> follow-on pull request to Linus to deal with all of the fallout, and in
> particular fix this regression.

If Intel guys and others will agree, I'll send a patch which will add
manual napi->rx_list flushing in iwlwifi driver in about ~2-3 hours.

Anyway, this driver should get a proper NAPI in future releases to
prevent problems like this one.

> Thanks!

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
