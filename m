Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14954 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbcBINqi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 08:46:38 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 3/3] mwifiex: parse host wakeup configuration from
 device tree
Date: Tue, 9 Feb 2016 13:46:32 +0000
Message-ID: <22cf216e43834751b9148f0bf86dfaf9@SC-EXCH04.marvell.com> (sfid-20160209_144643_089199_4E25C420)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <1454926528-17480-3-git-send-email-akarwar@marvell.com>
 <2675319.xbIeWCdnho@wuerfel>
In-Reply-To: <2675319.xbIeWCdnho@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd

> mwifiex_platform_driver = {
> >  	.driver = {
> >  		.name	= "mwifiex_plt",
> >  		.of_match_table = mwifiex_dt_match,
> > +#ifdef CONFIG_PM_SLEEP
> > +		.pm             = &mwifiex_plt_pm_ops,
> > +#endif
> >  	}
> >  };
> 
> Just remove the #ifdef here, and mark the functions as __maybe_unused.
> 

Sure. I will take care of this.

Regards,
Amitkumar Karwar
