Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37768 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629Ab1EIN77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:59:59 -0400
Received: by ewy19 with SMTP id 19so2278548ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:59:57 -0700 (PDT)
Subject: Re: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
In-Reply-To: <BANLkTinfovOLWL1b57kpV5S_LeUMbCatHQ@mail.gmail.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-2-git-send-email-coelho@ti.com>
	 <BANLkTinfovOLWL1b57kpV5S_LeUMbCatHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:59:53 +0300
Message-ID: <1304949593.12586.547.camel@cumari> (sfid-20110509_160236_602892_31BA54E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 12:50 +0300, Eliad Peller wrote:
> On Thu, May 5, 2011 at 4:00 PM, Luciano Coelho <coelho@ti.com> wrote:
> > Implement new functionality for scheduled scan offload.  With this feature we
> > can scan automatically at certain intervals.
> >
> > The idea is that the hardware can perform scan automatically and filter on
> > desired results without waking up the host unnecessarily.
> >
> > Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> > commands to the nl80211 interface.  When results are available they are
> > reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> > informed when the scheduled scan has stopped with a
> > NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> > the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> [...]
> 
> > +
> > +       err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
> > +       if (!err)
> > +               nl80211_send_sched_scan(rdev, dev,
> > +                                       NL80211_CMD_START_SCHED_SCAN);
> > +       else {
> > +out_free:
> > +               kfree(request);
> > +               rdev->sched_scan_req = NULL;
> > +       }
> > +
> > +       return err;
> > +}
> 
> i know it's the same in nl80211_trigger_scan(), but it still looks
> very odd - goto into else block?!

Good point, looks a bit ugly and it was indeed copied.  I'll clean it up
a bit.

-- 
Cheers,
Luca.

