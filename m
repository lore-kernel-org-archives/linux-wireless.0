Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:45923 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754958AbdIRQ1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 12:27:04 -0400
Received: by mail-pf0-f175.google.com with SMTP id q76so493793pfq.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Sep 2017 09:27:03 -0700 (PDT)
Date: Mon, 18 Sep 2017 09:27:00 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: avoid storing random_mac in private
Message-ID: <20170918162659.GA59044@google.com> (sfid-20170918_182708_031337_038AE329)
References: <1505717702-10342-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505717702-10342-1-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 18, 2017 at 12:25:02PM +0530, Ganapathi Bhat wrote:
> Application will keep track of whether MAC address randomization
> is enabled or not during scan. But at present driver is storing
> 'random_mac' in mwifiex_private which implies even after scan is
> done driver has some reference to the earlier 'scan request'. To
> avoid this, make use of 'mac_addr' variable in 'scan_request' to
> store 'random_mac'. This structure will be freed by cfg80211 once
> scan is done.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Reviewed-by: Brian Norris <briannorris@chromium.org>
