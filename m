Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34342 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIASlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 14:41:20 -0400
Received: by mail-oa0-f41.google.com with SMTP id i7so4034316oag.14
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 11:41:20 -0700 (PDT)
Message-ID: <5404BDCE.1050007@lwfinger.net> (sfid-20140901_204129_584090_DA9F3DA6)
Date: Mon, 01 Sep 2014 13:41:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amitav Mohanty <amitavmohanty01@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Help needed to interpret kernel warning and call trace
References: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com>
In-Reply-To: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2014 01:28 PM, Amitav Mohanty wrote:
> Hey
> 
> How do I interpret the following kernel warning?
> 
> Sep 01 17:13:30 TSS-ARCH kernel: ------------[ cut here ]------------
> Sep 01 17:13:30 TSS-ARCH kernel: WARNING: CPU: 0 PID: 4 at
> net/wireless/reg.c:1806 reg_process_hint+0x2d1/0x460 [cfg80211]()

That warning comes from

        /*
         * Two consecutive Country IE hints on the same wiphy.
         * This should be picked up early by the driver/stack
         */
        if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
                return REG_REQ_OK;
        return REG_REQ_ALREADY_SET;

The problem appears to arise in iwldvm, but before anyone devotes very much
effort to finding the cause, you will need to reproduce it without that "P"
taint. From the module list, the offending module appears to be unloaded, but
the taint remains.

Larry

