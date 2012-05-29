Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41111 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2E2Ow6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:52:58 -0400
Received: by qcro28 with SMTP id o28so1970621qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338203942-5667-15-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	<1338203942-5667-15-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 May 2012 17:52:57 +0300
Message-ID: <CAB3XZEf9Q1ncA-PSU3Ejcn0Tm-3=2XmwCanD5w4dEvafuWh_Gw@mail.gmail.com> (sfid-20120529_165302_435363_4A79A850)
Subject: Re: [RFC 14/14] cfg80211: respect iface combinations when starting operation
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Mon, May 28, 2012 at 2:19 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Use cfg80211_can_change_interface before starting
> up any operation modes such as .start_ap or .auth
> to verify whether we comply with
> num_different_channels within at least one
> interface combination.
>
> Change-Id: I270c18855e28e3b7d63013f66fae5146bfd0826e
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> @@ -168,7 +173,9 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
>        int err;
>
>        wdev_lock(wdev);
> +       mutex_lock(&rdev->devlist_mtx);
>        err = __cfg80211_join_mesh(rdev, dev, setup, conf);

the locking order should be the other way around.

> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 83155ee..9e5cab6 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>        if (!req.bss)
>                return -ENOENT;
>
> +       err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
> +                                           req.bss->channel);

i'm not sure whether it's intended, but cfg80211_mlme_auth() doesn't
take devlist_mtx, so it's missing.

Eliad.
