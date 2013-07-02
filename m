Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:54922 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab3GBTK7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 15:10:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Shuah Khan <shuah.kh@samsung.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Tue, 2 Jul 2013 12:07:26 -0700
Subject: RE: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from
 legacy pm ops
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2E0635A@SC-VEXCH1.marvell.com> (sfid-20130702_211122_609881_C0725746)
References: <1372778675-2909-1-git-send-email-shuah.kh@samsung.com>
 <51D32116.4010109@hauke-m.de>
In-Reply-To: <51D32116.4010109@hauke-m.de>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

Thanks for your comments.

> > @@ -213,7 +227,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
> >  	if (user_rmmod) {
> >  #ifdef CONFIG_PM
> >  		if (adapter->is_suspended)
> > -			mwifiex_pcie_resume(pdev);
> > +			__mwifiex_pcie_resume(pdev);
> 
> You could use mwifiex_pcie_resume(&pdev->dev) here and then the extra
> function __mwifiex_pcie_resume() is not needed any more.

That makes more sense.

Thanks,
Bing
