Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF26ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 19:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B6420831
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 19:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrzDWqqv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43B6420831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbeJYDl3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 23:41:29 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:42193 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbeJYDl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 23:41:29 -0400
Received: by mail-qt1-f172.google.com with SMTP id j46-v6so6905257qtc.9
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=do2FS+guK+Rgy3iLiFpD7mwkrEJUQ11ONBOFdKp/TbQ=;
        b=LrzDWqqv4O9a8EKAVJ11lCBMj1WACwKD1/sJc6LgAIZgo/oggqoOEQCN4LDirbSSLA
         WoQS8iyj3Gaa/tXEiKmEi45TEmD+7pDeiAgZTPDccT3TbeBPN4ptOh0pLLad5H7knCKE
         aK+pr2zgX6Kn7YkK+VdRVjGv4ItK1i7oG7IzUhZHU/tsNlU+AnY/zhipm62uvCQkN88u
         6ic00aq+UnlQNgFQ6z5oGn2UGjC6Y5t9JNVXmBEztgRtINfQ0w8tlpJs8iGvf9SZ8gUc
         HL35I13RjOtJ1zUFihi5cywMxK9yG7gDNwH1VsndjETzW1827hoDRqYwmmTpT1OH9wZR
         vjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=do2FS+guK+Rgy3iLiFpD7mwkrEJUQ11ONBOFdKp/TbQ=;
        b=f8FlbXUNYkxuJ7Caz8Z9Tl+aDqHDaV33I+QNAxzwDOvBm1eDdO2ug/YXbXGbLbxzRs
         pzSxTWoPjCmecYeCtKhTTKvKHFsOoVdfZ4yGzlcswPSePVdbSykJXEYD3KRPsqvt9qv8
         NbCMzZoRUSEtukhBQ3yHI0C2fC0hXgD1euvXHvJwJcAwY4XB6LZ3qMCO1nzNs4wC1xll
         vtzsAXTPKI5tlyi/0QLVP3jqE9UkTlE50uleImJP7Il+XZBSfVFdZmHmsZa+qvvxasRj
         RrHembLu673LOApe0UDgMxR3uPK7uI/VHD57QMsjCbMjUAjUNNl6Etv7w8rX+SulbwFA
         uOvw==
X-Gm-Message-State: AGRZ1gLh/HJPFmqngM8+Kj49QtT8ssHg3rkHiz17uoENsV6Am+XLOrBA
        Ok/0OrI4wwBYgFvdsNep6PGRdKIm
X-Google-Smtp-Source: AJdET5diB44N30dw17xlb876xZrU9LZHYkCERag4nk1yF2AIP6PmVAjfV6GmGCUTdgMYy07beR0yUg==
X-Received: by 2002:ac8:3693:: with SMTP id a19-v6mr3668467qtc.236.1540408332633;
        Wed, 24 Oct 2018 12:12:12 -0700 (PDT)
Received: from ?IPv6:2001:470:1d:7b6::245? ([2001:470:1d:7b6::245])
        by smtp.googlemail.com with ESMTPSA id h49-v6sm4430902qth.32.2018.10.24.12.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 12:12:11 -0700 (PDT)
Subject: Re: ath9k driver may be broken on ARM64 ?
From:   Ellie Revves <ellierevves@gmail.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
Message-ID: <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
Date:   Wed, 24 Oct 2018 15:13:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
well I enabled CONFIG_ATH_DEBUG and booted this kernel, sorry for the 
mess of escape sequence but I captured via serial console:
http://ix.io/1pWI
I don't see anything different even if I cranked up ath9k.debug= to the 
*any* value. I guess this thing happens so early at boot that nothing 
useful is yet initialized...
Thanks

Ellie Revves a écrit :
> Hi,
> sure, I enabled atheros wireless debugging in my kernel and am 
> rebuilding it. After this is done, should I set ath9k.debug= on the 
> cmdline ? It is built as module, but my filesystem is read-only so no 
> modprobe.d snippet can be added.
> Thanks
>
> Tom Psyborg a écrit :
>> Hi
>>
>> There was similar issue reported in forum recently:
>> https://forum.openwrt.org/t/wireless-card-atheros-ar9565/23608
>>
>> Could you enable ath9k debug and post output?
>

