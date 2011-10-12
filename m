Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37013 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JLOCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 10:02:43 -0400
Received: by ywb5 with SMTP id 5so44237ywb.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 07:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318386531-5859-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net> <1318386531-5859-2-git-send-email-Larry.Finger@lwfinger.net>
From: Mark Einon <mark.einon@gmail.com>
Date: Wed, 12 Oct 2011 15:02:23 +0100
Message-ID: <CANK3SE1zJDKry-r-M384jqo7rQezgj2FzbXBLS6SCMiaL934kw@mail.gmail.com> (sfid-20111012_160247_314306_41B53655)
Subject: Re: [PATCH 1/5 V2] rtlwifi: Change PCI drivers to use the new PM framework
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 October 2011 03:28, Larry Finger <Larry.Finger@lwfinger.net> wrote:

>
> +static const struct dev_pm_ops rtlwifi_pm_ops = {
> +       .suspend = rtl_pci_suspend,
> +       .resume = rtl_pci_resume,
> +       .freeze = rtl_pci_suspend,
> +       .thaw = rtl_pci_resume,
> +       .poweroff = rtl_pci_suspend,
> +       .restore = rtl_pci_resume,
> +};
> +

Hi Larry,

You can save a few lines of code here, and in the other files where it
is done - there is a convenience macro for simplifying creating a
pm_ops struct like this, see SIMPLE_DEV_PM_OPS() in pm.h.

Cheers,

Mark
