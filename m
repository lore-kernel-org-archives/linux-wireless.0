Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8B4C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 02:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE9921871
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 02:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="em2JgGBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfAECom (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 21:44:42 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40895 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfAECom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 21:44:42 -0500
Received: by mail-ot1-f66.google.com with SMTP id s5so33661203oth.7;
        Fri, 04 Jan 2019 18:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XEfAOPwOwvz5aDgsUDXI7JNifWiyNQ7Lj3bB0oGspJ8=;
        b=em2JgGBfnhDCXdYzW1yUwFduEvuL6gbOw/ux2aQhqytWtHbLXsIwBbVk4SmQqNLK+q
         VoiMF+gtvuYNAb8VbxGtphxoupmdOEXmyc+h0q+gOh3bqo+BXg7wNR02NqrGxi21PX6z
         JWb6bwl3bPh7gxybe27VcuC8wxYp0R+f7i5yjvaxuDiAr4238oF9WIFWUNxOv5xlfh7c
         wmkMwX0X7qq9D1GJwYyFiXEbrP6VIELCJLrirDP8mkg5/KuH/ZI6tJlWw1J/sRNPBnVs
         zxfgEU6xQDzafbqocgTk4dTtBvZl0dBpKTPbsf2ZJqR2nlGjJxiSDVxBbgcJSrZe5QMc
         RuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XEfAOPwOwvz5aDgsUDXI7JNifWiyNQ7Lj3bB0oGspJ8=;
        b=Etjn7ozXWhLJI/nnds0SGAqVvr5ZVsbf/qDqYldpHttlMd3DTIZb4Ped2tCRdQop+F
         iWuTwskIJN4BnwxOBRy0zOthb944t2SGsyXykL/elVlpbFjoEiqoOxqhFss7FIOt+t3R
         W+mAyrVagk2a5b2MEk4WiWMAIp9/YWmvS9t8zPY/tSXYe9L857MVPzPwuVENZ/3ufpPU
         +U+nEyjycJ+idrlXIZhEA8/5GVn0hfSRC7zABsp1C+mjav/shzCUhY0ZkP6sa3wbzrA0
         7SWPcsYRbk69OSh9eRow4mkFsYqWY0qlCNuE5oaRAoLhjHiw+BN4MFGNbUYQ5m0GV39C
         YWxw==
X-Gm-Message-State: AJcUukc0hTsQLcBV1x3TpZHjWQB8t0i1yb/O9fjW0oA/oND5uZBHWILG
        96gNW1l850Of4pMtv7AnqB/VCnYx
X-Google-Smtp-Source: ALg8bN6FFM1b33L0OUKL3fCnq63QFnCWrETcLKlPvK6ubLAKP77ya/X4zxgJMhex3vceBpsOBImN2A==
X-Received: by 2002:a9d:6c3:: with SMTP id 61mr39519217otx.314.1546656280230;
        Fri, 04 Jan 2019 18:44:40 -0800 (PST)
Received: from [192.168.1.102] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k11sm28974152oib.35.2019.01.04.18.44.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 18:44:39 -0800 (PST)
Subject: Re: [PATCH 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling out
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <DB7PR07MB5353320B147CD781B7993783E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f6406c9c-d095-6c9b-55af-0b2fd05c06bb@lwfinger.net>
Date:   Fri, 4 Jan 2019 20:44:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <DB7PR07MB5353320B147CD781B7993783E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/4/19 6:48 AM, Bernd Edlinger wrote:
> This appears to trigger a firmware bug and causes severe
> problems with rtl8723ae PCI devices.
> 
> When the power save mode is activated for longer periods
> of time the firmware stops to receive any packets.
> 
> This problem was exposed by commit 873ffe154ae0 ("rtlwifi:
> Fix logic error in enter/exit power-save mode").
> 
> Previously the power save mode was only active rarely and
> only for a short time so that the problem was not noticeable.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---

While the Realtek firmware group has a chance to look for a bug, I would like 
you to perform a couple of tests on the original code.

The driver has three module parameters that affect power save. The 'modinfo 
rtl8723ae' command lists them as

parm:   ips:Set to 0 to not use link power save (default 1) (bool)
parm:   swlps:Set to 1 to use SW control power save (default 0) (bool)
parm:   fwlps:Set to 1 to use FW control power save (default 1) (bool)

If you were to load rtl8723ae with 'ips=0', does it still fail?
If you were to load the driver with 'swlps=1 fwlps=0', does it still fail?

Thanks for debugging this problem.

Larry

