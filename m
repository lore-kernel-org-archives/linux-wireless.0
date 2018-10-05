Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34EEC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46B220875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46B220875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbeJEP2d convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:28:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33993 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeJEP23 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:28:29 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1g8LVY-0005p1-IQ
        for linux-wireless@vger.kernel.org; Fri, 05 Oct 2018 08:30:48 +0000
Received: by mail-pf1-f198.google.com with SMTP id n23-v6so4485329pfk.23
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=G0wX4OWQOKY8mwxXK2Npgsg3zBYShCED/kWqHiDPWPA=;
        b=NlomknZXS6HWb6Rv5fndKMsamYFzopKeR8cuEB5n/FJwS3OOBoPJRkJa3Gy98RB/3j
         azGZ8PYRpcCjneb455RMjgPBlBMtgahrardpAPFPpd5TzDtZan9ZSxWdldYle1Zr2yOQ
         paXip9nRZifJ82gYesWTM61GkYXK5aEqZCCfBDLpVHXmKqLVVB9wdxquyEAAmO8JNGp4
         7L+KLfskOBKBn5XxocjsiWeWM16PqEovpA7TEMqB31Cs+mkCQIy40dtzzmtbkaeu0G2a
         3uyReYRDeEpqQUv9swxcD3xUMKRinj8/6ZdQxPvygUjss2GW4WgZ2RAFjaiqVaZHfyCf
         zzrg==
X-Gm-Message-State: ABuFfohyRFR4ZjagBMph3Qmz8BsU6rGz19ROJBXk3H+Ufd4zz0dBv2Nt
        ug4b+hV8XSWuHeQYMd1IlO7o0XSi5TlwFokUYCK7mwdS4FdhBypH7VvqMDoLTrKiFMWNGmRe8JI
        pl0RC6Ie1+aIYeeCe3lAFtPgre2vAVWVQEUM8IMfC10GL
X-Received: by 2002:a63:82c6:: with SMTP id w189-v6mr9143757pgd.211.1538728246801;
        Fri, 05 Oct 2018 01:30:46 -0700 (PDT)
X-Google-Smtp-Source: ACcGV60I5rXoUsJ+MWBUoRY2yzM4sdstMhIlr9LQOEyRn2zvXIzhg2jEcsm3c/49JgrlMifIoMiIxg==
X-Received: by 2002:a63:82c6:: with SMTP id w189-v6mr9143735pgd.211.1538728246468;
        Fri, 05 Oct 2018 01:30:46 -0700 (PDT)
Received: from [10.101.46.95] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id g65-v6sm12768098pfg.98.2018.10.05.01.30.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Oct 2018 01:30:45 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <910F8A29-3141-422F-87EE-7BFBCDE9060C@holtmann.org>
Date:   Fri, 5 Oct 2018 16:30:41 +0800
Cc:     Matt Chen <mattsled@gmail.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D0880587-6660-4DD2-8C20-BCE00AB0CA2E@canonical.com>
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
 <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
 <81B978A9-270E-4C0B-BE67-D05899B1BC3B@canonical.com>
 <CALx5=V_0fyTcpTdYh=ZOLWL79cop1F=5GyMuK6S9QnP5qHKouQ@mail.gmail.com>
 <24BAAAAB-17E4-4820-A09A-50984B8EBA40@canonical.com>
 <910F8A29-3141-422F-87EE-7BFBCDE9060C@holtmann.org>
To:     Marcel Holtmann <marcel@holtmann.org>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marcel,

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

Here’s the dmesg | grep Bluetooth:
[    6.086600] Bluetooth: Core ver 2.22
[    6.086618] Bluetooth: HCI device and connection manager initialized
[    6.086621] Bluetooth: HCI socket layer initialized
[    6.086625] Bluetooth: L2CAP socket layer initialized
[    6.086632] Bluetooth: SCO socket layer initialized
[    6.107794] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2014
[    6.112803] Bluetooth: hci0: Device revision is 5
[    6.112805] Bluetooth: hci0: Secure boot is enabled
[    6.112805] Bluetooth: hci0: OTP lock is enabled
[    6.112806] Bluetooth: hci0: API lock is enabled
[    6.112807] Bluetooth: hci0: Debug lock is disabled
[    6.112808] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    6.115231] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
[    6.210353] Bluetooth: hci0: Failed to send firmware data (-38)
[    8.153357] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.153358] Bluetooth: BNEP filters: protocol multicast
[    8.153362] Bluetooth: BNEP socket layer initialized
[   13.563790] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2014
[   13.568806] Bluetooth: hci0: Device revision is 5
[   13.568808] Bluetooth: hci0: Secure boot is enabled
[   13.568809] Bluetooth: hci0: OTP lock is enabled
[   13.568810] Bluetooth: hci0: API lock is enabled
[   13.568811] Bluetooth: hci0: Debug lock is disabled
[   13.568813] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[   13.569072] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
[   15.220327] Bluetooth: hci0: Waiting for firmware download to complete
[   15.220805] Bluetooth: hci0: Firmware loaded in 1618764 usecs
[   15.220877] Bluetooth: hci0: Waiting for device to boot
[   15.233031] Bluetooth: hci0: Device booted in 11881 usecs
[   15.233274] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-11-5.ddc
[   15.236794] Bluetooth: hci0: Applying Intel DDC parameters completed
[   17.232497] Bluetooth: RFCOMM TTY layer initialized
[   17.232505] Bluetooth: RFCOMM socket layer initialized
[   17.232510] Bluetooth: RFCOMM ver 1.11

I’ll file a Bugzilla if we need full dmesg as attachment.

> 
> So I am not in favor of this kind of hack and creating dependencies between drivers. If you only have a hammer, then everything looks like a nail. And this is a massive hammer trying to squash everything. This problem needs to be debugged. And this starts by providing affected SKU information and firmware information. So get the details about the SKU and its Bluetooth and WiFi boot loaders.

Apology for the hammer approach, which is the best way I can think of. Of course it’s much better if we can solve this without the ugly hack.

Kai-Heng

> 
> Regards
> 
> Marcel
> 

