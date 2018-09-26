Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960C6C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 22:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 417CD21536
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 22:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rd+ZlOKr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 417CD21536
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbeI0EmA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 00:42:00 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44049 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeI0EmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 00:42:00 -0400
Received: by mail-pf1-f176.google.com with SMTP id k21-v6so331789pff.11
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2018 15:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VZRcSs8UDVSkdNIhJ31NOvnLRzLJSrMpk/zz+HjqpGU=;
        b=rd+ZlOKro1+2xPjJxNLt/tQctfRFwLE+GgjKCRJGoPDQAt8T5E+Du0wiBrbK3Dt/XB
         RkRDl9EkAfEap+AY9EdpOWrAoIil/c7Vryo2Xh4ZT9LVifq0lWR+EbNM5fc7TiVeEkZc
         kiy+Bp55wap9+SKJBG5zLvrsdaU3LxHmacZyUcz3+OJ+eiJNrI2o631iAnMuEJsBDaOb
         WPhz2lnGFkCzFg8M12itB7zwpB+LVkPAZN9bamO9QGe/96LpGaV081PUTB6hdW8cbC7A
         TuinNuPF4UPoUgudg0Trvh3+iYa8zk41ZrPi/kLd4En/COxt9fJywFyMsLi7mcTNaY3d
         Ihew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZRcSs8UDVSkdNIhJ31NOvnLRzLJSrMpk/zz+HjqpGU=;
        b=TcFjIzvc+zmuJh2DSc1wX6Ezec+FSGxSzVrF3MErRS0T39AquAdSGkPbFLpVAsRWAL
         bLRIL5QiQMM3fozHnr9JnFB9u0lNqKS/hIVuW6y16aftW5/3MDd7dX9ml1GuEyOkZtor
         5aNMPMFb0N9ILS5Fb5x6mBjunyjRzeFzTxuCMz36uhT9mJYOPbSR6WtK3UbTlilZ+1NO
         pQIqCV7lXx7tMEyfFiZ2TQyIxD6ACn7jN7YdQ3H4Hg3uLQYHDIo1pC2lzmjjSR85uOmn
         tHbdQzizwKt/dL2voJbE2C/lR8LwJATS/37jaKnQbEe1V3FYyBUFxlLTststAIfGory1
         XjRQ==
X-Gm-Message-State: ABuFfoj0zjn/HYmZr0NmkaE4Ka1Gy8tjpQ39qXTiTHtB+rh/KqJMaZD9
        mRUrtQkBHTrQMPNfytmYR78zuUH7
X-Google-Smtp-Source: ACcGV61xJ7YXIxfjypo7nzXoE3dKtg1eKPB4a0QI82j3igAIJ1LJuOpMUlYvVPR4sxxZP6JLKikMvg==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3-v6mr7839860plo.218.1538000811678;
        Wed, 26 Sep 2018 15:26:51 -0700 (PDT)
Received: from ?IPv6:2409:11:321:2100:1d3f:bc30:da12:639? ([2409:11:321:2100:1d3f:bc30:da12:639])
        by smtp.gmail.com with ESMTPSA id 3-v6sm223816pfq.10.2018.09.26.15.26.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Sep 2018 15:26:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] nl80211: Fix possible Spectre-v1 for CQM RSSI
 thresholds
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
 <1537841701-3092-2-git-send-email-masashi.honma@gmail.com>
 <1537953785.28767.7.camel@sipsolutions.net>
From:   Masashi Honma <masashi.honma@gmail.com>
Message-ID: <26b99a9d-85c1-ea9a-cb9e-0dc7bf9eb467@gmail.com>
Date:   Thu, 27 Sep 2018 07:26:48 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1537953785.28767.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018/09/26 18:23, Johannes Berg wrote:> I applied the first patch in 
the seies, but I don't understand why this
> patch should be necessary.
> 
> The value of i isn't controlled by the user, so it shouldn't need to be
> sanitized?
> 
> The context was *just* missing, added by me:
> 
>          for (i = 0; i < n; i++)
>>   		if (last < wdev->cqm_config->rssi_thresholds[i])
>>   			break;
> 
> This loop determines i, and the user doesn't even control "last", but
> even if they did, the possible values of i could only end up being in
> the range 0..n-1, so no problems?

The variable i could be n after the loop when this condition is not 
satisfied for all rssi_thresholds[i].

 >>   		if (last < wdev->cqm_config->rssi_thresholds[i])
 >>   			break;

And user could control rssi_thresholds[i] by using 
NL80211_ATTR_CQM_RSSI_THOLD.

For example, I could set 4 rssi_thresholds -400, -300, -200, -100.
And then last is -34. I could get i = n = 4 after the loop.

Regards,
Masashi Honma.


