Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF78C67839
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 12:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91DB820892
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 12:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INktc85l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91DB820892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbeLNMCR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 07:02:17 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42893 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbeLNMCQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 07:02:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so2617018pga.9;
        Fri, 14 Dec 2018 04:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=FhKdt2f+1+SIgo3NtqA2vhu03CpUkR10GIFfzT1l3X4=;
        b=INktc85lLRELKIC6YQ94kelkrwkBl8UGTD2igcFGoAVxx+ehYJbisI0VGZjU2Ke1SC
         yCjvplDZUX85a4jgx0WD8zN41rS7ORr+yAFNzvXqho/3cxi71hXIu69dEjWKWXSg9a/Y
         qosOOusFXP3wc7dWhg0inKKCExpppDRNkpKGhWCpTM7UbPRTH39pZN9YQjrkGQoCZE95
         K7NqkflPh8LZbNWcsAsW0GLYWtqtRb6dSLu9+ODLFZNXTQhXk4PwG5Yu2CssOsH3LquB
         z7TXlrnHFWvEgyDwfr/ox1RMyvXo9L6oSEekeEQMQB84vb9uPl4cN/F3hhLcYfV0v4ng
         aaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FhKdt2f+1+SIgo3NtqA2vhu03CpUkR10GIFfzT1l3X4=;
        b=F6qiWQjqqyWp8MPPBepGlNgwXuP6TEdkzPaI6n2nv5I9E0dvcnpMsYVtlLEwgU/XKJ
         ix7Wc6XPfjd9svB7rFXACsl+emHwQPzZKDNbKMKRj4evfLnoHhmZZSi1ZJsVtSuEHI7K
         crhifTJPH46LO/axAeTXtz/dE+YNPzJEj/CINqkFHadmPwvKktAeXY6nVpXjgjygA4Hq
         77VF/BRZ5CLnpipZeQBq9RbJbD0TM71vXD3BzqoPaNSWF981bueFbSdKQ4hWJDtFwxvq
         L+rtpP9EnydrNRqdZDT0eGKpv2MeNainP+k33NTre9ihUPVihACe0BmZ5dpx49n6JMrO
         vqoA==
X-Gm-Message-State: AA+aEWYEGgh0R5jbrUNxRCtcD7OVRZK4rw8asXNrGj02fE+DxftxMhzj
        268eJFsPZZesSejthAoVVWN0HJIK
X-Google-Smtp-Source: AFSGD/VXUpTgeqfK4XQ2zlbYzmgZKx7FW8+2ghhahtJ7kLFLqOSlCLEWVrMuMn/NJ7yZlBXVwNPdsQ==
X-Received: by 2002:a63:990a:: with SMTP id d10mr2450563pge.279.1544788935468;
        Fri, 14 Dec 2018 04:02:15 -0800 (PST)
Received: from bars (ip-195-182-157-78.clients.cmk.ru. [195.182.157.78])
        by smtp.gmail.com with ESMTPSA id f67sm13605818pff.29.2018.12.14.04.02.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Dec 2018 04:02:14 -0800 (PST)
Date:   Fri, 14 Dec 2018 15:02:10 +0300
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        sergey.matyukevich.os@quantenna.com
Subject: question: ip forwarding and fq/mq qdisc
Message-ID: <20181214120210.kmeuwvajuiwlp2n7@bars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

I have been running 4.18-rc8 kernel with enabled IP forwarding between
wired and wireless interfaces, where both interfaces
were configured as fq qdisc.

However after moving to 4.20-rc1 kernel the same configuration does not
work anymore: pass-through packets are not forwarded in both directions.
Forwarding starts working again only if I change qdisc of _both_ interfaces
to anything but fq/mq. For instance any combination of pfifo/fq_codel/noqueue
works fine.

Does it look like a regression or it is a known change in behavior ?

Regards,
Sergey
