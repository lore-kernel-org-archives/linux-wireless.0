Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35115 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIWJQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:16:18 -0400
Received: by mail-wi0-f174.google.com with SMTP id fb4so4423754wid.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 02:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411151304-31544-1-git-send-email-greearb@candelatech.com>
References: <1411151304-31544-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 11:16:17 +0200
Message-ID: <CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com> (sfid-20140923_111621_178530_AF0DF3C7)
Subject: Re: [PATCH] ath10k: request firmware flush in ath10k_flush.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2014 20:28,  <greearb@candelatech.com> wrote:
[...]
> +       /* If we are CT firmware, ask it to flush all tids on all peers on
> +        * all vdevs.  Normal firmware will just crash if you do this.
> +        */
> +       if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
> +               ath10k_wmi_peer_flush(ar, 0xFFFFFFFF, peer_addr, 0xFFFFFFFF);

I recall you've explained this some time ago, but can you refresh my
memory, please? Is this any different from iterating over all peers
and flushing each? Or does your firmware do so extra magic that is
impossible to do with normal firmware commands?


Michał
