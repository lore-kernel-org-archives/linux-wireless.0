Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56196 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 22:19:32 -0400
Received: by mail-pa0-f53.google.com with SMTP id kp14so6076824pab.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 19:19:32 -0700 (PDT)
Date: Tue, 6 May 2014 10:19:15 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] rtlwifi: make MSI support a module parameter
Message-ID: <20140506021915.GA3624@adam-laptop> (sfid-20140506_041936_521152_AE303041)
References: <1399278818-19152-1-git-send-email-adam.lee@canonical.com>
 <5367A690.7010305@lwfinger.net>
 <20140505154037.19620ac2@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140505154037.19620ac2@nehalam.linuxnetplumber.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 05, 2014 at 03:40:37PM -0700, Stephen Hemminger wrote:
> On Mon, 05 May 2014 09:56:16 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > On 05/05/2014 03:33 AM, Adam Lee wrote:
> > > This makes MSI support a module parameter, for debugging and workaround
> > > convenience.
> > >
> > > Signed-off-by: Adam Lee <adam.lee@canonical.com>  
> > 
> > Acked-by: Larry Finger <Larry.Finger@lwfinger.net> (for all 3 patches)
> > 
> > I would have made the default for the MSI option to be true, but that is a 
> > matter of preference, and only experience would show which default leads to the 
> > fewer failures. On my laptop, both rtl8188ee and rtl8723be work either way. I am 
> > now working on a driver for the RTL8192EE that also can use MSI - that has only 
> > been tested with the option on.
> > 
> > Larry
> 
> Standard practice is to assume MSI is available, and let the quirks
> in the PCI subsystem reject the request to enable MSI.
> 
> Also other drivers have a 'disable_msi' module parameter why not follow
> their example.
> 

Because some submodule's MSI causes an regression, and other submodules
of rtlwifi are not fully tested under MSI, we need to disable it by
default(regression has higher priority) and have an 'enable_msi' module
parameter for some certain users.

-- 
Adam Lee
