Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2E3Ork (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:47:40 -0400
Message-ID: <1338389256.4511.26.camel@jlt3.sipsolutions.net> (sfid-20120530_164743_718310_9BC0BF02)
Subject: Re: [RFC] cfg80211: don't allow WoWLAN support without CONFIG_PM
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Wed, 30 May 2012 16:47:36 +0200
In-Reply-To: <CAB3XZEdXbxnKVXkvtHASVhFj+M1u6iA636dF0oyc=SEt+=AP5g@mail.gmail.com> (sfid-20120530_164558_100237_CFF9B053)
References: <1338385542.4511.19.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdXbxnKVXkvtHASVhFj+M1u6iA636dF0oyc=SEt+=AP5g@mail.gmail.com>
	 (sfid-20120530_164558_100237_CFF9B053)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 17:45 +0300, Eliad Peller wrote:

> > +#ifdef CONFIG_PM
> >        ret = enable_irq_wake(wl->irq);
> >        if (!ret) {
> >                wl->irq_wake_enabled = true;
> > @@ -5315,6 +5316,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
> >                }
> >        }
> >        disable_irq(wl->irq);
> > +#endif
> 
> i think disable_irq should be outside the ifdef.

Well, ok, I can do that if you want, but you may still want to fix this
for 3.5 since it'll otherwise cause a runtime error (registration
failure) without CONFIG_PM and I don't think this patch will go to 3.5.

johannes

