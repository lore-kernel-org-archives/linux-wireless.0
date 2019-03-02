Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFC6C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 17:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F12920830
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 17:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJR06GBN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfCBR7Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 12:59:16 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:43192 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfCBR7Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 12:59:16 -0500
Received: by mail-ot1-f50.google.com with SMTP id n71so900363ota.10;
        Sat, 02 Mar 2019 09:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sDx/M7qP93enJkvGW388g5o0KovC/DQqsEAbG9aprjw=;
        b=dJR06GBN29wHi+OGhoRnEREyzjXWK20wSZICzvoW8Yh5dW8nw/dE4wQdG1aLR4GnmA
         mM/8Xrw5jeo2AQCcDwPeodqjuHQjLO+tBR6Z2QfS5thUFjwE8WatY5KdPVHrDzu72/iI
         yurngpdylViKVRI4NWqOnUiSp2OH1KULNeNaRdjjMj/7Yiig9D6ZUb5djUxkFzE0/xH3
         ugDK4rffzPDEnQKZn1dfQhb/D689M01mX43q79xo4t3wLXyDfi79vDHIsm/s2Fl/gJB5
         fMzAzDaoRpZXrAPUHeRcscpp2B1iQVnnELVwd145C2LOwgMwcLq+aoG0nqGiwTxyZoAZ
         l1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sDx/M7qP93enJkvGW388g5o0KovC/DQqsEAbG9aprjw=;
        b=OF4gEVnVdJy9AZDErq4CAn2KdFMbCO6F2LHyTtPhcBupxsEYnJwKbvT/07hW3dFtr2
         D18bMn5ksbkSXqCxgIy7OTWelGlxKECBJv40jHIulPB6C2e2rDA9Iu3j4ipIxgHzkTlD
         7ShiSo1J1Kqu7aFtU4nbnaLcEEiBkghSl54AmhxNCdpdvkQmc+H7k3YlhRwo/UlVR+G8
         a5F3C1O6SRZuk5FZxzSHXrufcju/T6CmUCoJfXS1vJM28dqj/CauIDsLcQOUTO9Ubr+T
         MMS4gg4Dlb7b+NJKAjpfjS4C+ooP01Z9IaIC6CUwR6Qtx62PPSGnJY20T3uQml3wIGdP
         mHEw==
X-Gm-Message-State: APjAAAVkDnOwE5e3curxdo279gahPdmw3fg612J+7J8766mU1ZIA3BCb
        9cMgMnooogUoKBIL4eo+Hxc+30p3
X-Google-Smtp-Source: APXvYqzFmHrUIb15HpTGtnZgNW4mQXfJSznirwHpJQpBFfioa7pSXNV05VrTCvHXm1HJLMIvEBHWDg==
X-Received: by 2002:a9d:4b13:: with SMTP id q19mr7510583otf.304.1551549554516;
        Sat, 02 Mar 2019 09:59:14 -0800 (PST)
Received: from [192.168.1.126] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t77sm449296oie.26.2019.03.02.09.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Mar 2019 09:59:13 -0800 (PST)
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
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
 <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c64c435c-fda7-9356-0205-093182fb1398@lwfinger.net>
Date:   Sat, 2 Mar 2019 11:58:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/1/19 9:52 PM, David R. Bergstein wrote:
> Larry,
> 
> Sorry about all these extra replies.  Shortly after I sent my last
> message my access point started recognizing the connection as 802.11ac
> with PHY Rate / Modulation Rate of 866.6 Mbps.  What is somewhat
> misleading is the information reported by iwconfig (see bit rate below).
> 
> $ iwconfig wlo1
> wlo1      IEEE 802.11  ESSID:"XXXXXXXXXX-5G"
>            Mode:Managed  Frequency:5.22 GHz  Access Point:
> xx:xx:xx:xx:xx:xx
>            Bit Rate=6.5 Mb/s   Tx-Power=23 dBm
>            Retry short limit:7   RTS thr:off   Fragment thr:off
>            Power Management:on
>            Link Quality=70/70  Signal level=-40 dBm
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:0  Invalid misc:11   Missed beacon:0

The utility iwconfig is obsolete and not exactly up to date with the latest in 
wireless. I am not an expert on iw, but I think you want 'iw dev wlo1 link'.

I am wondering about the missing firmware stage. Had you not done the 'sudo make 
install' step, or did that step fail to install the firmware?

Larry

