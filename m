Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55307 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbeFEKfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 06:35:39 -0400
Received: by mail-wm0-f68.google.com with SMTP id v16-v6so3910172wmh.5
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2018 03:35:38 -0700 (PDT)
Subject: Re: [PATCH 0/3] nl80211: support offloading FILS-SK roaming scenarios
To: Johannes Berg <johannes@sipsolutions.net>
References: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>,
        Jithu Jance <jithu.jance@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B166778.5020807@broadcom.com> (sfid-20180605_123544_088123_692EBCDD)
Date: Tue, 5 Jun 2018 12:35:36 +0200
MIME-Version: 1.0
In-Reply-To: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 10:19 AM, Arend van Spriel wrote:
> This small patch series is based on patch originally submitted by Vidyullatha
> to support driver/firmware roaming for FILS-SK offload. It also reworks the
> connection response code to reuse the fils parameter structure for the ROAM
> event.
>
> The series is intended for 4.18 and applies to the master branch of the
> mac80211-next repository.

Hi Johannes,

Did you miss this series? Any comments?

Regards,
Arend

> Arend van Spriel (2):
>    cfg80211: use separate struct for fils parameters
>    nl80211: add FILS related parameters to ROAM event
>
> Vidyullatha Kanchanapally (1):
>    nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS
>
>   include/net/cfg80211.h       | 51 ++++++++++++++++---------
>   include/uapi/linux/nl80211.h |  6 ++-
>   net/wireless/core.c          |  4 ++
>   net/wireless/nl80211.c       | 90 +++++++++++++++++++++++++++++++++++++-------
>   net/wireless/sme.c           | 88 ++++++++++++++++++++++++++++++-------------
>   5 files changed, 180 insertions(+), 59 deletions(-)
>
> --
> 1.9.1
>
