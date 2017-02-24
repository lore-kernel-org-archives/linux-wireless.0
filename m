Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35188 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdBXIp6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 03:45:58 -0500
Received: by mail-it0-f68.google.com with SMTP id 203so2312524ith.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 00:45:16 -0800 (PST)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com. [209.85.214.51])
        by smtp.gmail.com with ESMTPSA id r203sm481605itc.5.2017.02.24.00.45.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Feb 2017 00:45:15 -0800 (PST)
Received: by mail-it0-f51.google.com with SMTP id d9so9970353itc.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 00:45:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1487896109-23851-7-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com> <1487896109-23851-7-git-send-email-greearb@candelatech.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Fri, 24 Feb 2017 09:45:14 +0100
Message-ID: <CAOq732+L3KDLP-5E4XnKE0-+TKV6KG_V5AVqeBjQRdyQ5Nr74g@mail.gmail.com> (sfid-20170224_094714_948843_6CA2D5F3)
Subject: Re: [PATCH 162/306] mac80211-hwsim: add length checks before
 allocating skb.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 February 2017 at 01:28,  <greearb@candelatech.com> wrote:
> Modify the receive-from-user-space logic to do length
> and 'is-down' checks before trying to allocate an skb.
>
> And, if we are going to ignore the pkt due to radio idle,
> then do not return an error code to user-space.  User-space
> cannot reliably know exactly when a radio is idle or not.

You probably want to return some error code anyway because 0, if you
compare to the kernel medium, currently maps to the ack returned bit
and is possibly the only way for userspace to set the
HWSIM_TX_STAT_ACK flag in a meaningful way.

Best regards
