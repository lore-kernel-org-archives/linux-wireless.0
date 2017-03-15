Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36775 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdCOQ1o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 12:27:44 -0400
Received: by mail-wr0-f180.google.com with SMTP id u108so14602434wrb.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 09:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a22597d0-f0b0-9536-5753-c1bed7a5f20d@candelatech.com>
References: <a22597d0-f0b0-9536-5753-c1bed7a5f20d@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Wed, 15 Mar 2017 09:27:42 -0700
Message-ID: <CAJ-VmokwWxw8BaZHgyfC6D_66WX74ytxPQca+dqCfd7Cb7_UUA@mail.gmail.com> (sfid-20170315_172840_267865_3384C67E)
Subject: Re: Should ath10k enable RX_FLAG_ALLOW_SAME_PN
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

have you verified with a sniffer that it indeed is an A-MSDU that the
hardware is decap'ing for you?

(ath9k doesn't do hardware A-MSDU decap.)

-adrian


On 15 March 2017 at 08:26, Ben Greear <greearb@candelatech.com> wrote:
> We notice a strange problem when receiving ath10k frames in
> raw mode (with modified firmware).
>
> The very first data message (UDP discovery response) is dropped
> in WPA2 + AES mode, and it appears that if we would set the
> RX_FLAG_ALLOW_SAME_PN it would be accepted.  ath9k in software-crypt
> mode does not have this issue as far as we can tell.
>
> So, maybe ath10k should set this flag??
>
> Here is commit ID from the logic that introduced this flag, in case
> that helps jog some memory.
>
> commit f631a77ba920f7153a1094d09cd8f2ebbffd0328
> Author: Sara Sharon <sara.sharon@intel.com>
> Date:   Tue May 3 15:59:44 2016 +0300
>
>     mac80211: allow same PN for AMSDU sub-frames
>
>     Some hardware (iwlwifi an example) de-aggregate AMSDUs and copy the IV
>     as is to the generated MPDUs, so the same PN appears in multiple
>     packets without being a replay attack.  Allow driver to explicitly
>     indicate that a frame is allowed to have the same PN as the previous
>     frame.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
