Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56865 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbZELOJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 10:09:01 -0400
Received: by fxm2 with SMTP id 2so3349367fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 07:09:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242030669.6930.10.camel@johannes.local>
References: <1242030669.6930.10.camel@johannes.local>
Date: Tue, 12 May 2009 15:09:00 +0100
Message-ID: <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/11/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:

Btw, git-apply nitpicks on your whitespace

    rfkill-rewrite.patch:4335: space before tab in indent.
            mutex_unlock(&rfkill_global_mutex);
    warning: 1 line adds whitespace errors.


I tested on todays wireless-testing, aka v2.6.30-rc5-23297-gbf2c6a3.
Somehow, it triggers an OOPS

Function: req_reg_info_regd
Process: modprobe

Call trace:
wiphy_apply_custom_regulatory
ath5k_regd_init
ath5k_reg_notifier
ath5k_pci_probe
...

Photo: <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#5334936857267342674>

The kernel then hangs later on in the boot process.  It responds to
SysRq, but does not echo normal keypresses.  SysRq+P shows that the
kernel is in the idle task.  I left it for three minutes, but I didn't
get any trace from the hung task detector or soft lockup detector.

At first I thought it must be a problem with wireless-testing.
However, it went away when I eventually tried un-applying the rfkill
rewrite patch.

Thanks
Alan
