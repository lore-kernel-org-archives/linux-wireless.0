Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33729 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbcBNReF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 12:34:05 -0500
Received: by mail-lf0-f66.google.com with SMTP id e36so6361548lfi.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2016 09:34:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
	<1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
Date: Sun, 14 Feb 2016 19:34:02 +0200
Message-ID: <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com> (sfid-20160214_183409_595882_40E438C4)
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the driver
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2016 at 1:56 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> From: Eliad Peller <eliad@wizery.com>
>
> If protocol offloading is configured, the fw might generate some
> frames (e.g. arp response) on its own during d3/d0i3.
>
> On d3/d0i3 exit the driver queries the updated PN (if relevant),
> and updates its keys (for the d0i3 case, this is done by
> iwl_mvm_d0i3_exit_work(), which is scheduled on d0i3 exit)
>
> While in d0i3, iwlmvm defers tx frames until d0i3 exit, and
> then continues their processing.
>
> This is problematic with TKIP, since the frame's PN has already
> been set at this stage (in contrast to CCMP, where the PN is
> being set only later on), so both the frame's PN and the upcoming
> PN update (from d0i3 exit work) might be wrong.
>
> Fix it by moving the TX PN assignment (for TKIP) to the driver,
> similarly to CCMP.
>
> Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> Johannes, please route this one through your tree - thanks
> ---

Since the 3rd patch needs to be dropped anyway, let's route this one
through my tree as usual.
