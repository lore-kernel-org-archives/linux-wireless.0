Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3D0C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 18:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BBC20830
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 18:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2LW412k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCBSJG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:09:06 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:39159 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfCBSJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 13:09:06 -0500
Received: by mail-qt1-f178.google.com with SMTP id o6so1036293qtk.6;
        Sat, 02 Mar 2019 10:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iaj3tUgZJkmsHu8EtGMGMTuXvrFTgn8sv74AH2IUApg=;
        b=J2LW412k0hbvf3+hPlqsJri7NGqFCetdai69Joj5MEG1vVTNUnAjKpxrvOST1Uj5MH
         oR12UI6oXlWEMOK0l7nt3StuhxzQmOSv+axEd6xNaq2SlEDw4JuGKXvQgjhV3wmP7l9Y
         APZaCbuifIwe0fqWIQpf6HYR6r/Dor6wh6D8tDiZwlf3rZFd/4P473mqXC0OcVZH+X2w
         bxk2PPBloUC0iyGUhfc5sz0VDza06ZUd99330pDu24upB5NWG4+tTuOp83AQPxDUT5WA
         FZq6kbymJB9PNAbQg2IxDlxZUmfWTEDk5XNMribz6xx1Cb64fQbSOVHUn+49+TG4aL2y
         wOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=iaj3tUgZJkmsHu8EtGMGMTuXvrFTgn8sv74AH2IUApg=;
        b=lGdBFto6Dtgs5Tu5DsPMlAwC8vcR0dlXfvjd+YcOot/XTD6xu+oH9LQqKNygfWt41V
         VT7gCZpfWgmaqTAdXJ/+JiXGx28ttOSqA1i0vx7eJ+PeMXV+v/UQJBax+cen46cxuCRh
         3fajoFN+hJ7r5m3RKzFrmcEmoX9Y5NtJugRqWQQ3JojGQJqh82xSfiWuSA5VHHmldvOG
         l0Mrw48OXi3D6/KFTylwARBtJ063PWcV0KB5j5m7SG5Xque7yNpxLDtzjc9uwQoNJX+r
         16KrKAoKmwJOlH0YYPSKjp6666k5kz5iNaINrszQ3ZfxgvAvCGgErkHh3zy+VMdd8wI5
         9Kgw==
X-Gm-Message-State: APjAAAW2AhQxxq824EPQrevrO6fnC7RuW+EgqKyuXy7XCOom2aEFbg+m
        n8omciu8eCC4jTZrpW4v+zqqbBDd
X-Google-Smtp-Source: APXvYqzFYwOTbH6M9sn8R9SpZSlng/4uFYCu5/QJj7DlEV0WNFXbEtxr3l4G3ITfTa1RAYfxBIa2FQ==
X-Received: by 2002:aed:21cc:: with SMTP id m12mr8760241qtc.203.1551550144660;
        Sat, 02 Mar 2019 10:09:04 -0800 (PST)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id c73sm1553585qka.37.2019.03.02.10.09.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Mar 2019 10:09:04 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
To:     Larry Finger <Larry.Finger@lwfinger.net>,
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
 <c64c435c-fda7-9356-0205-093182fb1398@lwfinger.net>
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <96c5b6c4-61fe-570d-ba2d-7721b1be7cca@gmail.com>
Date:   Sat, 2 Mar 2019 13:09:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <c64c435c-fda7-9356-0205-093182fb1398@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

I tried using iw but it gives the same reading for bit rate.  In regard
to the firmware, it was not installed via "make install" so I did it
manually.

Sincerely,

David R. Bergstein

On 3/2/19 12:58 PM, Larry Finger wrote:
>> Larry,
>>
>> Sorry about all these extra replies.  Shortly after I sent my last
>> message my access point started recognizing the connection as 802.11ac
>> with PHY Rate / Modulation Rate of 866.6 Mbps.  What is somewhat
>> misleading is the information reported by iwconfig (see bit rate below).
>>
>> $ iwconfig wlo1
>> wlo1      IEEE 802.11  ESSID:"XXXXXXXXXX-5G"
>>            Mode:Managed  Frequency:5.22 GHz  Access Point:
>> xx:xx:xx:xx:xx:xx
>>            Bit Rate=6.5 Mb/s   Tx-Power=23 dBm
>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>            Power Management:on
>>            Link Quality=70/70  Signal level=-40 dBm
>>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>            Tx excessive retries:0  Invalid misc:11   Missed beacon:0
>
> The utility iwconfig is obsolete and not exactly up to date with the
> latest in wireless. I am not an expert on iw, but I think you want 'iw
> dev wlo1 link'.
>
> I am wondering about the missing firmware stage. Had you not done the
> 'sudo make install' step, or did that step fail to install the firmware?
>
> Larry
>
