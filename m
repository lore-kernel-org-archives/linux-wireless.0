Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B01AC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD4820661
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfCHM6w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 07:58:52 -0500
Received: from [208.74.158.174] ([208.74.158.174]:59674 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfCHM6v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 07:58:51 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2019 07:58:51 EST
Received: from [192.168.1.47] (104-235-164-208.evrt.wa.frontiernet.net [104.235.164.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A8E5168B66
        for <linux-wireless@vger.kernel.org>; Fri,  8 Mar 2019 04:53:47 -0800 (PST)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Block ACK in firmware and software decrypt
Message-ID: <934eb713-1f2e-3d06-e168-dbd7bfe83943@candelatech.com>
Date:   Fri, 8 Mar 2019 04:53:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I have run into a slightly tricky problem related to software decrypt
and block-ack handling in ath10k.

For testing purposes, I need to be able to run ath10k firmware in
software-decrypt mode, but the ath10k firmware also handles block
ack frames.  This becomes a problem when using PMF because then the
firmware cannot decrypt the block-ack setup frames and so blockack
fails.

But, the mac80211 stack can indeed decrypt management frames, so I
was thinking maybe I could have a logic flow that looked like this:

ath10k registers with mac80211 on startup and asks to be notified
   of certain management frames once they are decrypted (block-ack req, response)
ath10k sends encrypted frames up the stack to mac80211
mac80211 decrypts frames
mac80211 remembers ath10k wants to see decrypted mgt frames, and so sends
   decoded block-ack req and response frames back to ath10k driver.
ath10k driver use WMI messaging interface to send contents and meta data
   for the decoded block-ack frames to the firmware.
Firmware processes this as if it received it directly off the wire, letting
   block-ack setup work.

So, this is a special case that would only work in my ath10k driver and
firmware, but does anyone else see another reason to allow something like
this into the upstream kernel?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
