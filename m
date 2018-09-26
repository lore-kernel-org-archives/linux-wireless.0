Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52332C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 06:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C872089D
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 06:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14C872089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbeIZMYl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 08:24:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:25616 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbeIZMYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 08:24:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2018 23:13:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,305,1534834800"; 
   d="scan'208";a="83316560"
Received: from jaroslaw-mobl.ger.corp.intel.com ([10.252.20.75])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Sep 2018 23:13:20 -0700
Message-ID: <356d6c0a2fd8a1ab0bb3bdf63eecdf26c383349e.camel@intel.com>
Subject: Re: [linuxwifi] iwlwifi crash with Linux 4.18.9
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Udo Steinberg <udo@hypervisor.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 26 Sep 2018 09:13:19 +0300
In-Reply-To: <20180926065026.029a4eba@X220.hypervisor.org>
References: <20180926065026.029a4eba@X220.hypervisor.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.0-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 06:50 +0200, Udo Steinberg wrote:
> Hello all,

Hi Udo,


> I'm experiencing an iwlwifi crash with Linux 4.18.9 in the following
> situation:
>   1) I'm suspending the laptop (into S3 sleep state)
>   2) Sometimes the laptop immediately wakes up again (as if a wake
> event fires)
>   3) In the immediate wakeup case iwlwifi crashes
> 
> I'm not sure if in step 2), iwlwifi or something else is causing the
> immediate
> S3 wakeup after suspend.
> 
> Full dmesg is attached.
> 
> Please CC: me on any replies as I'm not subscribed to the mailing
> lists.

This is a known bug and unfortunately we cannot fix it anymore since
it's a pretty old HW and we don't really have the time to debug it.

For reference, this is the bugzilla entry:

https://bugzilla.kernel.org/show_bug.cgi?id=190281

From your dmesg, it seems that we are trying to cancel an ongoing scan
before going to suspend and that fails and causes the suspend process
to abort.  This explains why it only happens sporadically -- i.e. a
scan must be running when you suspend.

If you're feeling adventurous, you could try to check the code that
sends the scan cancellation request when entering suspend and remove
that or move it earlier somehow.  You don't seem to be using WoWLAN, so
not canceling the scan shouldn't hurt because the FW will be stopped
and started again anyway.

Good luck!

--
Cheers,
Luca.

