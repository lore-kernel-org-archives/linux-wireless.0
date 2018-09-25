Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC9DC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 10:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC8BE208D9
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 10:56:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxA3vxPJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC8BE208D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbeIYRDb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 13:03:31 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:39997 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbeIYRDb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 13:03:31 -0400
Received: by mail-it1-f195.google.com with SMTP id h23-v6so14575655ita.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 03:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=So71ISgyavxB7vTDHjlBzyzXeZzU1f7IrT4p4tJ6Y28=;
        b=BxA3vxPJptGPOv329QTyzVkfi20VLFcrlQslfnu92zRqkCPGSI6gXiEKm79FtS8ssP
         IPSmqS5W44AUh/u6vq1L65uiEGQJ4XY2wAZMYyEVkNvEiDOjdKVVaPFJjvjdIVWRt4hl
         kKsnw2vU21CMv5/zT2HUJDHQh9ITS/zIKoIXiuBG4KMgYNiRdl9VM8SsIIBvEwwrFL3N
         9ouFDI9cQR69k8PuUNubGEyTC3dBVftmVMl/CgPxrYPvRjfdgiuyXKIlTNi6/lzhmBsR
         1KNCTkJ9dH5zou23eoNIe4vKr7w+Ho77CZXNV92jYJe/0J2N5770Aj45UXhfG5h8COah
         BtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=So71ISgyavxB7vTDHjlBzyzXeZzU1f7IrT4p4tJ6Y28=;
        b=RnUIoCI9m1QAmB2e3MzB/KZ4jCq5QoP8xQbr8XrWKeuHcTUKMsi72DWfnFQR5vlsQk
         CJy49ZHh8VbI2L63pYukA01uLmd7JP6VvpIQL2nksMuVSI/3AL1Sa4yO+BF8gRx1n3eG
         5+WVn1sHGnvmDvJqZ5XpNUdnYDpp9WDJG7vFG+rSDKCgBIuRXJRIqjOy1mDWRwTHYAJR
         tWDEwbpCg0WoqUgp/KJ64SOm/Szs2kqXnBdTcSu9Jj+ebCuV/m6K+1zmFv3P2em4wjus
         eXfMAWCH/TNMNZue+yUX2QXRYDsNpBVMwGlhO+Asq7DdKQk9BcgOFlza3lXVFfD8AO4f
         FLVg==
X-Gm-Message-State: ABuFfoiL/wOqJH/ZBbTpcv6xNoI80kGTbiusnAYkGRoHm5TEY+66rmgU
        CC6XYv+Jo+kZ7qV60aL2gUzbWVL9woaJQGzJ2Ad5JkjlEFo=
X-Google-Smtp-Source: ACcGV60BVUmuNG1gNYOZ1qWOCpa3jfEWvXZi/o9y9+93IuOBrXzTfWYEAECxnVGPDkwh7kRX9aPrD6tBjF3a5xTNQE0=
X-Received: by 2002:a02:910d:: with SMTP id a13-v6mr379438jag.14.1537872991546;
 Tue, 25 Sep 2018 03:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20180925081933.28553-1-enrique.giraldo@galgus.net>
 <57143da1-1569-bd98-70e9-91cdcd89d1b8@broadcom.com> <CAEbaMQ+N=hUwXta9NbrBpF3YcoCyUNWB=s3cynp4pzFLuFrmDA@mail.gmail.com>
 <1ff1f335-6962-4ace-6b25-562dab939893@broadcom.com>
In-Reply-To: <1ff1f335-6962-4ace-6b25-562dab939893@broadcom.com>
From:   Enrique Giraldo <hgiraldos@gmail.com>
Date:   Tue, 25 Sep 2018 12:56:19 +0200
Message-ID: <CAEbaMQJgOqpvj-mvfL+s836YSii6htodU2YivkFUN1hQ=c8O=w@mail.gmail.com>
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
To:     arend.vanspriel@broadcom.com
Cc:     linux-wireless@vger.kernel.org,
        Enrique Giraldo <enrique.giraldo@galgus.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

What you commented was the first thing that I tried, but doing it, the
radio stays in an inconsistent state and the hostapd is not able to
raise an instance again.
Attached is the log of what is happening:

