Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33368 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2EOOkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:40:18 -0400
Received: by qcro28 with SMTP id o28so4183028qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:40:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337092228.15553.0.camel@jlt3.sipsolutions.net>
References: <1337091676-29441-1-git-send-email-eliad@wizery.com>
	<1337092228.15553.0.camel@jlt3.sipsolutions.net>
Date: Tue, 15 May 2012 17:40:17 +0300
Message-ID: <CAB3XZEd49R_KSAMRwM-B9PW_yzmK7aS9zzFVueA=nrFM7odC=w@mail.gmail.com> (sfid-20120515_164030_305950_AFFE2CC3)
Subject: Re: [PATCH] mac80211: retry auth and assoc on error 17
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 5:30 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-05-15 at 17:21 +0300, Eliad Peller wrote:
>> In some congested environments APs return
>> WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA on auth/assoc
>> attempt. Instead of failing immediately, retry again
>> in 200 msec.
>
> I think this should be in wpa_supplicant?
>
it behaves similarly to WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY, which
handled by mac80211, so i thought it would be fine to handle it as
well (and this way it can also be used by iw).

Eliad.
