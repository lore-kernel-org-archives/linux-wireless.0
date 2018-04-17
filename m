Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:38775 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbeDQA27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 20:28:59 -0400
Received: by mail-pl0-f67.google.com with SMTP id c7-v6so10975257plr.5
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 17:28:59 -0700 (PDT)
Date: Mon, 16 Apr 2018 17:28:56 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: cjhuang@codeaurora.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
Message-ID: <20180417002854.GA186697@rodete-desktop-imager.corp.google.com> (sfid-20180417_022910_720990_FA26BDAE)
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
 <5AD11D7C.1030603@broadcom.com>
 <242be71eb87140c9560163c4000255b2@codeaurora.org>
 <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 16, 2018 at 02:32:47PM +0300, Kalle Valo wrote:
> cjhuang@codeaurora.org writes:
> > On 2018-04-14 05:13, Arend van Spriel wrote:
> >> On 4/13/2018 1:28 PM, Kalle Valo wrote:
> >>> cjhuang@codeaurora.org writes:
> >>>
> >>>>>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
> >>>>>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
> >>>>>> +		if (ret) {
> >>>>>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
> >>>>>> +			goto err_dfs_detector_exit;
> >>>>>> +		}
> >>>>>> +
> >>>>>> +		ar->hw->wiphy->features |=
> >>>>>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
> >>>>>
> >>>>> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?
> >>>>
> >>>> I'll add this flag too.
> >>>
> >>> Are you going to send v2 or what's the plan?
> >>
> >> Maybe a stupid question, but does ath10k support scheduled scan?

Not a stupid question. Sorry for not asking that first.

> AFAICS ath10k does not support it (sched_scan_start() op).

Right, that seems to be the case.

> > The reason is AVL test case needs this flag to enable random mac
> > address scan. Maybe Brian Can explain why this flag is necessary.

I never actually claimed you *needed* this flag; I just wondered how you
claimed to pass our test when you did not support this flag, since our
network manager currently checks for both
NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR and
NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR before enabling MAC
randomization in scans. But that's no matter to worry about here.

> If ath10k does not support scheduled scan what's the point? Shouldn't
> the test case then be it fixed instead of making hacks in ath10k?

Indeed. We're trying to work that out right now.

It looks like the status quo for looking for SCHED_SCAN support is to
check if NL80211_CMD_START_SCHED_SCAN shows up in the command support
list. (IOW, that's what wpa_supplicant does.) We'll probably need to
imitate that.

Brian
