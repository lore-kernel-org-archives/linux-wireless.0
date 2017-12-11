Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35238 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdLKPlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 10:41:44 -0500
Received: by mail-pf0-f173.google.com with SMTP id j124so11808405pfc.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 07:41:44 -0800 (PST)
Date: Mon, 11 Dec 2017 07:41:40 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: Loic Poulain <loic.poulain@linaro.org>, kvalo@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
        wcn36xx@lists.infradead.org, k.eugene.e@gmail.com
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
Message-ID: <20171211154140.GD4803@minitux> (sfid-20171211_164148_345538_2F945526)
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
 <20171211153403.GA30332@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171211153403.GA30332@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 11 Dec 07:34 PST 2017, Ramon Fried wrote:

> On Mon, Dec 11, 2017 at 10:52:22AM +0200, Loic Poulain wrote:
> > Since driver does not report hardware dynamic power saving cap,
> > this is up to the mac80211 to manage power saving timeout and
> > state machine, using the ieee80211 config callback to report
> > PS changes. This patch enables/disables PS mode according to
> > the new configuration.
> > 
> > Remove old behaviour enabling PS mode in a static way, this make
> > the device unusable when power save is enabled since device is
> > forced to PS regardless RX/TX traffic.
> > 
> 
> Hi.
> I tried to see if this patch solves the ping delay once power save is
> turned on and it appears it doesn't (log below).
> I do see some change in the delay though in comparison to testing without the patch.
> Bjorn, How did you test it ?
> 

Without this patch I get ping times around a second and SSH is not
usable, with this patch I see similar ping times as you, but SSH is
usable.

I have not been able to run iperf, because I keep hitting
https://bugs.96boards.org/show_bug.cgi?id=663

Regards,
Bjorn
