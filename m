Return-Path: <SRS0=IRMg=4F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A12AC34021
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Feb 2020 17:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4B3214D8
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Feb 2020 17:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBcUGkk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgBQREW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:04:22 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:33075 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgBQREV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Feb 2020 12:04:21 -0500
Received: by mail-ot1-f45.google.com with SMTP id w6so7556788otk.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2020 09:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:references:to:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0/xxRBl7pU0HhSR7AIon3C3McZaEohoofaOPRsNAJOw=;
        b=JBcUGkk/dhq/qxb7zpmtgnC5o3aqKKTBNfGHmCtdhbxqWlce3Lz2rEAXe+FNyenSQd
         +Hs1ItP6gdzzbt74THHThuFXftWLqCY6hWB7IsvBgvTwj4j2c9iYOFINPrNFzfczgFZ3
         Uy2Pn/8WKlMV6uZFlR4PYVDZfNK1EQZWtQZDey49HcG6vDS5vAi/16cpzKHoyRPX6+6y
         7AWeLUT7v0uAop/ITDVFZM0TZy3/hJMyGwV7ssdoexq7L0DWtfd4jfJC7tppvxWMWaLP
         TGYZDcNnSK3iWDRkLxVWtij1tYYIjUy7TJ8BY2yXxMAya//YEGOESXoRyM+SYyrO9O8D
         7vwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:references:to:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0/xxRBl7pU0HhSR7AIon3C3McZaEohoofaOPRsNAJOw=;
        b=rm3B7yXGlY7v0aWZeW4/JGpXtTPyCSjywWPedgw5PEqP3s+28g42NhzL3drUGeLoE6
         CcXX7ZZsnOsIgIonIZdMDdsh3ApJhVDMUwN5Jd4TCSNjBJoR+ezLCwyhrURWexrmNID8
         ryjK//dtbXbt2Km6OZ/BPE1k+ZjRW6l/NTz3gLFCJnwSAPkYRIHaN7PqoicpCrIsKw79
         /PGlgJJNAZmxnqGeCdYkrRvjCN4wNRbNv2OQyFnlmPSf0kqcLNLJ+mcbOz1dFCE0XCKq
         GMFUIIIN0BiS9mP17n0w9HlDHrVToU/3hc1tzgRmg01s0NTZu43E9B/bviUGbr4LN8XP
         m+Uw==
X-Gm-Message-State: APjAAAUW+cTHA0GPODrmBQbb2Jr7DKeuIgOmwmQv3MIr4tNLY1bqYJKf
        dokFLLb8y5XGxgrZ0oL48ZhzsJnl
X-Google-Smtp-Source: APXvYqzviLHEiBOZXGxVStmXRzhpdOHxH8vXRT8LYhk7lmp1unCj2OqU9yoMxE8ehP0MFkS/jAKRSw==
X-Received: by 2002:a9d:545:: with SMTP id 63mr13291966otw.285.1581959059617;
        Mon, 17 Feb 2020 09:04:19 -0800 (PST)
Received: from [192.168.1.120] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id r23sm291223oij.38.2020.02.17.09.04.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:04:19 -0800 (PST)
Subject: Fwd: Re: [torvalds/linux] rtlwifi: rtl8188ee: Remove local
 configuration variable (d1d1a96)
References: <torvalds/linux/commit/d1d1a96bdb4408d02e2bfcb32b71aba165458a80/37332689@github.com>
To:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
X-Forwarded-Message-Id: <torvalds/linux/commit/d1d1a96bdb4408d02e2bfcb32b71aba165458a80/37332689@github.com>
Message-ID: <ce9385fe-69a7-dd46-eb57-e272262f52c6@lwfinger.net>
Date:   Mon, 17 Feb 2020 11:04:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <torvalds/linux/commit/d1d1a96bdb4408d02e2bfcb32b71aba165458a80/37332689@github.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org




-------- Forwarded Message --------
Subject: 	Re: [torvalds/linux] rtlwifi: rtl8188ee: Remove local configuration 
variable (d1d1a96)
Date: 	Mon, 17 Feb 2020 15:12:57 +0000 (UTC)
From: 	ashish-yadav11 <notifications@github.com>
Reply-To: 	torvalds/linux 
<reply+AA6SEZMYZ2I4LECYN5DENHF4K7P7REVBMPHAEONG2E@reply.github.com>
To: 	torvalds/linux <linux@noreply.github.com>
CC: 	lwfinger <Larry.Finger@lwfinger.net>, Author <author@noreply.github.com>



This commit causes problems when connecting to institute's public wifi. I am not 
able to connect to that wifi after this commit. Reverting this module to 
previous version in latest kernel solves the issue. So the problem is with this 
commit.
The journalctl output is at http://ix.io/28IX <url>.

—
You are receiving this because you authored the thread.
Reply to this email directly, view it on GitHub 
<https://github.com/torvalds/linux/commit/d1d1a96bdb4408d02e2bfcb32b71aba165458a80?email_source=notifications&email_token=AA6SEZKQB4G2KKKXUWRHCJDRDKSPRA5CNFSM4KWTSC52YY3PNVWWK3TUL52HS4DFVVBW63LNNF2EG33NNVSW45FKMNXW23LFNZ2F62LEZYBDTJWR#commitcomment-37332689>, 
or unsubscribe 
<https://github.com/notifications/unsubscribe-auth/AA6SEZIGALWUGXRCN7ALTIDRDKSPRANCNFSM4KWTSC5Q>.

