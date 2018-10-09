Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA54C67879
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 00:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14FD2145D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 00:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KKUIzuis"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C14FD2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbeJIHux (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 03:50:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37545 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbeJIHux (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 03:50:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id c10-v6so8568361pgq.4
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 17:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gEP5vyUNg0ahlsSAm7QltKua1miImSXcJl2q1c7KW+g=;
        b=KKUIzuisDnTlsS6JyhVQUq/EwHEma6l5Cv7nljne7ZSFlKLBLNsOALUaTUfESkk/DJ
         ueR3VEXZY9edNNUMXo8DhB5S6inM+tA/BWoBQIiUYzlbHIwpUAc/JFGYxUGE+2lNDq/s
         LzjKL+hKlcwUrKYkgyX3oYmil3OyHQDCB8cdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gEP5vyUNg0ahlsSAm7QltKua1miImSXcJl2q1c7KW+g=;
        b=AUigEx6jbOh6wC+j7dx+Wgf4YgJ9/VB1dzliaCa7MPcdTJgSey6mmfHHQbVVT/84tM
         dqcS8NXWZz5dKTCAJYXwHRtUjhhej2YLQnBv2WsEnheQPqGazMlAXUHN901Z30GQkM5b
         apiPx52L0Douzso0P/uzk3tq8zn+q3Vf5ykC8bgo6TanXzkrXimxGH1gHiU5ZrIfgq7S
         DfxiCFlWkDfzbtaqIfEJkxe5lpu8nY0mVhxZY2+EgUsu03/plqi3KrlJKfg9fN3YcQnb
         22JyZbMkMZNfHo4bu+s9Eqcus6oXa/GqJVqKUJLo9Dtv7MDCGvY0rg8KvGddt4bCriFm
         bTOw==
X-Gm-Message-State: ABuFfohCq1gj9gjck/sby4Z6zEMaNm6ofajBnTnu/gtM3DyOs/ISYNxD
        fqzcV2kt60r+EKmevnwl7MGJmQ==
X-Google-Smtp-Source: ACcGV61GRAmjgrSnV6F8WMpPx5AwrZSSv/m83uZ5CeFLJP5mPCnOwGeSmjhsyYuH3w8DucXgKPjQVQ==
X-Received: by 2002:a62:23cd:: with SMTP id q74-v6mr27430907pfj.151.1539045393870;
        Mon, 08 Oct 2018 17:36:33 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id j187-v6sm30846179pfc.39.2018.10.08.17.36.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 17:36:32 -0700 (PDT)
Date:   Mon, 8 Oct 2018 17:36:30 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Govind Singh <govinds@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, niklas.cassel@linaro.org,
        bjorn.andersson@linaro.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 0/6] *** Add support for wifi QMI client handshakes ***
Message-ID: <20181009003628.GA253926@ban.mtv.corp.google.com>
References: <20180815092637.11455-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815092637.11455-1-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-msm

Hi Govind, Kalle,

On Wed, Aug 15, 2018 at 02:56:31PM +0530, Govind Singh wrote:
> Add QMI client handshakes for Q6 integrated WLAN connectivity subsystem.
> This module is responsible for communicating WLAN control messages to FW
> over QMI interface. This patch series enables the qmi handshakes required for
> WCN3990 chipset.
[...]

What's the status of this patchset? It has seen various stages of
review, and except for the fact that Govind seems to have dropped
various Reviewed-by/Acked-by tags (which Rob noticed), I don't see any
relevant feedback that should be blocking it.

I previously had concerns about the firmware boot sequence -- that it
required a Qualcomm-specific TFTP service over QRTR, which had no open
source implementations. There is now a published daemon that worked for
me [1], as well as firmware releases that loaded modem and Wifi firmware
together, such that this TFTP service is not needed at all. So my
concerns there are no longer blocking.

And I think Rob already reviewed the relevant DT bindings (but again,
Govind missed collecting that tag for this series).

So the only outstanding request I see is to collect the appropriate
tags. Should Govind resend the whole series just for that?

FWIW, I've been using this series for a while now, and I reviewed
earlier versions. I can provide this for the whole series:

Reviewed-by: Brian Norris <briannorris@chromium.org>

If nothing else, I think it's important to get someone to merge the DT
bindings from this series, because Govind is now trying to extend the DT
binding and to enable the WCN3990 device node in the SDM845 device tree
nodes.

Regards,
Brian

[1] https://github.com/andersson/tqftpserv
[2] See this series:
    https://patchwork.kernel.org/cover/10621863/
    Govind didn't send it to the right mailing lists yet, but we're
    close...
