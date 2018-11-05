Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B8FC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 18:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FAA220819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 18:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=howudodat.com header.i=@howudodat.com header.b="ECPJXa+i";
	dkim=pass (2048-bit key) header.d=howudodat.com header.i=@howudodat.com header.b="wkXFA6Yl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FAA220819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=howudodat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbeKFEES (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 23:04:18 -0500
Received: from wsip-24-234-151-180.lv.lv.cox.net ([24.234.151.180]:45694 "EHLO
        mail.earthbest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbeKFEES (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 23:04:18 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2018 23:04:18 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.earthbest.com (Postfix) with ESMTP id 888492280286
        for <linux-wireless@vger.kernel.org>; Mon,  5 Nov 2018 10:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=howudodat.com;
        s=mail; t=1541442985;
        bh=4MQD2YTbPGqCqlm23cVC9d+lNJRiVqPD+2iQQ3vCmaU=;
        h=To:From:Subject:Date;
        b=ECPJXa+ihBXE9NQKz3GuTs8eTkA8RI7Wu6+Y8+5aYRvecljFqgPMsmQEl+JdiZ5fL
         JAYXexdte7NkGpPQTsWiar+KWAuIeo0p3dVgOVB02/HBgKIRJz/p+iQmqzitsX5EiO
         5iiJpak4g8NnanRF50ttBJwx1isbgM6diJ0MHOyKlnRawOHCd5OQp5GLqoUqIc44Gw
         LPdlvm7V1kvAM1xP9Hj659I7UyV4Zs6DvgWd7VN/L83k4CqmcsJpMS6rJT9LTQx7Xk
         BjcwNdSnlved8BDZxYgkKu8TGPdR6/lHoGf68GgfyA55AOxIoS6fBGDbFqH9AqxUh/
         rwlJZaQf2EcMg==
Received: from mail.earthbest.com ([127.0.0.1])
        by localhost (mail.earthbest.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SW2G1yT4xDUz for <linux-wireless@vger.kernel.org>;
        Mon,  5 Nov 2018 10:36:25 -0800 (PST)
Received: from [192.168.1.172] (router.asus.com [192.168.1.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: peter@howudodat.com)
        by mail.earthbest.com (Postfix) with ESMTPSA id 21379228020F
        for <linux-wireless@vger.kernel.org>; Mon,  5 Nov 2018 10:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=howudodat.com;
        s=mail; t=1541442984;
        bh=4MQD2YTbPGqCqlm23cVC9d+lNJRiVqPD+2iQQ3vCmaU=;
        h=To:From:Subject:Date;
        b=wkXFA6Ylu53FiXqeIm/0r72tLYE3V8xT6rY+QYrZczhvQxlOpmnQcjElEWaO90qlb
         IMFjwc1ibkdgEoGbib3stkwGrjtWXvn7ed4H7VFCjXTtKwUW4UBZorlIJnIAOjdOre
         RUvzmQn5LlN/t8/dEdpuM9WPqkV2uKGEETUQ3UeIylGgWdVd6rRCi7FKrf+9y88JIL
         g50XtHSw4JMZGAYyRvk/DSLjt6PO8BOJEn666xWmKnbILarrOtioItma0Y5sNB+PEh
         /HabLLvJXCn8p5QObxgCKo7jcDxkEM7NACMDy/0Xo/97qK98agYIpgkp5G22xF4P9w
         OaVVVjklIOjuw==
To:     linux-wireless@vger.kernel.org
From:   Peter Carlson <peter@howudodat.com>
Subject: rtl8814au
Message-ID: <8d690f57-2e92-27cd-6f24-6702c1f84294@howudodat.com>
Date:   Mon, 5 Nov 2018 10:36:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We are planning on spinning up a 4x4 mimo mini pcie card using the 
Realtek chip similar to rtl8814au except not usb.  I didn't see anything 
in rtlwifi_new showing support for this chip.  Is this chip going to be 
supported in rtlwifi_new?  Can we provide any help in the development?  
We are looking to combine this with gateworks newport arm64 SBCs.

Peter

PS I'd be glad to take this off list if needed

