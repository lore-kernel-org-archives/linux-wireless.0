Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34443 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756048AbcLNQiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 11:38:20 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so325178wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 08:38:05 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: add accounting for the extended peer statistics
Date: Wed, 14 Dec 2016 17:38:02 +0100
Message-ID: <1859306.unY1Rqbrx8@debian64> (sfid-20161214_173826_290786_1D08D1CC)
In-Reply-To: <20161214073337.GA4046@atheros-ThinkPad-T61>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com> <2870294.lMmxz9iPmq@debian64> <20161214073337.GA4046@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 14, 2016 1:03:38 PM CET Mohammed Shafi Shajakhan wrote:
> > On Wednesday, December 7, 2016 11:58:24 AM CET Mohammed Shafi Shajakhan wrote:
> > > On Mon, Dec 05, 2016 at 10:52:45PM +0100, Christian Lamparter wrote:
> > > > @@ -409,10 +410,12 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> > > >  			goto free;
> > > >  		}
> > > >  
> > > > +		if (!list_empty(&stats.peers))
> > > 
> > > [shafi] sorry please correct me if i am wrong, for 'extended peer stats' we are checking
> > > for normal 'peer stats' ? Is this the fix intended, i had started a build to
> > > check your change and we will keep you posted, does this fix displaying
> > > 'rx_duration' in ath10k fw_stats.
> > The idea is not to queue any "extended peer stats" when there where no "peer stats" to
> > begin with. Because otherwise, the function is still vulnerable to OOM since the 
> > extended peers stats will be queued unchecked (not that this is currently a problem).
> 
> [shafi] list_splice_tail_init should still check for non-empty 'peers_extd' list
> and append if required ? please let me know if i am still missing something
Well, you can also count the entries in peers_extd and delete the old entries
if they start to overflow. If you want to do it differently, please go ahead.

Regards,
Christian
