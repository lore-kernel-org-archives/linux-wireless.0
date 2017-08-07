Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42878 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751426AbdHGNZh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 09:25:37 -0400
Message-ID: <1502112333.15969.122.camel@coelho.fi> (sfid-20170807_152540_543623_6282BFCE)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Date: Mon, 07 Aug 2017 16:25:33 +0300
In-Reply-To: <87zibbjzel.fsf@kamboji.qca.qualcomm.com>
References: <20170805194331.17426-1-luca@coelho.fi>
         <20170805194331.17426-5-luca@coelho.fi>
         <87zibbjzel.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 04/19] iwlwifi: mvm: add debugfs to force CT-kill
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-08-07 at 16:11 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> > 
> > In order to test the enter/exit CT-kill flow.
> > 
> > Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> The commit log doesn't explain what's CT-kill and how/where it could be
> used. For example, I have no clue what this could be about.

You're right, sorry for that.  I'll update the commit log and submit v2.

Basically CT-kill is a thermal "RF-kill".  Whenever the NIC gets too
hot, we shut it down to prevent further damage.  This is nothing new. 
What this patch is adding is a fake way to simulate the NIC getting too
hot by kicking off a debugfs entry, in the same way the FW would kick it
off by sending a notification to the driver.

This is mostly for R&D, but it's very useful for us and I we need it for
our internal tests.  Not that useful for non-developers but I didn't
want to carry this in internal driver to avoid unnecessary conflicts
when syncing it with upstream.

--
Luca.
