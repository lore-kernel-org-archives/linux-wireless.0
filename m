Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2AAC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 02:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4987C20663
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 02:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="VxvluLes"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfDECo2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 22:44:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37966 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfDECo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 22:44:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id j26so2240830pgl.5
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 19:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JjSuo4+/1aISrciotapkBKKYAwC3BKgONv/FY7AlO84=;
        b=VxvluLessmeBrnMLWfS7iBMcw+6If1Ar+/Rhhvgu6iklj7DBjBuYszqHFnnG4xsSLy
         U8D1v4FE+i/vkf+AFzJYBOprhi4X8L+rqo1AFo7/qLTgIudAqM17a/pknCqvsOQ+LPIz
         XD88PFhXX0XeiQIOCbh/TVEDF05D+LYQzi2+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjSuo4+/1aISrciotapkBKKYAwC3BKgONv/FY7AlO84=;
        b=rOFi1bKz30RUBpHm3cUvHN+RuZzefCSMxz04RntZnjA3ru1G87XL0ZeHIjZ0jra5eA
         AXAS+j2u0EJ+v/kSlbKTPnMShm0B4nQGu8giFsnrmOK12b6yOkilv7dB6fD/EmJyA1kS
         r3QawxajJ+frj3AXcqYTAKJHRBcoiuByHly6lY3hhaQjP5YPx58yC4zOtga5w1W6eFlI
         8PhgMLACW/RvtWKnKZ0z3Rujh+6JrjbbPV4tlwLX6jRvL7wWtvlvIN4NtcnDrbGcqCSg
         Txa0HUKodKH/VfuUk2uoPKq/PYFQB3Y6whYt5LZLVKac0v+Il1t/5Cu/02hA44FAG8YU
         +NaA==
X-Gm-Message-State: APjAAAXcYd/LPnshHL0Q5W6347PJJu9S0lCNUCEFwnp3K8Xqrd7867CL
        OiU4Zss8NcSv0Xx80NbV5NxmQg==
X-Google-Smtp-Source: APXvYqwKfzt6zhERZnnwl3DaxODPNZbl6VTt2RjTbLUInv+OuDdxO1UpnvuKfwQM1jSW75v4JQvnCw==
X-Received: by 2002:a62:41dc:: with SMTP id g89mr9758934pfd.109.1554432267127;
        Thu, 04 Apr 2019 19:44:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c5a1:6d6:d92c:c7c1? ([2601:282:800:fd80:c5a1:6d6:d92c:c7c1])
        by smtp.googlemail.com with ESMTPSA id v1sm31176688pff.81.2019.04.04.19.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 19:44:26 -0700 (PDT)
Subject: Re: [PATCH 0/6] stricter netlink validation
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
References: <20190404065408.5864-1-johannes@sipsolutions.net>
 <20190404.102850.631122626573856353.davem@davemloft.net>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <db599b6b-94a5-3123-5613-9e349fcee702@cumulusnetworks.com>
Date:   Thu, 4 Apr 2019 20:44:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190404.102850.631122626573856353.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/4/19 11:28 AM, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu,  4 Apr 2019 08:54:02 +0200
> 
>> Here's a version that has passed build testing ;-)
> 
> :-)
> 
> I really like the approach taken here, and done in such a way that
> new attributes added get strict checking by default.
> 
> I'll let David Ahern et al. have time to review this.
> 

Hit a compile issue right out of the gate:

$ make O=kbuild/perf -j 24 -s
/home/dsa/kernel-2.git/net/openvswitch/flow_netlink.c: In function
‘validate_and_copy_check_pkt_len’:
/home/dsa/kernel-2.git/net/openvswitch/flow_netlink.c:2887:8: error:
implicit declaration of function ‘nla_parse_deprecated_strict’
[-Werror=implicit-function-declaration]
  err = nla_parse_deprecated_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~

You should do an allmodconfig build to check for any others. I disabled
ovs to continue.
