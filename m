Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1185CC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 17:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D160220818
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 17:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0Xjuktk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbfCAR2I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:28:08 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:34019 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfCAR2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 12:28:08 -0500
Received: by mail-ot1-f46.google.com with SMTP id 98so21684891oty.1;
        Fri, 01 Mar 2019 09:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d8r6807PpZ/TrsR3U6y8O/oH0JFdHC7CmGaGmHjEVpI=;
        b=T0XjuktkrikDrLTLkcCCbiWcnwmlt+e2gANDJHiMllCpSSwvHrj28+WkNCpXGkc1Qn
         TnUEw5m2KOcWlEBZRcsZciCwrwSWMHewYOiO0iSzLTOWf/2bY8rlYLoH2C7gnOP6uXce
         MTwLbHz6uM/ado2gcRkUmas82nYu5E7r8Gi+T5rCMyoItk1J9ci9VPX+eo0E+HAYxnri
         BMPQbjhs8XIqkUOtxjzQYSGOsQr9lLI6nDXmYcK6vRHbaVxbpFhbFUZgY0LcGhRploJJ
         AY3ddapJbaZO2pSmptDcOysw8WGifvnMi37hlS3nfLZMho0TD4XkyhArXGQlwFeJTUWO
         SHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d8r6807PpZ/TrsR3U6y8O/oH0JFdHC7CmGaGmHjEVpI=;
        b=JV0i0m7l6frbbRGpLTNMUSJmP67YyifYoAXnmW7pHVGR8KFVg49/3EcWlBXcykWxEo
         KBDkk9jdVDcd441jkeR5XYjXV9QfMXP03JEtlgG5jDt4aOL4uH8DKIedXS2Gv39XaloJ
         NDYrukHHT98ej00ex5Wm1Nka3esdn488P8Qv+1+8ae9wyhkJbDo127VtrfaoXnFLW2ic
         pLfNvNnJgoq/JIoLi4cmKqlEPvSMD2t3DQ53Dw92HPrZtbvATpUx521vINMD/qKKDb5a
         UmPXf4X2Nvdoxa+Pip5YGgDIPUlfGSIVzXd1YgaG2/GqzOohzncL7zjF15fdebBEHuvw
         2TPw==
X-Gm-Message-State: APjAAAVLoqeWKPzjX6i4xmDUeyG+uNZYsEXbsKYEl6JXC0IMoa2bxtN6
        cxZMEEUKIo1Y1z07a71igB+GjlQO
X-Google-Smtp-Source: APXvYqyPRpFfpzhLuJUqA3CUY2x3YUwBHwpPGarQsf+tzdpzr/nVLFJekZugYflZNU4478KEEq87rg==
X-Received: by 2002:a9d:6d0c:: with SMTP id o12mr4263183otp.256.1551461287138;
        Fri, 01 Mar 2019 09:28:07 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l64sm9263092oif.44.2019.03.01.09.28.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 09:28:05 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
To:     "David R. Bergstein" <david.r.bergstein@gmail.com>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
Date:   Fri, 1 Mar 2019 11:28:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/28/19 8:32 PM, David R. Bergstein wrote:
> Tony,
> 
> Thanks for your response.  Can you advise as to the availability of the
> new rtw88 driver?  As it appears to be under development, I could not
> locate a copy of the code for local compilation.

David,

Use the command 'git clone http://github.com/lwfinger/rtlwifi_new.git -b rtw88' 
to get a copy of the new driver for RTL8822BE and RTL8822CE in a stand-alone 
form. All that is needed is 'cd rtlwifi_new && make && sudo make install'. This 
version will build on kernels v4.4 and newer. As I have time, I will be 
backporting to kernels at least as old as 4.0.

I would appreciate your comments and bug reports.

Larry


