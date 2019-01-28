Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72416C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A9F2214DA
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfA1UuI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:50:08 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37108 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfA1UuI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 15:50:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id g67so15421575wmd.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 12:50:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iRBwIgSU/Oih1xqff541idlqlEW6C07coHCmDhwiiQQ=;
        b=NxohyrkdyUedsYN6/qFRJpb1XJFu2McIrcobJm0acrqlyTmIX9imqyyYIn2PXXFXfS
         4bfZZ5nJeDFLWoVYEVsbhzyA9iO9qeRA8/Az/5FtLpnFZUNEwbRZXme3insKyVbJCSc+
         4pqTIKDwT+h6VM9FR3KKvZJjKF54TNhjKOJ07kBSvL6hHesE617EK6UkX5eiMdBiowJo
         1BzZFGaFju1fzXR/taBlUoS2t3pfJ5EJEWVk6wdve0dsMj4DuZKZJUhURGlhkGHwSRdU
         +YXk6XyjEZE8RpAY2sPF/9YXTOR8V+WOiaypx3dF6jpyDlnNg000+Dk7fYATn6YIZaOi
         zsBw==
X-Gm-Message-State: AJcUukclAvI9/tcFWHtt5YgN8hYLJTjE21nokAHIfeLxp/QE5xubqQej
        srIKpecI96PzPcM9+BFKqnsQxQ==
X-Google-Smtp-Source: ALg8bN6tX6ypK2Rrq7CUFVAboYnim43EMGF1qsa6UpCWb1+xtfBfhou7mlX/jV+BSXZSC7JgZA/2zw==
X-Received: by 2002:a1c:384:: with SMTP id 126mr18378927wmd.26.1548708606340;
        Mon, 28 Jan 2019 12:50:06 -0800 (PST)
Received: from localhost.localdomain ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id a62sm309611wmf.47.2019.01.28.12.50.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jan 2019 12:50:05 -0800 (PST)
Date:   Mon, 28 Jan 2019 21:50:03 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map
 in mt76x0_get_power_info
Message-ID: <20190128205002.GA2165@localhost.localdomain>
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
 <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
 <87tvhstujr.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvhstujr.fsf@purkki.adurom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> > Report correct eeprom per channel power value.
> > Fix chan_vs_power map in mt76x0_get_power_info routine
> >
> > Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> 
> So what's the actual bug this fixes? The commit log is not really clear
> on that. Wondering because you marked this for wireless-drivers.

Hi Kalle,

You are right, I have been not so clear in the commit log.
Offsets in chan_map were wrong since mt76x02_eeprom_get() reads at even addresses.
Moreover 'if' condition in the for loop was wrong (chan->hw_value and
chan_map[i].chan were swapped)

Regards,
Lorenzo

> 
> -- 
> Kalle Valo
