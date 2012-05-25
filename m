Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4377 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2EYU7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:59:53 -0400
Message-ID: <4FBFF2B9.1070107@broadcom.com> (sfid-20120525_225957_427933_21646FE6)
Date: Fri, 25 May 2012 22:59:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 tx failures after S3
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com> <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com> <20120524212115.GD26760@thinkpad-t410>
 <4FBEA96D.8030207@hauke-m.de> <20120525141339.GB2895@thinkpad-t410>
 <4FBFB79F.4060609@broadcom.com> <20120525183451.GD2895@thinkpad-t410>
 <4FBFE95F.2080306@broadcom.com> <20120525204459.GE2895@thinkpad-t410>
In-Reply-To: <20120525204459.GE2895@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 10:44 PM, Seth Forshee wrote:
> Before. I printed the value from bcma_host_pci_resume().
> 
> I can easily make a patch that fixes the chipctl register up as needed
> during resume to fix my problem. But based on the fact that other fields
> in the register are also changing value, I'm wondering if more thorough
> handling is needed for the register.

Ok. I dived into b43 and it does disable the wireless core in the
.stop() callback. So I believe it does reinitialize the device when
.start() callback is being called after resume. So I think you should
check the chipctl register at the end of the .start() callback.

> And I'm also a little fuzzy on
> exactly who should be responsible for what in the relationship between
> b43 and the wireless drivers.

I assume you mean bcma instead of b43, right? I admit it is a bit shady,
because bcma is more than just a bus driver. It also contains drivers
for the chipcommon and pcie cores on the device.

Gr. AvS

