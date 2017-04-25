Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38184 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176226AbdDYH4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 03:56:40 -0400
Received: by mail-wm0-f52.google.com with SMTP id r190so88310525wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 00:56:40 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Ensure pointer correctly set if skb data
 location changes
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170424114050.24948-1-james.hughes@raspberrypi.org>
Cc: James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <17dd69e6-1438-3474-aa0a-6c44e68855a5@broadcom.com> (sfid-20170425_095719_529771_8486232D)
Date: Tue, 25 Apr 2017 09:56:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170424114050.24948-1-james.hughes@raspberrypi.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-4-2017 13:40, James Hughes wrote:
> The incoming skb header may be resized if header space is
> insufficient, which might change the data adddress in the skb.
> Ensure that a cached pointer to that data is correctly set by
> moving assignment to after any possible changes.

Hi Kalle,

This one should go on 4.12 queue as well.

Thanks,
Arend

> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> 
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
