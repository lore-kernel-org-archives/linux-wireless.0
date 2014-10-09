Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64065 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaJIIHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:07:17 -0400
Message-ID: <5436428F.5080803@intel.com> (sfid-20141009_100724_407611_42430BCB)
Date: Thu, 09 Oct 2014 10:08:47 +0200
From: Loic Poulain <loic.poulain@intel.com>
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] net: rfkill: gpio: Implement host wake up support
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com> <1412757280-31367-3-git-send-email-loic.poulain@intel.com> <20141008113845.GB3514@kuha.fi.intel.com> <543545AE.8030900@intel.com> <20141009073854.GA9108@kuha.fi.intel.com>
In-Reply-To: <20141009073854.GA9108@kuha.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Heikki, I'll rework these patches accordingly.

Regards,
Loic

On 09/10/2014 09:38, Heikki Krogerus wrote:
> On Wed, Oct 08, 2014 at 04:09:50PM +0200, Loic Poulain wrote:
>> Thanks, it sounds good to use a label instead of index.
>> However:
>> - DSD is only compatible with BIOS ACPI 5.1
>> - gpiod_get_index does not take care of con_id (label) parameter in case of
>> ACPI (acpi_find_gpio).
>> - gpiod_get calls gpiod_get_index with index 0.
>>
>> Any patch ongoing to support con_id parameter with ACPI?
> Yes. This is the latest version being review as we speak:
> https://lkml.org/lkml/2014/10/6/530
>
> It is really important you get your firmware fixed. We simply can not
> rely on the order of the resources like GPIOs in the resource
> templates. They may be different on every second
> board/BIOS/configuration/whatever. It's even possible for a ACPI
> device object to have two (or more) different resource templates
> describing the same GPIOs in different order which are then selected
> based on some magic condition, for example user selection in BIOS setup.
>
> The existing hardware works with the drivers we have now, and it's not
> possible to change the BIOS/system firmware on those so we just have
> to live with them and rely on being able to pick the correct resources
> based on index. But everything new _must_ use _DSD properties, and
> ACPI 5.1 in general.
>
> So basically your BIOS must produce the ACPI tables according to ACPI
> 5.1. If you are worried about support for ACPI 5.1 in kernel, don't
> worry about it, it's almost ready. And in the meantime, _DSD is just
> something kernel will ignore.
>
>
> Cheers,
>

-- 
Intel Open Source Technology Center
http://oss.intel.com/

