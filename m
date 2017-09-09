Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:45119 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755672AbdIIIM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 04:12:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id f199so14629146wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 01:12:28 -0700 (PDT)
Subject: Re: [PATCH 2/3] brcmfmac: Don't print out-of-bounds event data
To: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
References: <20170908191342.28053-1-cernekee@chromium.org>
 <20170908191342.28053-3-cernekee@chromium.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5bdc8cdb-08d7-cad8-94f8-81d312f1baf3@broadcom.com> (sfid-20170909_101555_149333_2ABEE8ED)
Date: Sat, 9 Sep 2017 10:12:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170908191342.28053-3-cernekee@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08-09-17 21:13, Kevin Cernekee wrote:
> The debug print that dumps out newly-dequeued events uses emsg.datalen
> before that field has been validated, which may lead to an out-of-bounds
> read.  Assume that any properly-formed event message has a valid length
> field, and move the debug print below the length check.

The length check is a bit redundant as event->datalen is assigned to 
emsg.datalen upon queuing the event which also does validation. So I 
would propose to just remove the length check here.

Regards,
Arend

> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
