Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E87ECDE46
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 18:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E16820856
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 18:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E16820856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbeJ0Czc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 22:55:32 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:46234 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbeJ0Czc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 22:55:32 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 7FAF740A5ED
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 11:17:27 -0700 (PDT)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Bad WARN_ON spam in mac80211 wake_queue
Organization: Candela Technologies
Message-ID: <407303c7-a18e-4c65-529b-b242f3589cf6@candelatech.com>
Date:   Fri, 26 Oct 2018 11:17:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I made the mistake of configuring 64 ath10k vdevs on an un-modified
4.19-rc5 mac80211, and the (OpenWRT) system mostly killed itself.  I'm not sure
if this is root cause or not, but one of the issues is that this code
hits the WARN_ON in wake_queue() over and over again.  Please make it WARN_ON_ONCE
when you get a chance...my tree is too dirty to make a good patch
in this area.

static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
                                    enum queue_stop_reason reason,
                                    bool refcounted)
{
         struct ieee80211_local *local = hw_to_local(hw);

         trace_wake_queue(local, queue, reason);

         if (WARN_ON(queue >= hw->queues))
                 return;


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

