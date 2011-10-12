Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64852 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JLPUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 11:20:37 -0400
Received: by qadb15 with SMTP id b15so650753qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 08:20:37 -0700 (PDT)
Message-ID: <4E95B041.3000209@lwfinger.net> (sfid-20111012_172041_005120_D845FA8D)
Date: Wed, 12 Oct 2011 10:20:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5 V2] rtlwifi: Change PCI drivers to use the new PM
 framework
References: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net> <1318386531-5859-2-git-send-email-Larry.Finger@lwfinger.net> <CANK3SE1zJDKry-r-M384jqo7rQezgj2FzbXBLS6SCMiaL934kw@mail.gmail.com>
In-Reply-To: <CANK3SE1zJDKry-r-M384jqo7rQezgj2FzbXBLS6SCMiaL934kw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 09:02 AM, Mark Einon wrote:
> On 12 October 2011 03:28, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>>
>> +static const struct dev_pm_ops rtlwifi_pm_ops = {
>> +       .suspend = rtl_pci_suspend,
>> +       .resume = rtl_pci_resume,
>> +       .freeze = rtl_pci_suspend,
>> +       .thaw = rtl_pci_resume,
>> +       .poweroff = rtl_pci_suspend,
>> +       .restore = rtl_pci_resume,
>> +};
>> +
>
> Hi Larry,
>
> You can save a few lines of code here, and in the other files where it
> is done - there is a convenience macro for simplifying creating a
> pm_ops struct like this, see SIMPLE_DEV_PM_OPS() in pm.h.

Mark,

Thanks for the tip.

Larry

