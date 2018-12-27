Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C31C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88C8214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbeL0Kcl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 05:32:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbeL0Kcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 05:32:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED92188312;
        Thu, 27 Dec 2018 10:32:40 +0000 (UTC)
Received: from localhost (ovpn-204-120.brq.redhat.com [10.40.204.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F1521A7E8;
        Thu, 27 Dec 2018 10:32:40 +0000 (UTC)
Date:   Thu, 27 Dec 2018 11:32:39 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20181227103238.GB25885@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com>
 <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <CAKR_QVJhTCPiOSV03z5b=zgzeWkd0BQwbD=VDChQzU2dJJbhhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <CAKR_QVJhTCPiOSV03z5b=zgzeWkd0BQwbD=VDChQzU2dJJbhhw@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 27 Dec 2018 10:32:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 25, 2018 at 11:43:09PM +0100, Tom Psyborg wrote:
> Even with your patches that are currently being tested i had interface
> frozen yesterday. 2 android pads, 2 android phones and laptop with
> intel card on win10. Wlan frozen about half an hour after bootup, had
> to restart interface that revelaed more queue problems:
>
> [  238.715836] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [  238.722681] br-lan: port 2(wlan1) entered blocking state
> [  238.728107] br-lan: port 2(wlan1) entered forwarding state
> [ 2403.051342] device wlan1 left promiscuous mode
> [ 2403.056021] br-lan: port 2(wlan1) entered disabled state
> [ 2403.213039] ieee80211 phy1: rt2800_config_channel: Warning - Using
> incomplete support for external PA

Yes, patches will not help if device is not programed properly,
i.e. when external PA is not well configured. I already pointed
this here:
https://lore.kernel.org/linux-wireless/20180815114029.GA1862@redhat.com/

Register programming should be fixed there and also whould be good
to implement watchdog to recover from wifi hung it it happens.

> [ 2403.522622] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 0 failed to flush
> [ 2403.817143] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 1 failed to flush
> [ 2404.058047] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 2 failed to flush
> [ 2404.299509] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 3 failed to flush
> [ 2404.566195] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 0 failed to flush
> [ 2404.806880] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 1 failed to flush
> [ 2405.047624] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 2 failed to flush
> [ 2405.288195] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
> Queue 3 failed to flush

Hmm, this one should be gone. Could you check attached patch?

Thanks
Stanislaw

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800_flush_soc.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index a502816214ab..05a801774713 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -203,7 +203,7 @@ static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
 	.start_queue		= rt2800mmio_start_queue,
 	.kick_queue		= rt2800mmio_kick_queue,
 	.stop_queue		= rt2800mmio_stop_queue,
-	.flush_queue		= rt2x00mmio_flush_queue,
+	.flush_queue		= rt2800mmio_flush_queue,
 	.write_tx_desc		= rt2800mmio_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,

--PEIAKu/WMn1b1Hv9--
