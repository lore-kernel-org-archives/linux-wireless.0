Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3755C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 14:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B472087F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 14:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReSvf8lO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfAGOsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:48:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37535 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfAGOsr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 09:48:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so1170240wmd.2;
        Mon, 07 Jan 2019 06:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KXKqXHgYEUwxzGo3BNl0g5sl1ukNP7c8KeS+9jPHfCY=;
        b=ReSvf8lOQxCj1dndtWSzNQFV/vZc5iG5cp0YWncVIACUC2e8Njs00QmHQzuptmuXk3
         HAfj6ISV/Z4Kiu65zgCRZjXZ3YJVo+vrvhcO3oB74pc+kWiwJmWOh6CF7Ukk6dOJxB4p
         /mSbTf1kw9YQpjoaUUvN7cpupLdxggZexkTmhHIyY+U4pKlBfxVMyB3pPDCj2w55eA81
         03hz4Yf7O3i/+SsZg3/fYxWFpwyrGGETyikzgK4hrFUCs8K+0G/ZcFX155QYTuaR8cAW
         AwD+O0SoIcEAIA+3LLHSvS8VXwted9956ZkExZ7M2+dDESClrIodd1VHRip1q77snvPt
         nMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KXKqXHgYEUwxzGo3BNl0g5sl1ukNP7c8KeS+9jPHfCY=;
        b=MHsDnueL5EbaWgWCcObcYCs3WNlbFptBxkO16n1I0dETOGhkQtB2wYig6axaN7hO5l
         SoP3AjCdHLBQLp5bgKim2qgCr+IPYSapYtLrvYwvBFWRthmA4rawDlZnEGRY42PHaDRi
         OO9icvLzinqqoqCYtrZlD3XLQyzOi39LIvbd6c2gDlb14KnTP/NJJ3rrdQHTgs0X2xmi
         lpMLyNYJPn5iqXZet8IYY7iYK/N4Q0laKnNHjjJ8XNSKub0bob6t8b1+d1Vhxz4OeRXU
         spiMjq5j7CGerqxADGvt+jILxgZtCEgrVKziWb4SiaSfDtnFjdixe1kRzOLFNxxBIPlg
         t7Zg==
X-Gm-Message-State: AJcUukexcv30+LSg3yBFQ1OrtUYoDoYFsQoY/UXY2D7j8FRVtAJlvJ2O
        EZZL3ReHge9R7e+ZSefg9qw=
X-Google-Smtp-Source: ALg8bN5n4WgOs6Sx9ICatFiJaI8P8GRYyfCUfWJwSsEJvg9SuQxhGOeTJbEAWHL9ycNGqeUmJEXC5A==
X-Received: by 2002:a1c:a3c3:: with SMTP id m186mr8909009wme.16.1546872525236;
        Mon, 07 Jan 2019 06:48:45 -0800 (PST)
Received: from localhost.localdomain ([185.140.29.250])
        by smtp.gmail.com with ESMTPSA id y145sm6973542wmd.30.2019.01.07.06.48.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 06:48:44 -0800 (PST)
Date:   Mon, 7 Jan 2019 15:48:42 +0100
From:   =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
To:     Ajay.Kathat@microchip.com
Cc:     Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Adham.Abozaeid@microchip.com
Subject: Re: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190107144842.GA14681@localhost.localdomain>
References: <20190105091025.GA28917@localhost.localdomain>
 <61a272a5-3c6f-4e69-2ce9-b7c58b427750@lwfinger.net>
 <CAP=P++DRiM8Rb8vg9hBJ-N2uhfL0Rrj+njYwgZW80yQZ4jQH4g@mail.gmail.com>
 <1c5c8efb-055f-31b2-b25f-18d3f6e64226@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c5c8efb-055f-31b2-b25f-18d3f6e64226@microchip.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 07, 2019 at 06:06:55AM +0000, Ajay.Kathat@microchip.com wrote:
Hi Ajay,

> Please resubmit the patch by changing 'frame_type' type to '__le16' in
> 'wilc_reg_frame' struct.

Done, sent patch version 4.

Message subject changed to:
"[PATCH v4] staging: wilc1000: fix registration frame size"
to fit v4 patch content.

Thank you for your review,

Julius
