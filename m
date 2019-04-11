Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,SUBJ_ALL_CAPS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1A7C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 22:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56A412184B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 22:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdkaoMUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfDKWa5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:30:57 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35533 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfDKWa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 18:30:57 -0400
Received: by mail-oi1-f196.google.com with SMTP id j132so6360149oib.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2019 15:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Lr9XeTmqTeAi4DLAhh2xaqVbt7+IWvuXKTtG8tTZwlw=;
        b=IdkaoMUHliSoAZ6741xxxP+15grpolT4vZWnekgyV9yW7UQyYaNrZlbT5Zb9A4+qjC
         3nTiymwchJCcBIu52HXS5sYJnYQXNnps5nq6Y5dHuhSEoyStkNsukQJ4GjBc4nfhhZ3F
         Ekrl/Lm854dOMO+pLmmIOsrui1Y3slAXFS88f7bu30Gub135DOUyK2YHyt40k0nOcT7F
         Pt/+x24lGW6PSjiHeHF9FPGdXhACiEt2r79TnIfXAsuNse8a55tBUe3/mX0IAY8vi/bq
         B31k5mNSvRS1HFSHeTzO4dhQ2eVoA6brAh9/7/6EUWUsR5Q/WJCo/n9TRdIkBLjjNP9r
         P6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Lr9XeTmqTeAi4DLAhh2xaqVbt7+IWvuXKTtG8tTZwlw=;
        b=sPA7a0F8t41OrjpAK9efhMXVhgesVA46qGQseMg91mIDLl+p69YE2IcdMGv3w4wexW
         jYcPKexBqwxtQYQo1Ur9T+krK9GNko/Fz0vwuORH3m7TZ87XkEaau9QFfNji7pZ3IfP4
         RpcYIDJQIk1xk3/mHXpwa1+WEmx0NZQAq3mRdSekjiY4n/xoLCCM2S9/0B7OCAVZxfeW
         qu8s+WXdZpnTqnW06tZUdpAsuKV2+fFEA+LxNB2ih9G477ls8YgbmUmaAsF3iXz1dKxu
         sr09187Sw/ltXIKKQ5b+4vWNvlL/7Z5lofDc2WUyroCWk7FoDfhdSgViRlJUF7vE1tfY
         Qlog==
X-Gm-Message-State: APjAAAXGChP1rmuzkvnJyIU4aEXSIPRB8c/CysB7xVuiBL+vy0WprO6/
        BtUm4mPGzkb5EsEyxaiLwAGrbgS2
X-Google-Smtp-Source: APXvYqw44oplYO6xhFRyCoXhg/8uI7U8z926RJtMkrtJOYWINiYhSssZRNMgDOZQh2ZDsFNyA3DRrQ==
X-Received: by 2002:aca:5904:: with SMTP id n4mr7620804oib.122.1555021856540;
        Thu, 11 Apr 2019 15:30:56 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id 30sm20222947otq.62.2019.04.11.15.30.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:30:55 -0700 (PDT)
To:     linux-wireless@vger.kernel.org
From:   Denis Kenzior <denkenz@gmail.com>
Subject: NL80211_SCAN_FLAG_RANDOM_ADDR ?
Message-ID: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
Date:   Thu, 11 Apr 2019 17:30:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I've been poking around at how this flag is used and I noticed this 
check in net/wireless/nl80211.c:

nl80211_check_scan_flags()

         if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
                 int err;

                 if (!(wiphy->features & randomness_flag) ||
                     (wdev && wdev->current_bss))
                         return -EOPNOTSUPP;


The above disallows the use of RANDOM_ADDR for scans while connected. 
The nl80211.h uapi header seems to concur:

  "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports 
using a random MAC address during scan (if the device is unassociated);"

However, if I create a P2P Device (in addition to the default STA 
device), the kernel happily lets me scan on the wdev while the STA 
interface is connected.

sudo iw phy0 interface add p2p type __p2pdev
sudo iw wdev 0x2 p2p start
sudo iw wdev 0x2 scan randomize

So the immediate question I have is, should the RANDOM_ADDR flag indeed 
be limited to unassociated STA interfaces?  It would seem the hardware 
is capable randomizing even when connected? Please educate me :)

Regards,
-Denis
