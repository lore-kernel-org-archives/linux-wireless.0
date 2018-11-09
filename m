Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4A6C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ACCA20818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ACCA20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbeKJCdG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:33:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39406 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbeKJCdG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 21:33:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id b13so2577193wrx.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 08:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QKWa0o10pm95PqR25nynCfV7NX0C3zvww5dkxCKjjcs=;
        b=c/0rUUE3weuVYI+NZno60s9t8hRaugFJmGs5q1XfPqDxKLxX2xF3vjGdRR7q282T7k
         J0YvKdTXgkolnJD2qUA3sguiinen3FDhpoSzz8Tqak/rRoao+HLV0R1ouE9LU4t4QH5y
         iFSuD6evv7rpBscbTJSb5K1U1yhz9DSX0EExg57Ge9A/lOW59UOtMXnU1DSsfZTw7RUD
         aVpxZNKPYOOHfMovhnma3OKsXswsNzPUFlvegaerZkspLRwMxGHXdepurUl4CwE73+Ow
         3Ac4v9lSjcwMoT8TdV2bKbYLOxS1de+1qpU2wbt8whzOkXM3e5ofvdD4JwMDO9Nk3rmw
         k7Sw==
X-Gm-Message-State: AGRZ1gJesr3vSueFZhiyDsYTZebwaLk72i2yHvG2TWFDG7F47FsofqpS
        MEHn4k0S7Zb7rmDGfxJdtRKs/A==
X-Google-Smtp-Source: AJdET5eODuhH7GLF5mdG4mfe+/8Btfh/8Z6u5C1VG1yUGBkNd4imYZEJO1nVPVfGOUJmuaJhcs6tCQ==
X-Received: by 2002:adf:aa05:: with SMTP id p5-v6mr9390622wrd.56.1541782301077;
        Fri, 09 Nov 2018 08:51:41 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a3-v6sm1308404wmb.28.2018.11.09.08.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 08:51:40 -0800 (PST)
Date:   Fri, 9 Nov 2018 17:51:36 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Message-ID: <20181109165135.GE9453@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
 <20181109112651.GF4174@localhost.localdomain>
 <20181109131028.GA8054@redhat.com>
 <20181109133130.GA9453@localhost.localdomain>
 <20181109162507.GA2124@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109162507.GA2124@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Fri, Nov 09, 2018 at 02:31:31PM +0100, Lorenzo Bianconi wrote:
> > > 
> > > Anyway I think, to support MAC address change, we should not filter
> > > based on MAC address, but maybe only on BSSID ? 
> > > 
> > > Thanks
> > > Stanislaw
> > 
> > You can create the interface with a given mac address
> > 
> > # iw phy phy0 interface add wlp0s4u1 type managed addr 00:11:22:33:44:55
> 
> I realized I have ancient version of iw :-)
> 
> Ok, so to do not break that we can add it to common function like this:
> 
> +	if (vif->type == NL80211_IFTYPE_STATION) {
> +		if (idx == 0)
> +			mt76x02_mac_init_mbss(dev, vif->addr);
>  		idx += 8;
> +	}
> 
> Thanks
> Stanislaw
>  

Does this patch break AP + STA configuration (since we are changing MT_MAC_ADDR_DW{0,1}
regs with a possible complete different value)? I think (but not 100% sure)
MT_MAC_ADDR_DW is linked to BSSID used.
Maybe it is safer to maintain mt76x2u_add_interface routine since it is just a static
function used in mt76x2u module

Regards,
Lorenzo
