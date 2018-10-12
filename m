Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF84C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD7C2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aPNMUtrA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBD7C2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbeJLSTy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:19:54 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:50493 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLSTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:19:54 -0400
Received: by mail-wm1-f48.google.com with SMTP id i8-v6so11786462wmg.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ROEqMfcLMa3vgowhIXo6nHdyRZI/CQAnquV5UXSlwf4=;
        b=aPNMUtrAxIMLe1yD3UspiHjm+ltMFN0ViwvqjXsHpYgqco0WdxbdaLpWFRqKISCi4n
         2jS/I5D7z7AQw1r0eiP6TaJB8ko1MauhLuXPKHRB4mJV8pHb0JuJMuRFPPGIN9ci1ydD
         iBHv4NlcLijqv/PhTwd0/p6/wDGVKdOx3FSck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ROEqMfcLMa3vgowhIXo6nHdyRZI/CQAnquV5UXSlwf4=;
        b=uFElUVelvUK1AJV8xz/jQzAr6GYqsXbQ7XZA5fFwU41JAZO/FULEAGSqdwD5alTBXM
         CwEQKGBcVYntrznEHH+u5pzuCGm8suncjBYHwmTVaOaK3BUq2R/klj2sOzrtv+4oSPJ4
         fCFxy5VpAXM+e+mkqee4R7Z9BDsg8mcFAdPmFtW5hCP9gcu+08cVaXlZohKSUjPFyHla
         xn//IM28bOYp032ZnDZRolK9vsbtB6JSmCLywbhTA0/cnv6wsgbzmDAt4Tg2TxGOzudl
         RO4dgCY8tGiin2AgTJm8xVPX1U7CXmF6T7LNi32FSg8RvlfAR28baGzY8Ihaq+JVRunr
         Ws6Q==
X-Gm-Message-State: ABuFfojpnxprlmJSVfS5lK5WtrCXI4FbmQFcYhbpTt0EJmoMdOifDcyO
        PO8xc6CGgrHahycBxwWsIcNG5A==
X-Google-Smtp-Source: ACcGV62493Bw2Eag+mWsANVb1HSEBX3FH/yXqVu99cMHAcNYhKE9jm4XZvEN+zuSy9uDiEVQbbaxBg==
X-Received: by 2002:a1c:2ec2:: with SMTP id u185-v6mr4654350wmu.125.1539341283630;
        Fri, 12 Oct 2018 03:48:03 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 65-v6sm1285506wmm.36.2018.10.12.03.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 03:48:02 -0700 (PDT)
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20181012100827.24195-1-johannes@sipsolutions.net>
 <dc9bc6d3-6a95-3ca5-a231-14ed3e2fe302@broadcom.com>
 <1539340898.3141.11.camel@sipsolutions.net>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Franky Lin <franky.lin@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b85777ee-a654-10db-9f04-9405ce08f089@broadcom.com>
Date:   Fri, 12 Oct 2018 12:48:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1539340898.3141.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/12/2018 12:41 PM, Johannes Berg wrote:
>>> +	NL80211_ATTR_TIMEOUT,
>>> +
>> Guess you consider reuse of the TIMEOUT attribute?
> Yes, I was actually surprised we don't have one already :-)

Dito.

Arend


