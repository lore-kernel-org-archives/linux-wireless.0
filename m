Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35457 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbeEVHx2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 03:53:28 -0400
Received: by mail-qt0-f195.google.com with SMTP id f5-v6so22263846qth.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 00:53:27 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20180522004602.19370-1-andrew.zaborowski@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B03CC75.7060908@broadcom.com> (sfid-20180522_095331_635148_CE4BF2A3)
Date: Tue, 22 May 2018 09:53:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180522004602.19370-1-andrew.zaborowski@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 2:46 AM, Andrew Zaborowski wrote:
> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
> from clients other than the connection owner set in the connect,
> authenticate or associate commands, if it was set.
>
> The main point of this check is to prevent chaos when two processes
> try to use nl80211 at the same time, it's not a security measure.
> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
> START_AP/STOP_AP.

Isn't this V2? What has changed since last time?

Regards,
Arend

> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> ---
>   net/wireless/nl80211.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
