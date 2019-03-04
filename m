Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3860FC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 12:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0831620815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 12:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfCDMpW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:45:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfCDMpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 07:45:22 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 038223082E71;
        Mon,  4 Mar 2019 12:45:22 +0000 (UTC)
Received: from localhost (unknown [10.43.2.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C81F5D9CA;
        Mon,  4 Mar 2019 12:45:19 +0000 (UTC)
Date:   Mon, 4 Mar 2019 13:45:08 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] mt76x02: enable AP mode for USB
Message-ID: <20190304124507.GA11047@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
 <1551692896-7062-12-git-send-email-sgruszka@redhat.com>
 <20190304105506.GB3073@localhost.localdomain>
 <20190304110427.GA2008@redhat.com>
 <20190304110847.GC3073@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304110847.GC3073@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 04 Mar 2019 12:45:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 04, 2019 at 12:08:48PM +0100, Lorenzo Bianconi wrote:
> > How this should be done ? Is sufficient to check IEEE80211_CHAN_RADAR
> > and mt76_is_usb() on set channel end return -EINVAL error ? Or different
> > way ?
> 
> Re-reading my email I was not so clear, sorry. I mean we need to clear
> radar_detect_widths for mt76_usb or as suggested by Felix to have a new
> iface_combinations for mt76_usb where we do not set radar_detect_widths

This seems to be already handled by mac80211 if we do not set
iface combinations. On channels like this:

		Frequencies:
			* 5180 MHz [36] (23.0 dBm)
			* 5200 MHz [40] (23.0 dBm)
			* 5220 MHz [44] (23.0 dBm)
			* 5240 MHz [48] (23.0 dBm)
			* 5260 MHz [52] (23.0 dBm) (radar detection)
			  DFS state: usable (for 37 sec)
			* 5280 MHz [56] (23.0 dBm) (radar detection)
			  DFS state: usable (for 37 sec)
			* 5300 MHz [60] (23.0 dBm) (radar detection)
			  DFS state: usable (for 37 sec)
			* 5320 MHz [64] (23.0 dBm) (radar detection)


Hostap fails on channel=52 with error:

Mar 04 13:39:33 dhcp-27-155.brq.redhat.com hostapd[10902]: wlan0: IEEE 802.11 Configured channel (52) not found from the channel list of current mode (2) IEEE 802.11a
Mar 04 13:39:33 dhcp-27-155.brq.redhat.com hostapd[10902]: channel [4] (52) is disabled for use in AP mode, flags: 0x79 RADAR

On channel=36 hostapd succeed to start.

Stanislaw 
