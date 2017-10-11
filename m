Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44510 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbdJKHsH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 03:48:07 -0400
Message-ID: <1507708082.1998.9.camel@sipsolutions.net> (sfid-20171011_094833_403007_071FBBE2)
Subject: Re: [PATCH v3] mac80211: aead api to reduce redundancy
From: Johannes Berg <johannes@sipsolutions.net>
To: Xiang Gao <qasdfgtyuiop@gmail.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 11 Oct 2017 09:48:02 +0200
In-Reply-To: <20171011023149.18021-1-qasdfgtyuiop@gmail.com> (sfid-20171011_043254_406148_2E5F049A)
References: <20171011023149.18021-1-qasdfgtyuiop@gmail.com>
         (sfid-20171011_043254_406148_2E5F049A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 22:31 -0400, Xiang Gao wrote:
> Currently, the aes_ccm.c and aes_gcm.c are almost line by line copy
> of
> each other. This patch reduce code redundancy by moving the code in
> these
> two files to crypto/aead_api.c to make it a higher level aead api.
> The
> file aes_ccm.c and aes_gcm.c are removed and all the functions there
> are
> now implemented in their headers using the newly added aead api.

Applied. FWIW, the sta_dynamic_down_up test that the robot complained
about, and the PSK tests that heavily use CCMP all pass.

johannes
