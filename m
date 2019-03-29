Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E555C10F05
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 14:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79F32184C
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553869022;
	bh=aIBq2YBQwt2ZTQgUPJdoJ1ecKiXtpZegE6FpMvpCNWM=;
	h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=iCuQq+2ePWnP9M1tixoTla3qVCnq5YessG6ggZK/tUQNHn1HW8fOYstRibEEbsfo6
	 5xKlvv5p5qMo82Mb3bn2VKAcoJhrDub6QdPIktS0IB7OS5bSDmc8iU/Trq75yp+Kap
	 nf3DIYWBnhv0eDUs5+G5ePtdFjzp9btHVTmQFgr8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfC2ORC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbfC2ORB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 10:17:01 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6AA206C0;
        Fri, 29 Mar 2019 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553869021;
        bh=aIBq2YBQwt2ZTQgUPJdoJ1ecKiXtpZegE6FpMvpCNWM=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=YtAGe87jDie1xCh/z/APg+jW5fACWoZFfMPp//kzqhJWRecs4KTHnhC1b3Ty5sGgL
         5dqZ7Po3eBm/Aj7CWiTMJeMh4AwsscPFsz6u8P6QA+eJDHrd/Pon7D/TAU7wkI9YV5
         qooIqmVKfuN4Yc8GxbvsJ1EgboSr46uHCls505VY=
Date:   Fri, 29 Mar 2019 14:16:59 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
To:     Vijayakumar Durai <vijayakumar.durai1@vivint.com>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.1] rt2x00: do not increment sequence number while re-transmitting
In-Reply-To: <1553680997-19511-1-git-send-email-sgruszka@redhat.com>
References: <1553680997-19511-1-git-send-email-sgruszka@redhat.com>
Message-Id: <20190329141700.EA6AA206C0@mail.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.0.5, v4.19.32, v4.14.109, v4.9.166, v4.4.177, v3.18.137.

v5.0.5: Build OK!
v4.19.32: Build OK!
v4.14.109: Build OK!
v4.9.166: Build OK!
v4.4.177: Failed to apply! Possible dependencies:
    262c741e0825 ("rt2x00: fix monitor mode regression")

v3.18.137: Failed to apply! Possible dependencies:
    2359b5c2d950 ("staging: vt6655: replace memcpy() by ether_addr_copy() using coccinelle and pack variables")
    262c741e0825 ("rt2x00: fix monitor mode regression")
    33b1c8c13fb8 ("staging: vt6655: mac80211 conversion: add new rx functions")
    67013f2c0e58 ("staging: vt6655: mac80211 conversion add main mac80211 functions")
    81a4e959f201 ("staging: vt6655: device.h: Comments fixes")
    89cf9be6e6e1 ("staging: vt6655: mac80211 conversion: s_uFillDataHead add power saving poll")
    99b4a7e0a2a4 ("staging: vt6655: dpc.h: Replace C99 // comment by /bin /boot /dev /etc /home /initrd.img /initrd.img.old /lib /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin /snap /srv /sys /tmp /usr /var /vmlinuz /vmlinuz.old */")
    df1404650ccb ("mac80211: remove support for IFF_PROMISC")
    fee7506a121a ("staging: vt6655: mac80211 conversion: add new key functions")


How should we proceed with this patch?

--
Thanks,
Sasha
