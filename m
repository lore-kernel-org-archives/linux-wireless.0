Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA4C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 08:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF3A020842
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 08:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wb3XP9zp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF3A020842
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbeIYO6u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 10:58:50 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43799 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbeIYO6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 10:58:50 -0400
Received: by mail-ed1-f67.google.com with SMTP id u23so9507036edx.10
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 01:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=6sBHqwYyKQlnmU3/fKEGyx3z36LWuRqX/ENQ6M5Zpvk=;
        b=Wb3XP9zpAafkRd/DeEIQdPWdiF6LahRU2iEgC01nPNKYaob/HNosaauOKtVioZ14Q1
         bW7eUFqBt8DHcf61/oVJthoaZGBnwZAeuAuJNbwdwmgTls9bUH1YiriL3N2kxWDas+1e
         ijZSw1iSDnzPaE2n6ZLWJvawZvX8Ki24yU/cU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=6sBHqwYyKQlnmU3/fKEGyx3z36LWuRqX/ENQ6M5Zpvk=;
        b=jnmG+X83JgOlVhLnGJnkX5L3YqdConiSI4ILXXttHukolan38aVLQ3YWd6vgGcUJq9
         3Z5cHU2IQRFJNuqXGxy+3gueKHvqo55gIRj4m489foFQF9jMCkDUKs6nL/+n9kAACx+h
         um8nEIgvAbeGjTU7VZ5A/JYdtf4gzfuNGAFXYcpXj50PfMPbtpjNrnBICKGNkmn2wGLL
         4Mu+jbekMC69KBOfUHmQjnwZC4fBvKNqgNqs6IiGvtwQ2KN4vM8ZeavtuQOrQd3a3lQa
         lZY6KYNv4M1fE2DMZPrcXeOgErQ9uQlffZzRQUN2bCCoSi/BfEZL8PuqHO55POLaYXyp
         4/Eg==
X-Gm-Message-State: ABuFfoiUbq+nTNk/YBOJhyGHYJd6EBFrU84kVMe7V4MrzbaXtArKhzlY
        P/ckFIFPrvs8HlYm0HGwyuHzMg==
X-Google-Smtp-Source: ACcGV63ucoOqfRdK8kwfxFcuJTfKlXUEAHhxNlCa3c1QozJXu6DXBfFhCORzDmb3ietJDyaYYwDzKw==
X-Received: by 2002:a50:b266:: with SMTP id o93-v6mr9497868edd.173.1537865539654;
        Tue, 25 Sep 2018 01:52:19 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id c16-v6sm566436eds.97.2018.09.25.01.52.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Sep 2018 01:52:18 -0700 (PDT)
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
To:     Enrique Giraldo <hgiraldos@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20180925081933.28553-1-enrique.giraldo@galgus.net>
Cc:     Enrique Giraldo <enrique.giraldo@galgus.net>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57143da1-1569-bd98-70e9-91cdcd89d1b8@broadcom.com>
Date:   Tue, 25 Sep 2018 10:52:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20180925081933.28553-1-enrique.giraldo@galgus.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/25/2018 10:19 AM, Enrique Giraldo wrote:
> Add NL80211_CMD_ABORT_CAC to the nl80211 interface.

This one really needs a good motivation. The CAC duration is a hard 
requirement so aborting it means that the radio can not proceed to the 
next phase. You really need to describe your reasoning for wanting this 
in the commit message.

Regards,
Arend
