Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:58423 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752841Ab2BFKZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:25:37 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	Olof Johansson <olof@lixom.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>
Subject: Re: Re: [PATCH 1/3] net: rfkill-gpio: add device tree support
Date: Mon, 06 Feb 2012 11:25:31 +0100
Message-ID: <2558096.AGHIzMrJ53@fb07-iapwap2> (sfid-20120206_112542_322441_BA58AA68)
In-Reply-To: <20120205195924.GA18267@avionic-0098.adnet.avionic-design.de>
References: <215249735783e9fe35db1c594d901f591725de50.1328461986.git.marvin24@gmx.de> <20120205195924.GA18267@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag, 5. Februar 2012, 20:59:24 schrieb Thierry Reding:
> * Marc Dietrich wrote:
> > +#ifdef CONFIG_OF
> 
> [...]
> 
> > +#else
> 
> [...]
> 
> > +#define of_rfkill_gpio_match NULL
> 
> This can be dropped, see below.
> 
> > +#endif
> > +
> > 
> >  static int rfkill_gpio_probe(struct platform_device *pdev)
> >  {
> >  
> >  	struct rfkill_gpio_data *rfkill;
> >  	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
> > 
> > +	struct device_node *np = pdev->dev.of_node;
> > 
> >  	int ret = 0;
> >  	int len = 0;
> > 
> > +	if (np)
> > +		pdata = rfkill_gpio_parse_pdata(pdev);
> > +
> > 
> >  	if (!pdata) {
> >  	
> >  		pr_warn("%s: No platform data specified\n", __func__);
> >  		return -EINVAL;
> > 
> > @@ -210,13 +268,13 @@ static int rfkill_gpio_remove(struct platform_device
> > *pdev)> 
> >  	return 0;
> >  
> >  }
> > 
> > -
> 
> Are you removing this line on purpose?

of course not ;-)

> >  static struct platform_driver rfkill_gpio_driver = {
> >  
> >  	.probe = rfkill_gpio_probe,
> >  	.remove = __devexit_p(rfkill_gpio_remove),
> >  	.driver = {
> >  	
> >  		   .name = "rfkill_gpio",
> >  		   .owner = THIS_MODULE,
> > 
> > +		   .of_match_table = of_rfkill_gpio_match,
> 
> I think the canonical way to do this is of_match_ptr() and leave out the
> definition to NULL in the !CONFIG_OF above.

yes, the OF api is changing in such a fast way, that it is getting hard to track it, 
especially if there are many drivers which use different generations of it. 

I'll fix it up in the next iteration.

Thanks

Marc

