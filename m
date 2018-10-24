Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1BFC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 13:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C512075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 13:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qfXodYuj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3C512075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbeJXWDM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:03:12 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:44294 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeJXWDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 18:03:12 -0400
Received: by mail-ed1-f41.google.com with SMTP id z21-v6so5058896edb.11
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 06:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xLtBsGy0EGeNCVryLamRHXP0qGEqQwU74sgMZyYOW2c=;
        b=qfXodYuj2OtG5nu5q47Qm8OmOlWjpxxPt8dBzA9ZufZZfWYoLrWGbRw86Am4FPOaba
         G5duqYcMzbyIdePpAcDWIYt2M7THLmzwADZ41RhDObBThTFhz5NLo8ssOdF22vQqMEad
         pxVK9XNqRbwcIyUKdHDa90MU/jMO3uZF3W62c26rLyWJtgkw1vcnHHObjYlghQo9a232
         pDlnzuRBIV6DOSOZaxHw4XVMYYAlXShe+UhCJdX9GbHy+LvHdzX7IMDH9gaxRDoTwP8k
         y6ucFwrsbA0bcW7ogFwEGPdq2K7Jo5MuqjLRk+86Ni6aBdsZft77Yn+7kdWGPc259MGt
         raAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xLtBsGy0EGeNCVryLamRHXP0qGEqQwU74sgMZyYOW2c=;
        b=JN4VIoFBEiTbnWdFwNpfCuOCJGjqRDU2Ft0/NZVpxhQFTsidIDnYkWGaz95gabFDgw
         Ckqxzjp6zoTP602m1eSAqDCgsvjvve5uZElRTz2vnkG2KJ3eYSVmqx/yEmHhzg11Gm8V
         FgFRCbVV4EeRsxFs1fNEyHWjMtjFIKNZteaLr+FMFP9+ik1tMyDHb3qJiZBiu9NdwTRE
         HEeR5rXwBSeizXBA4R/LhW2voOi86NiHaUrlc0UlTHok171P9TqXxWaPoEt+ZvMSQ/Va
         3MAZTw5tMf45Ks5ggjlNe7/fpknHrCvj1ZeZFOS7nozbziJpLA1c3JNhZ53S7ODMCFwq
         xnAA==
X-Gm-Message-State: ABuFfojoEV/thVbAg4hNAa5RmfL9Hb9B9wOXcz4uGBpQJ3foM21gf/Ko
        hIWHKfoL7hGyABNehYXd3ejfe6F7eRI=
X-Google-Smtp-Source: ACcGV61SR3F0IXDiXLJVH8r4LCrKSM+/4636dUo6zaA+xImMsJruskSvH/kufm8K9WV6+Z9K+YoAOQ==
X-Received: by 2002:aa7:c517:: with SMTP id o23-v6mr19147511edq.73.1540388102326;
        Wed, 24 Oct 2018 06:35:02 -0700 (PDT)
Received: from [128.179.143.135] (tsf-436-wpa-7-135.epfl.ch. [128.179.143.135])
        by smtp.gmail.com with ESMTPSA id h3-v6sm1874704ede.42.2018.10.24.06.35.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 06:35:01 -0700 (PDT)
From:   Sebastien Floury <n.rubiks13@gmail.com>
Subject: Re: Request for brcmfmac4366c-pcie.bin
To:     arend.vanspriel@broadcom.com
Cc:     linux-wireless@vger.kernel.org
Message-ID: <38596c7e-3c92-f382-317d-d37bf80c0101@gmail.com>
Date:   Wed, 24 Oct 2018 15:35:00 +0200
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

Hi,

This is a follow-up to these two past threads concerning the 4366c firmware:

https://www.spinics.net/lists/linux-wireless/msg159634.html
https://www.spinics.net/lists/linux-wireless/msg172063.html

I wanted to if we can still expect the firmware to be released by the 
end of the year? Has it's status changed? Is it still somewhere on the 
roadmap?

Thanks for all your work,
Best,
Sebastien
