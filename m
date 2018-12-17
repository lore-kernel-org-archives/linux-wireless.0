Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E43BC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 20:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D447F2133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545079041;
	bh=nEIVcVp0GKSt1euESVeBbhccK25CghezVDeoynfvJZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mpePRcS5LWGcQ0CvtkpKwi3+xB61kPaGFee8mbUvyDchnpnsIIkLmWocm6ulmg5lr
	 ngnrDYD37d7MgU79PD74U38HWWISKEWb6Wtn/LrHDNgfXNT4X0jdX6kmWJQTe2lDec
	 6wLPIDl4Zbd1KZY4U50UuK5DmuFHG/nkpwhUCjpk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbeLQUhV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 15:37:21 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38823 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbeLQUhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 15:37:20 -0500
Received: by mail-oi1-f196.google.com with SMTP id a77so121619oii.5;
        Mon, 17 Dec 2018 12:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xkHZO+8JOYXGCJn7lk+mJbGHkZ+eqSkUMAKxLyk5IfY=;
        b=FMWnHt8i0EeLdyYCqodIF0saTfsF2I9W6uGN3k0NupmV6NWO8cb97ut3d+xVfzfBke
         T3D8wHEnHchP9bnD3egnkPTf2io0gcT6qZmqg0SdwWC+hCPsmefwBfpGC591IAa2CFxB
         szNXxQ5yoQ3il6XpC1828teGgkCmQpZri88sY1qbFO0VD100GAw6AkZxxgO42IHE3YWu
         0qAlLm6S55syGadpywVRanz8ekYctrf6ES2Mn3txDfQBvdHOLu7w9WClQ0TA/XVn9Pze
         okX75XyAaMwI9+lBXKMehvM9xT+NGC18bxNYUntJSPPhsvKht6p4alDP4maiu5VJxWXj
         BEXA==
X-Gm-Message-State: AA+aEWaaEL7szDUeBxF7OFK99RnzEOOriJkAUCo1GVZCT3+xbcYT8yM7
        eO72cimcELmmvBnzv8oOeA==
X-Google-Smtp-Source: AFSGD/WImBsXdVeOT0eywXxj2K3QLWfA/zNqqygObH0QywL5DtoeEdvTRHWqC5Geyoim/Clmx2vW+A==
X-Received: by 2002:aca:7c5:: with SMTP id 188mr5868142oih.313.1545079039595;
        Mon, 17 Dec 2018 12:37:19 -0800 (PST)
Received: from localhost (cpe-70-114-214-127.austin.res.rr.com. [70.114.214.127])
        by smtp.gmail.com with ESMTPSA id q25sm7917453otg.70.2018.12.17.12.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Dec 2018 12:37:18 -0800 (PST)
Date:   Mon, 17 Dec 2018 14:37:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] dt-bindings: net: ath10k: add new dt entry to
 identify external FEM
Message-ID: <20181217203718.GA29320@bogus>
References: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
 <1544544804-4039-3-git-send-email-bperumal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544544804-4039-3-git-send-email-bperumal@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 09:43:23PM +0530, Bhagavathi Perumal S wrote:
> This adds new dt entry ext-fem-name, it is used by ath10k driver
> to select correct timing parameters and configure it in target wifi hardware.
> The Front End Module(FEM) normally includes tx power amplifier(PA) and
> rx low noise amplifier(LNA). The default timing parameters like tx end to
> PA off timing values were fine tuned for internal FEM used in reference
> design. And these timing values can not be same if ODM modifies hardware
> design with different external FEM. This DT entry helps to choose correct
> timing values in driver if different external FEM hardware used.
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Please add acks/reviewed-bys when posting new versions.
