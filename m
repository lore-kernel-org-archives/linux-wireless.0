Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:52258 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdLNT6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 14:58:39 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] cfg80211/nl80211: Optional authentication offload to
 userspace
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
Date: Thu, 14 Dec 2017 20:58:36 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Message-Id: <A0B39E95-DAA8-4676-A0C7-8C21DBFE7DE4@holtmann.org> (sfid-20171214_205842_367686_4E3A302F)
References: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> This interface allows the host driver to offload the authentication to
> user space. This is exclusively defined for host drivers that do not
> define separate commands for authentication and association, but rely on
> userspace SME (e.g., in wpa_supplicant for the ~WPA_DRIVER_FLAGS_SME
> case) for the authentication to happen. This can be used to implement
> SAE without full implementation in the kernel/firmware while still being
> able to use NL80211_CMD_CONNECT with driver-based BSS selection.
> 
> The host driver sends the NL80211_CMD_EXTERNAL_AUTH event to start/abort
> the authentication to userspace and status of authentication is further
> indicated by user space to host driver through the same command
> interface. Such drivers advertise the capability through
> NL80211_EXT_FEATURE_EXTERNAL_AUTH.

don’t we actually need a flag in NL80211_CMD_CONNECT that indicates that userspace is able to actually handle NL80211_CMD_EXTERNAL_AUTH. It is nice that there is feature for userspace to see if the driver supports it, but how is the driver able to offload successfully if it doesn’t know that userspace can do it.

Regards

Marcel