Tue Sep 25 09:58:10 2018 daemon.notice hostapd: wlan0: DFS-CAC-START
freq=3D5500 chan=3D100 sec_chan=3D1, width=3D1, seg0=3D106, seg1=3D0, cac_t=
ime=3D60s
Tue Sep 25 09:58:29 2018 daemon.notice hostapd: wlan0:
DFS-CAC-COMPLETED freq=3D5500 success=3D0 ht_enabled=3D0 chan_offset=3D0
chan_width=3D3 cf1=3D5530 cf2=3D0
Tue Sep 25 09:58:29 2018 daemon.notice hostapd: wlan0: INTERFACE-DISABLED
Tue Sep 25 09:58:29 2018 kern.info kernel: [   70.650485] br-lan: port
3(wlan0) entered disabled state
Tue Sep 25 09:58:29 2018 kern.info kernel: [   70.665228] device wlan0
left promiscuous mode
Tue Sep 25 09:58:29 2018 kern.info kernel: [   70.669794] br-lan: port
3(wlan0) entered disabled state
Tue Sep 25 09:58:30 2018 daemon.err hostapd: Configuration file:
/var/run/hostapd-phy0.conf
Tue Sep 25 09:58:31 2018 kern.warn kernel: [   72.295668] ath10k_pci
0000:00:00.0: 10.1 wmi init: vdevs: 16  peers: 127  tid: 256
Tue Sep 25 09:58:31 2018 kern.info kernel: [   72.312713] ath10k_pci
0000:00:00.0: wmi print 'P 128 V 8 T 410'
Tue Sep 25 09:58:31 2018 kern.info kernel: [   72.318911] ath10k_pci
0000:00:00.0: wmi print 'msdu-desc: 912  sw-crypt: 0'
Tue Sep 25 09:58:31 2018 kern.info kernel: [   72.326063] ath10k_pci
0000:00:00.0: wmi print 'alloc rem: 38688 iram: 27140'
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: wlan0: INTERFACE-ENABLED
Tue Sep 25 09:58:31 2018 kern.info kernel: [   72.402994] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: wlan0: INTERFACE-DISABLED
Tue Sep 25 09:58:31 2018 daemon.err hostapd: nl80211: Could not
configure driver mode
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: nl80211: deinit
ifname=3Dwlan0 disabled_11b_rates=3D0
Tue Sep 25 09:58:31 2018 daemon.err hostapd: nl80211 driver
initialization failed.
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: wlan0: interface state
UNINITIALIZED->DISABLED
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: wlan0: AP-DISABLED
Tue Sep 25 09:58:31 2018 daemon.notice hostapd: wlan0:
CTRL-EVENT-TERMINATING
Tue Sep 25 09:58:31 2018 daemon.err hostapd: hostapd_free_hapd_data:
Interface wlan0 wasn't started
Tue Sep 25 09:58:31 2018 daemon.notice netifd: radio0 (1809): WARNING
(wireless_add_process): executable path /usr/sbin/hostapd does not
match process 1640 path ()
Tue Sep 25 09:58:31 2018 daemon.notice netifd: radio0 (1809): Device
setup failed: HOSTAPD_START_FAILED

Regards,
EG

El mar., 25 sept. 2018 a las 11:53, Arend van Spriel
(<arend.vanspriel@broadcom.com>) escribi=C3=B3:
>
> On 9/25/2018 11:28 AM, Enrique Giraldo wrote:
> > The main reason is to be able to stop the CAC when you want to make a
> > channel switch and the CAC is ongoing. It's true that the radio would
> > not pass to the next phase, the behavior is the same as when during
> > the CAC a radar event is detected. In the case of aborting, a later
> > action is expected, for example, switch to the desired new channel.
>
> So for mac80211 the function ieee80211_dfs_cancel_cac() indeed seems to
> just abort. So what is the scenario here? If user-space sends
> NL80211_CMD_START_AP with DFS channel, a CAC period is started. So you
> are saying you want to do a channel switch? Does it not make sense to
> issue a NL80211_CMD_STOP_AP and then NL80211_CMD_START_AP for the
> desired channel? Maybe the use-case you are looking at is not AP mode,
> but there is no context whatsoever in the commit message so I can only
> guess.
>
> Regards,
> Arend
>
