Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5357FC32789
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 02:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1308F2086C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 02:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hJDqXTJc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1308F2086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389154AbeKGM1E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 07:27:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33887 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730924AbeKGM1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 07:27:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id f12-v6so5994359plo.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 18:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JDBABfvGh5QfFeL/Z4YBEQhp+gZb3KxsfMOpONFJTwY=;
        b=hJDqXTJcicek0ptyrDEYRpTh/PhukBIBNIe+ZdDSzj680ckAnk2XPz5ytfs7W0toFI
         PD1kShdGiSYfMEbg+hDO3EMniXKzn/zjnFrXn0/eVaAwI3d1XJoRuXoPIGHm0xmAWpW1
         gjfUh2EUngh6db/hPLpnyKIBtcAMTwhb7eo90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JDBABfvGh5QfFeL/Z4YBEQhp+gZb3KxsfMOpONFJTwY=;
        b=Ayz+iRtXa2+9ACYTgUfBk8mBELOD0Q8vT3SHL4OmJKxVpWMXcd5/hCoNBtTBaVojBH
         ZpnGkgYayBdlkzkomABOdr5ETvjm8QOgnLRU+NynBCyPNKHynhrtCeC70BLGjcGuvE5S
         2c+RQqwkwvHctKIC7fwq9UveYVZL76R3Fbz1AMBsQnU74T+zsXLyUnHiUz1TRfSMm+vn
         SJGR2NxQRq3HlMSH/oPbWn6LJgmX7sg3/HO2sj8kPyWprgNl+095309W4oC/HLCNKzGd
         4VuIEbhxpjXvuviZ1y6mb2vPO7QbhZ5H72IVkJLjlH1RtJwZ7AqQ+eIf4dRACdXpQhn5
         3QMg==
X-Gm-Message-State: AGRZ1gJQsVcvdDtUvSFxUS6we/tMUNcs1j6UTZ1cps4/BHqeveoqESlC
        6YTK7VG0wEmFmhgta66cHw+3zXmcTCM=
X-Google-Smtp-Source: AJdET5eEFPTvWVpwxvCpHtg2x9rrD6tgSN4yvgDROKrmyfCKW/xjDMPQkxotkTerfr9acWdoZ54R6g==
X-Received: by 2002:a17:902:1021:: with SMTP id b30-v6mr154174pla.23.1541559519578;
        Tue, 06 Nov 2018 18:58:39 -0800 (PST)
Received: from google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id z83-v6sm19006752pfi.4.2018.11.06.18.58.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 18:58:38 -0800 (PST)
Date:   Tue, 6 Nov 2018 18:58:36 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
Message-ID: <20181107025834.GA43723@google.com>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
 <153976208916.5275.15753381614937010537@swboyd.mtv.corp.google.com>
 <20181102184315.GA130458@google.com>
 <154143558212.88331.5337286842567829007@swboyd.mtv.corp.google.com>
 <20181107000655.GA53622@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107000655.GA53622@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Nov 06, 2018 at 04:07:01PM -0800, Brian Norris wrote:
> On Mon, Nov 05, 2018 at 08:33:02AM -0800, Stephen Boyd wrote:
> > And yes, from what you've told me here it would make sense to make the
> > WCN chip a subnode of this SoC node instead of a phandle connecting the
> > two.
> 
> I could begrudgingly agree with that.

...

> 
> 	wifi: wifi@18800000 {
> 		compatible = "qcom,sdm845-wifi";
> 		reg = <...>
> 		clocks = <...>
> 		vdd-0.8-cx-mx-supply = <...>
> 		... interrupts, etc. ...
> 
> 		rf { // I don't know what to call this node. Suggestions
> 		     // welcome.
> 			compatible = "qcom,wcn3990-wifi";
> 			vdd-1.8-xo-supply = <...>;
> 			vdd-1.3-rfa-supply = <...>;
> 			vdd-3.3-ch0-supply = <...>;
> 		};
> 	};

By the way...I realize one reason why I've been "begrudging" on this:
the single-node binding was already reviewed and merged upstream as of
v4.18:

ae316c4cbba2 dt: bindings: add bindings for wcn3990 wifi block

It seems like a lot of needless churn to rewrite the entire binding,
only to
 * make the usage of these regulators a little clearer and
 * possibly help distinguish different variants of WCN3990 usage (e.g.,
   on different SoCs) -- I don't even know how different "WCN3990" looks
   when used on something non-SDM845.

Even if the second bullet point is important, we could fix this by a
more judicious use of 'compatible', rather than inventing whole new
nodes.

Regards,
Brian
