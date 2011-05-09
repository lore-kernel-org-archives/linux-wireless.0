Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1EIJuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:50:39 -0400
Received: by bwz15 with SMTP id 15so3831974bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:50:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304600420-24227-2-git-send-email-coelho@ti.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	<1304600420-24227-2-git-send-email-coelho@ti.com>
Date: Mon, 9 May 2011 12:50:37 +0300
Message-ID: <BANLkTinfovOLWL1b57kpV5S_LeUMbCatHQ@mail.gmail.com> (sfid-20110509_115043_192402_0A90AB99)
Subject: Re: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2011 at 4:00 PM, Luciano Coelho <coelho@ti.com> wrote:
> Implement new functionality for scheduled scan offload.  With this feature we
> can scan automatically at certain intervals.
>
> The idea is that the hardware can perform scan automatically and filter on
> desired results without waking up the host unnecessarily.
>
> Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> commands to the nl80211 interface.  When results are available they are
> reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> informed when the scheduled scan has stopped with a
> NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
[...]

> +
> +       err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
> +       if (!err)
> +               nl80211_send_sched_scan(rdev, dev,
> +                                       NL80211_CMD_START_SCHED_SCAN);
> +       else {
> +out_free:
> +               kfree(request);
> +               rdev->sched_scan_req = NULL;
> +       }
> +
> +       return err;
> +}

i know it's the same in nl80211_trigger_scan(), but it still looks
very odd - goto into else block?!

Eliad.
