Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D552C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E862077C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2E862077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbeJIQES (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 12:04:18 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:38090 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeJIQES (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 12:04:18 -0400
Received: by mail-wr1-f47.google.com with SMTP id a13-v6so870354wrt.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 01:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZOa1UH1E/nff7u9fkSdXRw3GkKV7jZgWzbSsPo3xVyE=;
        b=YDUNauVBePVK1G8VrieEath1J6qpWdESPCJlWSWHgrI4mfmYwc8CyKaWa11Wkcz9zw
         0dkubJtzBiq+SIvC4vSGr84+gjqLUILNxnk282f/xdp4Ie6JznAlHPw4gW5aCNyZ2Qvs
         m6t0Ut6ikN8UEtastCaQN/XpdJqb3RAq4bmJOiwXs9hNJu6GLApQUFO3k144kbNVsDNs
         RdlEygxjZ4ICsh+YrR9UDYXw0tGydLQukzboIMO+LClbJLAGnJe2vWAHoeC+afdnqG0x
         SEnCwy9b80TwiGk3HwkcSLD56qYD7dTQ47U11ehsk0LiS6F7jt9SMdPVTWfuZ0dDBhAy
         K3ig==
X-Gm-Message-State: ABuFfohdzme+BZGGwHcTkqhFV29eh7adve+kFPfyREnYiw3IWHlts5Dm
        MAgcg9IhcleIIRCrcTObKBvxh7enPNw=
X-Google-Smtp-Source: ACcGV60TSUeK8y+E0plw7y8H8prKGpJGqDH1TEddFjRfanIcouBNlKjn/2Q5oak/uMoYLHqbauoX4A==
X-Received: by 2002:a5d:540d:: with SMTP id g13-v6mr19008368wrv.4.1539074906981;
        Tue, 09 Oct 2018 01:48:26 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e133-v6sm17224140wma.42.2018.10.09.01.48.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Oct 2018 01:48:26 -0700 (PDT)
Date:   Tue, 9 Oct 2018 10:48:21 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: phy: fix restore phase in
 mt76x0_phy_recalibrate_after_assoc
Message-ID: <20181009084820.GA16331@localhost.localdomain>
References: <cover.1539001391.git.lorenzo.bianconi@redhat.com>
 <ff6672828b7e970124a425304ad734d58133a6ff.1539001391.git.lorenzo.bianconi@redhat.com>
 <636edb3c-a2dc-306d-8ddd-8b91ebafd4f1@nbd.name>
 <20181009073545.GA21027@redhat.com>
 <a0683f63-31d6-5cd7-b375-e45d1815e0c7@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0683f63-31d6-5cd7-b375-e45d1815e0c7@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > I think is needed we do:
> > 
> > 	reg_val = mt76_rr(dev, 0x2124); 
> > 	mt76_wr(dev, 0x2124, 0xffffff7e);
> > 
> > 	CALIBRATE
> > 
> > 	mt76_wr(dev, 0x2124, reg_val);
> > 
> > so seems we have to restore orginal value after calibration.
> > 
> > Referencing as MT_BBP(IBI, 9) is obviously fine.
> Yes, that makes more sense.
> 
> - Felix

Ack, I will send v2 with proper register name.

Regards,
Lorenzo
