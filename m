Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95715C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 14:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649B920880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 14:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfA1Obl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:31:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38178 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfA1Obl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 09:31:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id v13so18261660wrw.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 06:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p1SwNz+YIIjl8bgDq0z3omXhZlPBsURfzFojB1fGUuM=;
        b=rXA8tY2Cw4HozHpqSWe+vTdJAYVblVZ9psvOlepF49IwLLEIKnWP6m8XXv1M0K2oCK
         CEwsCb1iOBdMe26noapKSSHgcXSOnLohyBCq8da06xwYls364OIj7Fk7b6has3NRHs9A
         vvayCNK3/BAg6Gt2iRUyfJdE6nTyc5vQSF/xpjkhk/4w8WSgWzMgMjepSapG1f1JYxsD
         5KQfKElMzprekMHBIu2VcqaeFGHmEOOlRP7WECEmxPd8SRm+s/Y+7dXF0+Vg7wuWwI1c
         eZc2hUPitiB50xrmuKuiLRm2pLgiWj4VhiSWcqygt5359PpHpiaHWBGyMngxn1Z94PRo
         iRtA==
X-Gm-Message-State: AJcUukfFxmmjl167XRG19ZjYycVGuIuaDSiHtuFvrPq0ft00AWMc/EhZ
        oyOMRD8HSSOVylGSb4+7tNJhgA+0QgOcVw==
X-Google-Smtp-Source: ALg8bN4kfFc4tzW9HrigKA61fqLAEluR80z5rVBNzO9n2iDsmDz4gJzAAKYYlTWVy+ohzVNWJR3gBg==
X-Received: by 2002:adf:ef50:: with SMTP id c16mr21977226wrp.198.1548685899469;
        Mon, 28 Jan 2019 06:31:39 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k19sm193936406wre.5.2019.01.28.06.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jan 2019 06:31:38 -0800 (PST)
Date:   Mon, 28 Jan 2019 15:31:36 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mt76x02: use mask for vifs
Message-ID: <20190128143130.GA20291@localhost.localdomain>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <1548678108-9526-2-git-send-email-sgruszka@redhat.com>
 <20190128133537.GB9257@localhost.localdomain>
 <20190128142357.GA9571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128142357.GA9571@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Mon, Jan 28, 2019 at 02:35:39PM +0100, Lorenzo Bianconi wrote:
> > >  
> > 
> > Maybe we shoud grub dev->mt76.mutex here, since we can have multiple processes trying
> > to add an interface
> 
> Interface creation and deletion are protected by rtnl_lock(), can not
> be performed concurrently.

Yes, right :)
