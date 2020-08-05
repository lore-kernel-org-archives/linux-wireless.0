Return-Path: <SRS0=0wPU=BP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F38C433E1
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 19:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA01206B6
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 19:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOqCpX30"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgHETRp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgHETPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Aug 2020 15:15:44 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ADAC061A2A
        for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2020 12:13:26 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id k63so6173788oob.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2020 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AS8u1LDDJrmokPtG/w7gyetT66W9vGtz3XkSpLnzZ5U=;
        b=KOqCpX306Ky2CYx3qrCGUXtG0AQmubTA/X0BfavfK/UEAiFUwvIGByXwLMjs/4gnaH
         +duhJ3o92RlLO8uEoNz0/8ctk1aobWMpzuY2C3wnUJ1yPMdDA2znNwftt4URXNnCaEHF
         L17jZoDInQtyqGduQvAKe5mcPoFObYTQUfTp7G5zRfH/rNUaEDeqBy51URxLkToAqdJX
         dRIqqLD/WRm7JYmrNArE9WJ/OCbsdwkomrOu3v74tm76gJAOgeO8lplwSaFp57amN4YS
         08LfcXhG43DGDOMPy+5jTnQMS77uYt6ScLN3zhii2V6C/RaQF5teVA91zSrhfQ7wS9sC
         Jyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AS8u1LDDJrmokPtG/w7gyetT66W9vGtz3XkSpLnzZ5U=;
        b=sLkvRqQHjsm1F4hqJANEPHaUFrLNW8mJDKW8NoHutIyREOAki2nfmszz7KKbxcsc9C
         BYeU5hMn1Tcn2DCH7cQEOT0Mn6J3zcNWqZnpw123tQMDOivaLmqx1etMXsDFJZ/LnTie
         CEYr3+JKiy+rYI3RBtvBN970V8mMYgy36fSeW4ByT+kVqlmBAlACyktfU0cGZWuJI/va
         SlrySTT5AjzjPDDyEy9a3Sim+vqPcKYckoShtBt28LYvPReVu/JY14QxZWTiUO5sVEkN
         zf6bUpVzEkOoELIJSobQOUsU1hpPmmp77/fnwEgkBYBwooZl19s9Zt+lqjNeyTlpdeTE
         52yg==
X-Gm-Message-State: AOAM530rP8PSu08pZlHrFO0TNTH/EjdIsxB7Uw82QC/DBAcGAiFPdFaD
        MIWCGmP3ICC2AaipuIYKYjYheKqm
X-Google-Smtp-Source: ABdhPJwf87q5pWTEsRZwSKDgJaXht4OwZj/zZ0d6e991OZhTGAIKTx8OPzS+Dzw5U4RD71YwtFu5jQ==
X-Received: by 2002:a4a:7241:: with SMTP id r1mr4284009ooe.48.1596654805269;
        Wed, 05 Aug 2020 12:13:25 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y14sm617737oos.23.2020.08.05.12.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 12:13:24 -0700 (PDT)
Subject: Re: RTW88 poor perception
To:     DImitar Kosev <buboleck@abv.bg>, linux-wireless@vger.kernel.org
References: <af8abf99-0cb0-ae18-e905-7bbf57270c82@abv.bg>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d9aa9251-cc63-1199-c011-5f34aaee5735@lwfinger.net>
Date:   Wed, 5 Aug 2020 14:13:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <af8abf99-0cb0-ae18-e905-7bbf57270c82@abv.bg>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 8/5/20 2:00 AM, DImitar Kosev wrote:
> Hello,
> 
> I have RTL8821CE card and with this driver I get poor perception on 5GHz (2-3 
> meters max to the router) and only 30-50cm to the router on 2.4GHz. I'm 
> currently using this driver https://github.com/tomaspinho/rtl8821ce that works 
> fine but I understand it will be deprecated once RTW88 goes into the kernel.

I think the word you want is reception not perception.

Please quantify how bad your reception really is by running the following 
commands and posting the output:

iw dev | grep Interface
sudo iw dev <DEVICE> scan | egrep "signal|freq|SSID:"

where <DEVICE> is the interface name from the first command.

Larry

