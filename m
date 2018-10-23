Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63074C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D114920652
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBCVAAJd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D114920652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbeJWW27 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:28:59 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:38572 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbeJWW27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 18:28:59 -0400
Received: by mail-oi1-f180.google.com with SMTP id k19-v6so1193760oiw.5;
        Tue, 23 Oct 2018 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=V6sdsEyHcRBKeKo5H2sWdAl869sdVWcQ3fqTDnI5IR0=;
        b=SBCVAAJdqXZkQM98tYffk8tXy6xwsp7UsakGa2VlF/2RdIU5rEFDnxhAijNEfCS7Vq
         QRSRxMpiRCE2/kwrNWtd7SeZuX2CuGKNttkFJG+FfYeV4SMPdUGA1/EJGMshxu3cQGLp
         fT7t45GatZJKcsBXYIpFf+u67BI7FPemIKLnbfPswA5GiA9jANXo+ac3DbmauYP+3p82
         sEsBQlWeDhcXq05Rob5C5nQ8edf813eCpj5DX0pCISQgpYfNrBtPmS1fIbmWa7tJ73NC
         3/Lqtuq/cqnTJcEl1jg4W+qWMYsCDmx20Cf+LPsvb0jWNKiQ9xztKfxBtSOIYPqDAuUj
         OZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=V6sdsEyHcRBKeKo5H2sWdAl869sdVWcQ3fqTDnI5IR0=;
        b=V55Mu7nNJBVua/6WtPDr34t00FuE3h/d3F7xP2n7v79dBX/j3qUJMRDhEhwm8CMMF6
         rq4tPwlRGGd4p6YOwS9tzBsSSP0dXmgPTeZ6j7loF5wE/PLFz+/Pi1XCLCc0pMt+Zvgp
         jNLHlZ6NUSbhj6mJEPi3/VCk/egbtfOXv1uHPuEhlsX07JpRpBX33CEEftCvwHFP3Bin
         JTmuzWEkIo0XSjHZVFIZmR26u2v6oLMUAkZkaNrbbUzCTg85VJixaQpGDf17PMO54ovT
         x1o0CWdA6HpmAJSttt1dl4byThAPrWbhISShPFcv1r+/6FgV+9wx6p/nDYoqtkpR32v5
         mNuw==
X-Gm-Message-State: ABuFfogu/QVkrhNwv+LPGLeK1IUppy23vvnZuwjSaNaPLTNvNQBmbl06
        ci9C2zymeMENPTD571TcrCjDkype
X-Google-Smtp-Source: ACcGV63HTpaQv5ymj2XWJL+JrTb2peq7ZkgYa78OVtF8gqUg63Isn18ttWamfIK71sqmNFqHdlCJNw==
X-Received: by 2002:aca:548b:: with SMTP id i133-v6mr1743515oib.194.1540303522669;
        Tue, 23 Oct 2018 07:05:22 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t53sm438471otf.8.2018.10.23.07.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 07:05:21 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Is Fixes line enough?
Message-ID: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
Date:   Tue, 23 Oct 2018 09:05:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg,

A question has come up on the linux-wireless ML. If a patch has a "Fixes" line, 
is that sufficient to get it flagged as a patch in Stable, or is a "Cc: Stable" 
line also needed?

Thanks,

Larry
