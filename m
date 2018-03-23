Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:40621 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbeCWO5z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 10:57:55 -0400
Received: by mail-wr0-f181.google.com with SMTP id z8so12419902wrh.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 07:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521586508.19123.4.camel@sipsolutions.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-11-git-send-email-amitkarwar@gmail.com> <1521586508.19123.4.camel@sipsolutions.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Fri, 23 Mar 2018 20:27:53 +0530
Message-ID: <CAEhWJFnNxUJ-D0TjZWRe_q5hB0UnFmTTxhUX1LpRLYARwYJdcg@mail.gmail.com> (sfid-20180323_155759_176146_10DA856F)
Subject: Re: [PATCH 10/10] rsi: drop RX broadcast/multicast packets with
 invalid PN
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018 at 4:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2018-03-05 at 20:07 +0530, Amitkumar Karwar wrote:
>> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>>
>> This patch adds a check to drop received broadcast/multicast frames
>> if
>> PN is invalid (i.e. not greater than last PN). bc_mc_pn
>> variable added for each interface
>>
> Can you say why you do this rather than letting mac80211 do it?

Thanks for your comment.
I wasn't aware that mac80211 can do this even for decrypted Rx
packets. Only thing is we need to avoid IV stripping. I will create a
patch for it.

Regards,
Amitkumar
