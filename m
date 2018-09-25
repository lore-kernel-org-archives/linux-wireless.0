Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E975BC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A191920C0A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 09:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZRR9yq0m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A191920C0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbeIYQA1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 12:00:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40495 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbeIYQAZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 12:00:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id n31-v6so4263348pgm.7
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 02:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=FqqzYDCMWwwwb9oZ7hF8oS5tzRSrxTybuH34jfGNzZE=;
        b=ZRR9yq0mCrvncCqdwD/VpvUrzzJ5iUXoXj96+Rcy7cCdGi0WQ4LWlI9yXaFLuCdZ+3
         y4Av1qZS3s/i/k81QoO6nV/yl697UX7GK0Zjt+ocFXA4aTi4IxfCIcwAGjg7pv3AIjSA
         hZEqcUhEUcbBZYar737j9ee7UX4kRfO+vRKpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=FqqzYDCMWwwwb9oZ7hF8oS5tzRSrxTybuH34jfGNzZE=;
        b=muig3FMq+qzjCjGWFJ+U3wBJmaXgqLXREI3UWovVwykhN1imLSzTyUuz+m5gJCsasN
         mbMy+psdNly4ImmnHkqUKGLRttmd94n6Z1hHpJ8bco5+krgNP4Lt/Xoq/xFOOMUO3Rah
         NihAdCL9hmA1jf4YttcW68uJgC2JzquQU6ZNJkZTxmcCXZGwj8rpUiFSq7WHjVPVCh07
         Zv1frI5OSwi99Pjtv3gOekU8V24KM/LWm4tTGtztSpLiJLrTYfJX4MWME+kBwk5KDKi+
         iDXQHwX6TTcthrLL/Ays0Nov+B/SK+VMhUq4sJ5WzHimn6GZntnM68vjrAOfhu3bj+MH
         BPxg==
X-Gm-Message-State: ABuFfohm5I3pwlnfOTWKoIi2dgJJJERbQ469xBm+ws7RtvwBqTfIyZGB
        v6NtBruu7LN2uIVu6xNhTRmdMQ==
X-Google-Smtp-Source: ACcGV63S11Efmqvv2KcPmFT6qiQRhbJXHjEWt5e4vccjPMkSInnGash6ZS+CuEgIxBdP/J1jd7JPZg==
X-Received: by 2002:a63:ef4f:: with SMTP id c15-v6mr268980pgk.368.1537869220737;
        Tue, 25 Sep 2018 02:53:40 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id u65-v6sm1046117pfb.144.2018.09.25.02.53.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Sep 2018 02:53:39 -0700 (PDT)
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
To:     Enrique Giraldo <hgiraldos@gmail.com>
References: <20180925081933.28553-1-enrique.giraldo@galgus.net>
 <57143da1-1569-bd98-70e9-91cdcd89d1b8@broadcom.com>
 <CAEbaMQ+N=hUwXta9NbrBpF3YcoCyUNWB=s3cynp4pzFLuFrmDA@mail.gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Enrique Giraldo <enrique.giraldo@galgus.net>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1ff1f335-6962-4ace-6b25-562dab939893@broadcom.com>
Date:   Tue, 25 Sep 2018 11:53:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAEbaMQ+N=hUwXta9NbrBpF3YcoCyUNWB=s3cynp4pzFLuFrmDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/25/2018 11:28 AM, Enrique Giraldo wrote:
> The main reason is to be able to stop the CAC when you want to make a
> channel switch and the CAC is ongoing. It's true that the radio would
> not pass to the next phase, the behavior is the same as when during
> the CAC a radar event is detected. In the case of aborting, a later
> action is expected, for example, switch to the desired new channel.

So for mac80211 the function ieee80211_dfs_cancel_cac() indeed seems to 
just abort. So what is the scenario here? If user-space sends 
NL80211_CMD_START_AP with DFS channel, a CAC period is started. So you 
are saying you want to do a channel switch? Does it not make sense to 
issue a NL80211_CMD_STOP_AP and then NL80211_CMD_START_AP for the 
desired channel? Maybe the use-case you are looking at is not AP mode, 
but there is no context whatsoever in the commit message so I can only 
guess.

Regards,
Arend

