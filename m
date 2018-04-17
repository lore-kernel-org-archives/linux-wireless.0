Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40798 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754434AbeDQQHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 12:07:20 -0400
Received: by mail-pl0-f66.google.com with SMTP id t22-v6so3620242plo.7
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 09:07:20 -0700 (PDT)
Date: Tue, 17 Apr 2018 09:07:17 -0700
From: Brian Norris <briannorris@chromium.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
Message-ID: <20180417160715.GA255263@rodete-desktop-imager.corp.google.com> (sfid-20180417_180752_052270_468E6995)
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
 <5AD11D7C.1030603@broadcom.com>
 <242be71eb87140c9560163c4000255b2@codeaurora.org>
 <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
 <20180417002854.GA186697@rodete-desktop-imager.corp.google.com>
 <5AD5AEB5.1040808@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5AD5AEB5.1040808@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2018 at 10:22:13AM +0200, Arend van Spriel wrote:
> On 4/17/2018 2:28 AM, Brian Norris wrote:
> > It looks like the status quo for looking for SCHED_SCAN support is to
> > check if NL80211_CMD_START_SCHED_SCAN shows up in the command support
> > list. (IOW, that's what wpa_supplicant does.) We'll probably need to
> > imitate that.
> 
> I believe checking command support is not really recommended. Instead, you
> better check NL80211_ATTR_SCHED_SCAN_MAX_REQS being non-zero (since kernel
> 4.12 that is).

Why not? Command support checking is what wpa_supplicant is doing.

I noticed NL80211_ATTR_SCHED_SCAN_MAX_REQS, but unfortunately, we have
to support older kernels. It looks like randomization was added in
v3.19, and as you point out, that's only available in v4.12.

I welcome other alternatives if you have them to offer.

Brian
