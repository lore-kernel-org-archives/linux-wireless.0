Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1966C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 00:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B9E220855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 00:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sJFy3bw9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B9E220855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbeKIJqU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 04:46:20 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46113 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeKIJqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 04:46:20 -0500
Received: by mail-ed1-f67.google.com with SMTP id b34-v6so354750ede.13;
        Thu, 08 Nov 2018 16:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCW9IhFlZUHL5OG80w8Qvj7wbX0e4e54MjwpDLjvvCk=;
        b=sJFy3bw9l3+Ru89Z08/0oTKSPqgZ9tKbMpv1IltkGtcA9fBY82EsaI+O2T80m0Vqm2
         1HbVLC+ocfBca6phsOhr2kG/Qw1J02DdEcJM55VyZR+e3wV2ubJMf51bkMHe2h+8Gi4g
         LFMffTtXP7Dxzxqk6PSsvZ4yBaMeCBfNub1uetzXKVTXgVCckO9UFV6OHQJQP67LCrEv
         eKbIBIYoTA3UFlFyrWc6b6MvR3qogZEhJ+Gt789uYI6VS9TCeMYlVXqbDAnRZcEa6ae8
         MmPJRWSrpdvl+toTtN+YPQJXp8eTmYGRZStG9MvGkGR2/BNYSS/zBcvaoyXNAhLJk4bH
         1+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCW9IhFlZUHL5OG80w8Qvj7wbX0e4e54MjwpDLjvvCk=;
        b=EbGQUVCXbrz8jVyW1CaHvHBVcRtPVnUe4HTnBmyqEVWRPrPqd2ys6KxX6IHp+QSX/y
         Cm7L90otywsgUL+lCWSnbdgQu2VyokRDg8lB//6I7vSmbwWmQWKQZt7GIadATsm7Fwu+
         HkrjtlwfHuvqn54qLTgJlAYUHthUZOocubnA0wTvQSinfYNP4Yixti++ySsAzcZQU8Zf
         8yZ9y6azqd/9WASaQITpazUiUD6jmdTNosmyIcabSRyYaIjL2DgnNzVpvvhN8pGn6M1C
         OF/TJ4WP88bCmrG1tQ/5mD9uO3ra4qdLi/nvSpyNGkVfbQ4YOy94gT6l4KAW7Xu1lV9A
         LnsA==
X-Gm-Message-State: AGRZ1gIYkmRQnoeYvH5DmzEoqPyIgSP1l17LlEpI+2p+m3j76QhGtuce
        RUJX6sDnzL/H5saZuELvppM=
X-Google-Smtp-Source: AJdET5f3qe3KMBRVOvfYiyGj7DrIwtlHFaMqieFKpyLn7nKwgpK1iBbEOCFSyLEXk/0N9tTWOHg+PA==
X-Received: by 2002:a50:a347:: with SMTP id 65-v6mr312935edn.267.1541722096991;
        Thu, 08 Nov 2018 16:08:16 -0800 (PST)
Received: from kiddo.lan ([2601:602:9400:bc9f::5f2])
        by smtp.gmail.com with ESMTPSA id f18-v6sm1477614edd.75.2018.11.08.16.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 16:08:15 -0800 (PST)
From:   =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
Date:   Thu,  8 Nov 2018 16:08:00 -0800
Message-Id: <20181109000800.15431-1-jprvita@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <910F8A29-3141-422F-87EE-7BFBCDE9060C@holtmann.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Marcel,

> On Oct 4, 2018, at 2:25 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Kai-Heng,
>
>>> I think Canonical were facing some wifi fw load error from some 8260
>>> earlier module during the BT still loading the fw.
>>> I believe we had later 8260 sku that fixed this issue.
>>
>> But there are already 8260 that is affected by this bug in the wild.
>>
>> Search "Bluetooth: hci0: Failed to send firmware data (-38)” and there are lots of user are affected.
>
> which SKUs are these actually. What are the initial details about the boot loader. For the Bluetooth side, you should be able to grab them from dmesg or by running btmon.
>
> So I am not in favor of this kind of hack and creating dependencies between drivers. If you only have a hammer, then everything looks like a nail. And this is a massive hammer trying to squash everything. This problem needs to be debugged. And this starts by providing affected SKU information and firmware information. So get the details about the SKU and its Bluetooth and WiFi boot loaders.
>

I have a Lenovo Yoga 900 which presents this problem and has the same bootloader / firmware information as Kai-Heng already posted:

[    5.992426] Bluetooth: Core ver 2.22
[    5.992438] Bluetooth: HCI device and connection manager initialized
[    5.992442] Bluetooth: HCI socket layer initialized
[    5.992444] Bluetooth: L2CAP socket layer initialized
[    5.992450] Bluetooth: SCO socket layer initialized
[    6.004941] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2014
[    6.010922] Bluetooth: hci0: Device revision is 5
[    6.010923] Bluetooth: hci0: Secure boot is enabled
[    6.010924] Bluetooth: hci0: OTP lock is enabled
[    6.010925] Bluetooth: hci0: API lock is enabled
[    6.010926] Bluetooth: hci0: Debug lock is disabled
[    6.010927] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    6.014253] bluetooth hci0: firmware: direct-loading firmware intel/ibt-11-5.sfi
[    6.014256] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
[    6.613961] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.613966] Bluetooth: BNEP filters: protocol multicast
[    6.613974] Bluetooth: BNEP socket layer initialized
[    6.983804] Bluetooth: hci0: Failed to send firmware data (-38)

And the following product id and revision, from usb-devices:

T:  Bus=01 Lev=01 Prnt=01 Port=06 Cnt=02 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=8087 ProdID=0a2b Rev=00.01
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

I understand the drawbacks with the approach presented here and lack of clear explanation of the problem, but I can confirm these patches work around the problem on my machine. Is there any extra info or test result I can provide to help debug this? I can also dedicate time to help write a different solution if some guidance is provided.

Kai-Heng, did you end up filling a Bugzilla entry for this?

Please CC-me on the replies as I'm not receiving emails from linux-bluetooth or linux-wireless anymore.

Thanks,

--
João Paulo Rechi Vita
http://about.me/jprvita
