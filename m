Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44144 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ADVFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 16:05:01 -0500
Received: by fxm20 with SMTP id 20so14481670fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 13:05:00 -0800 (PST)
Message-ID: <4D238B83.7020607@lwfinger.net>
Date: Tue, 04 Jan 2011 15:05:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Breakage in rtlwifi/base.c for 2010-12-24
References: <4D237C41.70607@redfish-solutions.com>
In-Reply-To: <4D237C41.70607@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2011 02:00 PM, Philip Prindeville wrote:
> Anyone else seeing the following breakage?  I'm building the 2010-12-24
> snapshot against 2.6.27.49:
> 
>   CC [M] 
> /home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.o
> 
> /home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c:
> In function '_rtl_init_deferred_work':
> /home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c:229:
> error: implicit declaration of function 'alloc_workqueue'
> /home/philipp/astlinux/build_i586/compat-wireless-2010-12-24/drivers/net/wireless/rtlwifi/base.c:229:
> warning: assignment makes pointer from integer without a cast

The call create_workqueue() is obsolete and is being replaced by
alloc_workqueue(). Unfortunately, older kernels do not have the newer call. A
patch for compat-wireless has been submitted, but I don't think the package has
rebuilt successfully since then. You have two options: (1) if you do not need a
driver for the RTL8192CE/RTL8187CE cards, then deselect them from the build, or
(2) Find the line in drivers/net/wireless/rtlwifi/base.c that says
       rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
and replace it with
       rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);

Larry
